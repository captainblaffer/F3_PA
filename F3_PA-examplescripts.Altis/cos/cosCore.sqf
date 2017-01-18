if (!isServer) exitWith {};
private ["_COSmotPool","_mkrpos","_direction","_rdCount","_tempVeh"];
       

//_COSmotPool =["B_G_Quadbike_01_F","B_G_Van_01_transport_F","B_G_Offroad_01_F","B_G_Offroad_01_F","B_G_Offroad_01_F","O_Truck_02_transport_F","O_Truck_02_covered_F","I_Truck_02_transport_F","I_Truck_02_covered_F"];

_COSmotPool =["B_G_Quadbike_01_F","RHS_Ural_Open_Civ_02","RHS_Civ_Truck_02_transport_F","B_G_Offroad_01_F","B_G_Offroad_01_F","B_G_Offroad_01_F","RHS_Ural_Civ_03","RHS_Ural_Civ_01","LandRover_TK_CIV_EP1","LandRover_TK_CIV_EP1","LandRover_TK_CIV_EP1","RHS_Ural_Open_Civ_03","RHS_Ural_Civ_02"];


_mkr= (_this select 0);
_mkrpos = getpos _mkr;
_radius = _this select 1;
_VehCount = _this select 2;

_roadPosArray= _mkrpos nearRoads _radius;
if (count _roadPosArray < 1) exitWith {};

//debug
debugCOS = false;
_showRoads=false;				
	IF (_showRoads) 
		then {
			{
	_txt=format["roadMkr%1",_x];
	_debugMkr=createMarker [_txt,getpos _x];
	_debugMkr setMarkerShape "ICON";
	_debugMkr setMarkerType "hd_dot";
			}foreach _roadPosArray;
		};
	

_PatrolVehArray=[];
_ParkedArray=[];

_roadPosArray=_roadPosArray call BIS_fnc_arrayShuffle;	
_vehList=_COSmotPool call BIS_fnc_arrayShuffle;
_countVehPool=count _vehList;
_v=0;
_rdCount=0;
_direction= 0;

// SPAWN PARKED VEHICLES
for "_i" from 1 to _VehCount do {

		if (_i >= _countVehPool) 
			then {
				if (_v >= _countVehPool) then {_v=0;};
					_tempVeh=_vehList select _v;
					_v=_v+1;
				};
		if (_i < _countVehPool) 
			then {
			_tempVeh=_vehList select _i;
				};
	
		_tempPos=_roadPosArray select _rdCount;
		_rdCount=_rdCount+1;
		_roadConnectedTo = roadsConnectedTo _tempPos;
		if (count _roadConnectedTo > 0) then {
		_connectedRoad = _roadConnectedTo select 0;
		_direction = [_tempPos, _connectedRoad] call BIS_fnc_DirTo;
		if (random(1)>0.4) then {_direction = _direction + 180};
		} else {
		_direction = 0; };
			
			_veh = createVehicle [_tempVeh, _tempPos, [], 0, "NONE"];
			_veh setdir _direction;
			//_veh setvariable ["cleanthis", false, true];
			_displacement = [3.5,0,0];
			_pytho = sqrt (((_displacement select 0)*(_displacement select 0))+((_displacement select 1)*(_displacement select 1)));
			_Vangle = _direction + ((_displacement select 0) atan2 (_displacement select 1));
			_veh setPosatl ((getpos _veh) vectorAdd [(sin _Vangle) * _pytho,(cos _Vangle) * _pytho,0]);
			
			//_veh setPos [(getPos _veh select 0)-6, getPos _veh select 1, getPos _veh select 2];
								
		_ParkedArray set [count _ParkedArray,_veh];

		
	//null =[_veh] execVM "cos\addScript_Vehicle.sqf";

	IF (debugCOS) then {
		_txt=format["Park%1,mkr%2",_i,_mkr];
		_debugMkr=createMarker [_txt,getpos _veh];
		_debugMkr setMarkerShape "ICON";
		_debugMkr setMarkerType "hd_dot";
		_debugMkr setMarkerText "Park Spawn";
	};
	
};

		
// Check every second until trigger is deactivated
//waituntil {sleep 60; ((getmarkerpos _mkr) select 0) == 0};


//wait until all players moved away
//while {([_mkrpos, 350] call f_fnc_nearPlayer)} do {
//sleep 30; 
//};
/*
// Delete all parked vehicles
 _counter=0;
{
	_counter=_counter+1;
 
  // CHECK VEHICLE IS NOT TAKEN BY PLAYER
	if ({isPlayer _x} count (crew _x) == 0) 
		then {
		_x setvariable ["cleanthis", true, true];
		//deletevehicle _x;
		}; 
		
		
	//todo check if vehicle is too far away, set cleanup variable
}foreach _ParkedArray;*/