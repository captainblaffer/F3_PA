//==================================================================mccfr_fnc_paratroops===============================================================================================
//Contorol the paratroop reinforcement spawn
// Example: [getmarkerpos "mspawn",getmarkerpos "mdrop",getpos player,"GUARD","Aware","WEST",7,"BLU_F"] spawn MCCfr_fnc_paratroops; 
//
// <IN>
//	_posSpawn:				Array, spawn and de-spawn location for the helicopter. 
//	_posLZ:					Array, Fast rope drop point
//  _posWP: 				Array, Waypoint location for unloaded soldiers
//	_WP_behavior		String, The helicopter's cargo will have this behavior ("MOVE","FORTIFY" exc...)
// 	_WP_awareness			String, The helicopter's cargo will have this awareness ("default","safe" exc...)
//	_paraSide:				String, side to call "West","East","Resistance"
//	_paraType:				Integer, 	0 - "paradrop: small - Spec-Ops "
//									1 - "paradrop: medium - QRF"
//									2 - "paradrop: large - Airborne"
//									3 - "drop-off: small - Spec-Ops "
//									4 - "drop-off: medium - QRF"
//									5 - "drop-off: large - Airborne"
//									6 - "fast-rope: small - Spec-Ops "
//									7 - "fast-rope: medium - QRF"
//									8 - "fast-rope: large - Airborne"	
//	_p_mcc_spawnfaction		String, Faction name. 
//===========================================================================================================================================================================	
private ["_posLZ","_posWP","_startPosDir","_heli","_heliCrew","_helocargo","_paraSide", "_paraType", "_helitype",
         "_heli_pilot","_heliPilot","_gunnersGroup","_type","_entry","_turrets","_path", "_timeOut",
		 "_unit", "_side", "_spawnParaGroup", "_paraGroupArray", "_paraGroup", "_paraMode", "_heliCrewCount",
		 "_p_mcc_spawnfaction", "_WP_behavior", "_WP_awareness", "_newParaGroup", "_rampOutPos", "_flyHeight",
		 "_dropPos", "_rope", "_ropes","_heliPad","_theWP","_heliLandWP","_hlpr"
		 ];

_posSpawn				=  (_this select 0);
_posLZ 					=  (_this select 1);
_posWP					=  (_this select 2);
_WP_behavior			= _this select 3;
_WP_awareness			= _this select 4;
_paraSide				= _this select 5;
_paraType 				=  if (TypeName  (_this select 6) == "STRING") then {call compile (_this select 6)} else {(_this select 6)};
//_p_mcc_spawnfaction		= _this select 7;


if(_posSpawn in allMapMarkers)then{
	_posSpawn = getMarkerPos _posSpawn;
}else{
	if (typeName _posSpawn == "ARRAY") then{
	}else{
		_posSpawn = getPos _posSpawn;
	};
};

if(_posLZ in allMapMarkers)then{
	_posLZ = getMarkerPos _posLZ;
}else{
	if (typeName _posLZ == "ARRAY") then{
	}else{
		_posLZ = getPos _posLZ;
	};
};

if(_posWP in allMapMarkers)then{
	_posWP = getMarkerPos _posWP;
}else{
	if (typeName _posWP == "ARRAY") then{
	}else{
		_posWP = getPos _posWP;
	};
};

switch (_paraSide) do {
	case "WEST":
	{
		_p_mcc_spawnfaction = "BLU_F";
	};
	case "EAST": 
	{
		_p_mcc_spawnfaction = "OPF_F";
	};
	case "GUE": 
	{
		_p_mcc_spawnfaction = "IND_F";
	};
	default
	{
		_p_mcc_spawnfaction = "OPF_F";
	};
};

_unitspawned = [];
_paraGroupArray = [];
_customParaGroup = false;
_dropPos = [];
_rampOutPos = [];
_ropes = [];
_actualRopes = [];

waituntil {!isnil "mccfr_make_array_grps"};

// get group configs   player SwitchMove "AsdvPercMstpSnonWrflDnon_goup" 
{
	if ( ((_x select 3) == "Rifle Squad")  ) then //|| ((_x select 3) == "Recon Team")
	{ 
		_paraGroupArray set [count _paraGroupArray, format ["%1", ( _x select 2)]];
	};
} forEach ([_paraSide,_p_mcc_spawnfaction,"Infantry","LAND"] call mccfr_make_array_grps);

if ( (count _paraGroupArray) == 0 ) then
{ 
	_customParaGroup = true;
	_unitsArray = [];
	
	//Let's build the faction unit's array
	{		
		_unitsArray	set [ count _unitsArray, _x select 0];  
	} foreach ( [_p_mcc_spawnfaction,"soldier"] call mccfr_fnc_makeUnitsArray );	

	//diag_log format ["MCC paradrop custom array: %1", _unitsArray];	
	
	if ( (count _unitsArray) == 0 ) exitWith {};
	
	_paraGroupArray set [0, _unitsArray];
	
	//diag_log format ["MCC paradrop custom array: %1", count _paraGroupArray];	
};

if ( (count _paraGroupArray) == 0 ) exitWith { diag_log format ["MCC Warning: no suitable paratrooper group found for %1", _this]; player groupChat format ["Error: no suitable paratrooper group for this Faction"]; };
	
switch (_paraSide) do 
	{
		case "WEST":
		{
			_side = west;
			switch (_paraType % 3) do
			{
				case 0: // 0, 3, 6 
				{ 
					_helitype = "B_Heli_Light_01_F";
					//_spawnParaGroup = _paraGroupArray select 1;
					_spawnParaGroup = _paraGroupArray select ((count _paraGroupArray) -1);
					_ropes = [[0.6,0.5,-25.9],[-0.8,0.5,-25.9]];
				};
				case 1: // 1, 4, 7 
				{
					_helitype = "B_Heli_Transport_01_F";
					_spawnParaGroup = _paraGroupArray select ((count _paraGroupArray) -1);
					_ropes = [[-1.11,2.5,-24.7],[1.11,2.5,-24.7]];
				};
				case 2: // 2, 5, 8 
				{ 
					_helitype = "B_Heli_Transport_03_black_F";
					_spawnParaGroup = _paraGroupArray select 0;
					_ropes = [[1,-5,-26],[-1,-5,-26]];
				};
			};
		};
			
		case "EAST":
		{
			_side = east;
			switch (_paraType % 3) do
			{
				case 0: 
				{ 
					_helitype = "O_Heli_Attack_02_F";
					_spawnParaGroup = _paraGroupArray select ((count _paraGroupArray) - 1);
					_ropes = [[1.35,1.35,-24.95],[-1.45,1.35,-24.95]];
				};
				case 1: 
				{
					_helitype = "RHS_Mi8mt_vdv"; //	O_Heli_Light_02_F
					_spawnParaGroup = _paraGroupArray select ((count _paraGroupArray) -1);
					//_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
				case 2: 
				{ 
					_helitype = "O_Heli_Transport_04_covered_F";
					_spawnParaGroup = _paraGroupArray select 0;
					_ropes = [[1,-5,-26],[-1,-5,-26]];
				};
			};
		};
				
		case "GUE":
		{
			_side = resistance;
			_helitype = "I_Heli_Transport_02_F";
	
			switch (_paraType % 3) do
			{
				case 0: 
				{ 
					_helitype = "I_Heli_light_03_F";
					_spawnParaGroup = _paraGroupArray select ((count _paraGroupArray) -1);
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
				case 1: 
				{
					_helitype = "RHS_Mi8mt_vdv";
					_spawnParaGroup = _paraGroupArray select ((count _paraGroupArray) -1);
					//_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
					_ropes = [[1.3,1.3,-25],[-1.3,1.3,-25]];
				};
				case 2: 
				{ 
					_helitype = "I_Heli_Transport_02_F";
					_spawnParaGroup = _paraGroupArray select 0;
					_ropes = [[1,-5,-26],[-1,-5,-26]];
				};
			};			
		};
	};

//_spawnParaGroup = composeText [_spawnParaGroup];
//if ( isNil "_spawnParaGroup" ) exitWith { diag_log format ["MCC ERROR: no group found for %1", _this]; };
	
	
if ( _paraType < 3 ) then 
{
	_paraMode = 0; // paradrop
	_flyHeight = 400;
}
else
{
	if ( _paraType < 6 ) then 
	{
		_paraMode = 1; // drop-off
	}
	else 
	{
		_paraMode = 2; // fast-rope
	};
	_flyHeight = 50;
};

_heli 				= [_heliType, _posSpawn, _posLZ, _flyHeight, false, _side] call mccfr_fnc_createPlane;		
_heliCrew			= group _heli;
_heliPilot			= driver _heli;
crew _heli joinSilent _heliCrew;
_heliCrew setVariable ["f_cacheExcl", true,true];
{
	_x setSkill ["aimingshake", 0.3];
	_x setSkill ["spottime", 0.25];
	_x setSkill ["spotdistance", 0.5];
	_x setVariable ["ACE_enableUnconsciousnessAI", 0, true];
}foreach units _heliCrew;
/*
if ( _heliType == "I_Heli_Transport_02_F" ) then 
{
	if (_paraSide == "EAST") then 
	{
		_heli setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.635,0.576,0.447,0.5)'];
		_heli setObjectTextureGlobal [1,'#(rgb,8,8,3)color(0.635,0.576,0.447,0.5)'];
		_heli setObjectTextureGlobal [2,'#(rgb,8,8,3)color(0.635,0.576,0.447,0.5)'];
	};
	if (_paraSide == "WEST") then
	{
		_heli setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.960,0.990,0.990,0.1)'];
		_heli setObjectTextureGlobal [1,'#(rgb,8,8,3)color(0.960,0.990,0.990,0.1)'];
		_heli setObjectTextureGlobal [2,'#(rgb,8,8,3)color(0.960,0.990,0.990,0.1)'];
	};	
};*/

_heliCrew setBehaviour "CARELESS";
_heliPilot disableAI "TARGET";
_heliPilot disableAI "AUTOTARGET";

_heliCrewCount = count (crew _heli);

// In case of drop-off or fast-rope return to start position
if ( _paraMode > 0 ) then
{
	_heli flyInHeight _flyHeight;
	_heliPilot flyInHeight _flyHeight;
};

private ["_cargoNum","_unitsArray","_i","_type"];
//--------spawn the jumping group----------------------		
_cargoNum = _heli emptyPositions "cargo"; //populate heli before kick off
_cargoUnits = [];
_cargoGroups = [];

if (_cargoNum > 0) then	
{
	_helocargo = creategroup side _heli;

	_cargoEmtpy = _cargoNum;
	
	// small
	if ( ( (_paraType % 3) == 0 ) && ( _cargoNum >= 6 ) ) then 
	{
		_cargoEmtpy = 6; 
	};
	// QRF
	if ( ( (_paraType % 3) == 1 ) && ( _cargoNum >= 12 ) ) then 
	{
		_cargoEmtpy = 12; 
	};

	
	While { true } do
	{
		if !( _customParaGroup ) then 
		{ 
			_unitspawned=[[100,100,5000], _side, (call compile _spawnParaGroup),[],[],[0.1,0.5],[],[_cargoEmtpy, 0]] call BIS_fnc_spawnGroup;
			sleep 0.1;
		}
		else
		{
			_newParaGroup = grpNull;
			_newParaGroup = createGroup _side;
			for [{_i=0},{_i<=_cargoEmtpy},{_i=_i+1}] do 
			{
				if ( _cargoEmtpy > 0 ) then 
				{
					//diag_log format ["MCC paradrop custom group array: %1", _spawnParaGroup];
					_type = _spawnParaGroup select round (random 4); 
					_unit = _newParaGroup createUnit [_type, _posSpawn, [], 0.5, "NONE"];
				};
			};

			//diag_log format ["MCC paradrop custom group: %1 - %2 - group array: %3", _paraSide, _p_mcc_spawnfaction, units _newParaGroup];
			_unitspawned = _newParaGroup;
		};
		//_unitspawned setVariable ["f_cacheExcl", true,true];
		{
			_cargoUnits set [count _cargoUnits,_x];
			_x setVariable ["ACE_enableUnconsciousnessAI", 0, true];
			
		} forEach (units _unitspawned);
		
		(units _unitspawned) execVM "f\assignGear\f_assignGear_AI.sqf";
			
		_cargoGroups set [count _cargoGroups,_unitspawned];
		_cargoEmtpy = _cargoEmtpy - (count _cargoUnits);
		
		//diag_log format ["Spawned: %1 - %2 - %3 - %4", count (units _unitspawned), count _cargoUnits, _cargoEmtpy, (units _unitspawned)];

		// if only 1 or 2 seats left do not create a 1 or 2-man group but leave seat(s) empty
		if ( _cargoEmtpy < 3 ) exitWith {};  // { diag_log format ["Spawned: aborting: %1", _cargoEmtpy]; };
	};
	
	//diag_log format ["Paradrop: %1 - %2 - %3", _cargoNum, count _cargoUnits, _cargoUnits];
	
	{
		_x assignAsCargo _heli;
		_x moveInCargo _heli;
		_x setSkill ["aimingspeed", 0.6];
		_x setSkill ["aimingaccuracy", 0.6];
		_x setSkill ["aimingshake", 0.6];
		_x setSkill ["spottime", 0.7];
		_x setSkill ["spotdistance", 0.8];
		_x setSkill ["commanding", 1.0];
		_x setSkill ["general", 1.0];
		//removeBackpack _x; 
		//_x addBackpack "B_Parachute";
	} forEach _cargoUnits;
};

//_dropPos = _posLZ findEmptyPosition [100,350,_heliType];
//if ( count _dropPos == 0 ) then { _dropPos = _posLZ; }; 

//randomize LZ
_centre = [ _posLZ , 25 + (random 100) , random 360 ] call BIS_fnc_relPos; 
//Or don't randomize LZ
//_centre =  _posLZ; 

_max_distance = 100;
//_timeOut = time + 5;
/*while{ count _dropPos < 1 && _timeOut > time } do
{
	_dropPos = _centre findEmptyPosition[ 0 , _max_distance , "B_Heli_Transport_03_black_F" ];
	_max_distance = _max_distance + 50;
};*/
_dropPos = [_centre, 0, 200, 7, 0, 0.2, 0, [], [_centre,_centre]] call BIS_fnc_findSafePos;
if ( count _dropPos < 1 ) then { _dropPos = _posLZ; }; 
if ( count _dropPos < 3 ) then { _dropPos pushback 0 }; 
//Set waypoint
_heliPad = "Land_HelipadEmpty_F" createVehicle _dropPos;  //Land_HelipadEmpty_F Land_HelipadCircle_F
if ( _paraMode == 2 ) then 
{
_heliPad setposATL [_dropPos select 0,_dropPos select 1,(_dropPos select 2) + 25];
};
//_heliCrew move _dropPos;
//(driver _heli) move _dropPos;
_heliLandWP = (group (driver _heli)) addwaypoint [_dropPos,10];
_heliLandWP setWaypointType "MOVE";

_heli setSpeedMode "FULL";
//_heli setDestination [_posSpawn, "VehiclePlanned", true];

if ( _paraMode > 0 ) then  //trigger later when parachuting
{
waitUntil { sleep 1;((_heli distance _dropPos) < ((getPosATL _heli select 2) + 100)) || !(canMove _heli)};  // include heli heigth else if flying higher then 250 m this wil be 'true'
} else
{
waitUntil { sleep 1;((_heli distance _dropPos) < ((getPosATL _heli select 2) + 30)) || !(canMove _heli)};  // include heli heigth else if flying higher then 250 m this wil be 'true'
};

if (!(canMove _heli)) exitWith {};

_heli animateDoor ["door_R", 1];
_heli animateDoor ["door_L", 1];

if (typeOf _heli == "I_Heli_Transport_02_F") then
{
	_heli animate ["CargoRamp_Open", 0.5];
	sleep 2;
};		

if ( _paraMode == 2 ) then  // toss ropes for fast-rope
{
	
	_heli flyInHeight 20; 
	sleep 4;		
	//doStop (driver _heli);
	_heli land "GET OUT"; //GET OUT
	_timeOut = time + 180; 
	waitUntil { sleep 1; ( (abs(speed _heli) < 0.9) && ((getPosATL _heli select 2) < 50) )  || !alive _heli || !alive (driver _heli) || (time > _timeOut)};
	
	if ((getPosATL _heli select 2) > 30) then { 
		sleep 7;
	if ((getPosATL _heli select 2) > 30) then {
		_heli setposATL [getposATL _heli select 0,getposATL _heli select 1,30]; 
	};
	}; 
	
	
	/*_heli setVariable ["halt_heli", false, false];
	[_heli] spawn {
		//nul=[heli] execvm "hold.sqf";
		_plane = _this select 0;
		_planePos = getposATL _plane;
		_plane setVariable ["halt_heli", true, false];// heli will stop when script is run

		//_pitchbank = _plane call BIS_fnc_getPitchBank;
		//_pitch     = _pitchbank select 0;
		//_bank      = _pitchbank select 1;

		//hint format ["Pitch %1  Bank %2",_pitch,_bank];

		//_nspeed_x = 0;
		//_nspeed_y = 0;
		//_nspeed_z = 0;
		
		while {canMove _plane and _plane getVariable "halt_heli" and (alive driver _plane)} do 
		{
		//if (_pitch > -5 ) then {_pitch = _pitch - 0.1} else {_pitch = _pitch + 0.1};// slight nose down for better response
		//if (_bank  > 0  ) then {_bank = _bank - 0.1} else {_bank = _bank + 0.1};

		//_speed_Veh =  velocity _plane;
		//_speed_x = _speed_Veh select 0;
		//_speed_y = _speed_Veh select 1;
		//_speed_z = _speed_Veh select 2;

		//if (_speed_x > 0) then {_nspeed_x = _speed_x / 1.01;};
		//if (_speed_y > 0) then {_nspeed_y = _speed_y / 1.01;};
		//if (_speed_z > 0) then {_nspeed_z = _speed_z / 1.0001;};
		for [{_i=0},{_i<50},{_i=_i+1}] do
		{
			[_plane, -2,0] call BIS_fnc_setPitchBank;
			_plane setposATL _planePos;
			//_plane setVelocity [_nspeed_x,_nspeed_y,_nspeed_z];
			sleep 0.01;
		};
		}; 
	};*/
	if (canMove _heli and (alive driver _heli)) then {
	_hlpr = createVehicle [ "VirtualCurator_F", [0,0,100], [], 0, "CAN_COLLIDE"];
	WaitUntil {!isNil "_hlpr"}; 
	_hlpr allowDamage false;
	[[[_hlpr],{(_this select 0) hideObject true;}],"BIS_fnc_spawn",true,false] call BIS_fnc_MP;
	_alt = getpos _heli select 2;
	_hlpr setDir (getDir _heli);
	_hlpr setPos (_heli modelToWorld [0,0,-_alt]); 
    _hlpr setVectorUp [0,0,1]; 
	_heli attachto [_hlpr, [0,0,_alt]];
	deletevehicle _heliPad;
	/*{	
		_rope = createVehicle ["land_rope_f", [0,0,0], [], 0, "CAN_COLLIDE"];
		sleep 0.3;
		_rope allowDamage false;
		_rope disableCollisionWith _heli;
		_actualRopes set [count _actualRopes, _rope];
		_rope setdir (getdir _heli);
		_rope enableSimulation false;
		_rope attachto [_heli, _x];

		sleep 0.5;
	} forEach _ropes;*/
	
	{
		_rope = ropeCreate [_heli, _x, 1];
		sleep 0.3;
		ropeUnwind [_rope, 30, 24, false];
		_actualRopes set [count _actualRopes, _rope];
		sleep 0.5;
	} forEach [[1, -1.3, -2.4],[-1, 4.3, -2.4]];
	
	[_heli,_hlpr]spawn {
	_heli = _this select 0;
	_hlpr = _this select 1;
	while {canMove _heli and (alive driver _heli)} do {sleep 1;};
	deleteVehicle _hlpr;
	};
	};
};

{

	[_x, _heli, _WP_behavior, _WP_awareness, _paraMode, _paraType, _actualRopes, _forEachIndex, count _cargoGroups] spawn 
	{
		private ["_paraGroup", "_dir", "_WP_behavior", "_WP_awareness", "_paraMode", "_paraType", 
					"_actualRopes", "_rope", "_index", "_number"];
		
		_paraGroup 	= _this select 0;
		_heli = (_this select 1);
		_WP_behavior = _this select 2;
		_WP_awareness = _this select 3;
		_paraMode = _this select 4;
		_paraType = _this select 5;
		_actualRopes = _this select 6;
		_index = _this select 7;
		_number = _this select 8;
		_dir = (direction _heli) + 180;

		 switch ( _paraMode ) do
		{
			case 0: // paradrop
			{
				
				_heli flyInHeight (getPosATL _heli select 2); // to maintain current altitude
				
				{
					if (typeOf _heli == "I_Heli_Transport_02_F") then
					{
						sleep 1.6;
						
						_d = if ((speed _heli) <= 40) then {6} else {5};

						_rampOutPos = [_heli, _d, ((getDir _heli) + 180)] call BIS_fnc_relPos;
						_altitude = getPosATL _heli;

						_a = if ((speed _heli) <= 40) then {3} else {0};

						_rampOutPos set [2, ((_altitude select 2) - _a)];
		
						_x setPosATL _rampOutPos;
						_x setDir ((getDir _heli) + 180);
					}
					else
					{
						sleep 0.8;
					};
					
					_x allowDamage false;
					unassignVehicle _x;
					//_x action ["EJECT",vehicle _x];	
					//_x action ["GetOut",vehicle _x];
					moveout _x;
					
					_chute = createVehicle ["NonSteerable_Parachute_F", position _x, [], ((_dir)-5+(random 10)), 'NONE'];
					_chute setPos (getPos _x);
					_chute setDir ((_dir)-5+(random 10));
					_x setDir ( direction _chute );
					_chute setPos (getPos _x);
					_x moveindriver _chute;
					(vehicle _x) setDir ((_dir)-5+(random 10));
					_x allowDamage true;	
				} foreach (units _paraGroup);
			};
			
			case 1: // drop-off
			{
				{
					unassignVehicle _x;
				} foreach (units _paraGroup);
			};
			
			case 2: // fast-rope
			{
				//_heli doMove (getPosATL _heli);
				//doStop _heli;
				//doStop driver _heli;
				if (count _actualRopes > 0) then {
				{					
					if ( _number > 1 ) then 
					{
						_rope = _actualRopes select _index;
					}
					else
					{
						_rope = _actualRopes select (_forEachIndex % 2);
					};
					
					[_x, _rope] spawn 
						{
							private ["_unit", "_zc", "_zdelta", "_rope"];
							_unit = _this select 0;
							_rope = _this select 1;
							_zdelta = 7 / 10;
							_zc = 0; //22
							
							unassignVehicle _unit;
							_unit action ["eject", vehicle _unit];
							//_unit switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSnonWnonDnon"; //"gunner_standup01";  
							
							_unit setpos [(getpos _unit select 0), (getpos _unit select 1), 0 max ((getpos _unit select 2) - 3)];
							
							while { (alive _unit) && ( (getpos _unit select 2) > 1 ) && ( _zc > -24 ) } do 
							{
								_unit attachTo [_rope, [0,0,_zc]];
								_zc = _zc - _zdelta;
								uisleep 0.1;
							};
							
							_unit switchmove "";
							detach _unit;
							_unit setpos (getpos _unit);
						};
					uisleep ( 1 + ((random(6))/10) );
				} foreach (units _paraGroup);
				};
			};
		};
	};
	
	sleep 0.8; // 2nd group will disembark in parallel with offset of 0.8 seconds
	
} foreach _cargoGroups;

if ( _paraMode > 0 ) then  // Drop-off or fast-rope
{
	// if chopper is still around after 40/70 seconds leave to avoid getting stuck
	if ( _paraMode > 1 ) then
	{
		_timeOut = time + 35; 
	}
	else
	{
		_timeOut = time + 35; 
	};

	{
		_x setBehaviour "AWARE";
	} foreach _cargoGroups;
	
	if ( _paraMode != 2 ) then  
	{
	//wait untill all paratroopers are out 
	waitUntil { sleep 1; (count crew _heli == _heliCrewCount) || (time > _timeOut);  };
	};
	// toss ropes for fast-rope
	if ( _paraMode == 2 ) then  
	{
		//make sure all AI cargo has left the chopper - give 4 seconds for last unit to slide down the rope
		waitUntil { sleep 2; ({alive _x and !(_x getVariable ['ACE_isUnconscious', False])} count crew _heli <= _heliCrewCount) || (time > _timeOut);  };		
		uisleep 4;
		
		while {(count (waypoints group driver _heli)) > 0} do
		 {
			deleteWaypoint ((waypoints group driver _heli) select 0);
		 };
		// drop the ropes and delete them
		{
			_attachPoint = _ropes select _forEachIndex;
			_zc = -22;
			while { _zc > -50 } do 
			{
				_x attachTo [_heli, [_attachPoint select 0 , _attachPoint select 1,_zc]];
				_zc = _zc - 5;
				uisleep 0.1;
			};
			deletevehicle _x;
		} foreach _actualRopes;
		
		//wait 3 seconds before flying away
		uisleep 1;
		
		if (!isnil "_hlpr") then {
			deleteVehicle _hlpr;
		};
		//_heli setVariable ["halt_heli", false, false];// heli will stop when script is run
		_heli land "NONE";
	};
	_heli flyInHeight _flyHeight;
	_heliPilot flyInHeight _flyHeight;
	
	//Set waypoint
	_heli doMove _posSpawn;
	_heliPilot doMove _posSpawn;
}
else // Paradrop
{
	_heli flyInHeight _flyHeight;
	_heliPilot flyInHeight _flyHeight;
};


_heliPilot doMove _posSpawn;
_heli setSpeedMode "FULL";
_heli setBehaviour "CARELESS";

_heli setDestination [_posSpawn, "VehiclePlanned", true];


_heli animateDoor ["door_R", 0];
_heli animateDoor ["door_L", 0];
_heli animate ["CargoRamp_Open", 0];

// Allow chopper to leave else AI will board again :-/
sleep 5; 

// activate UPSMON for each paragroup
if (_WP_behavior != "bis" && _WP_behavior != "bisd" && _WP_behavior != "bisp") then 
{
	{
		private ["_paraGroup"];

		_paraGroup = _x;

		if ( _WP_awareness == "Default" ) then // MM most likely forgot to set awareness - paratroopers are not default :-)
		{
			_WP_awareness = "AWARE";
		};

		_theWP = (_paraGroup) addwaypoint [_posWP,200];
		_theWP setWaypointType "MOVE";
		_theWP = (_paraGroup) addwaypoint [_posWP,60];
		_theWP setWaypointType _WP_behavior;
		
		_paraGroup setBehaviour _WP_awareness; 
		_paraGroup allowfleeing 0;
		
		//_null = [leader _paraGroup, _p_mcc_zone_markername,_WP_behavior,_WP_awareness,"SHOWMARKER","spawned" ] spawn mcc_ups;

		//player sideChat format ["UPSMON activated for %1...", _paraGroup];
			
	} foreach _cargoGroups;
};

_timeOut = time + 80; // if chopper is still around after 1.2 minute just delete it
sleep 15; //double make sure all units are out of the chopper
waituntil { sleep 1; ( ((_heli distance _posSpawn) < ((getPosATL _heli select 2) + 350)) || (time > _timeOut) ); };

{deleteVehicle _x} forEach (crew _heli);
deletegroup (group _heli);	//case we want to delete the whole shabang
deletevehicle _heli;