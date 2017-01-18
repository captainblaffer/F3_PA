/*
				***		ARMA3Alpha MILITARIZE AREA SCRIPT v2.1 - by SPUn / lostvar	***

			Calling the script:
			
		default: 	nul = [this] execVM "LV\militarize.sqf";
		
		custom:		nul = [target, side, radius, spawn men, spawn vehicles, still, men ratio, vehicle ratio, 
							skills, group, custom init, ID] execVM "LV\militarize.sqf";

		Parameters:
		
	target 		=	center point (name of marker or object or unit which is the center point of militarized area,
									or position array)
	side 		=	(0 = civilian, 1 = blue, 2 = red, 3 = green) 													DEFAULT: 2
	radius 		=	(from center position) 																			DEFAULT: 150
	spawn men 	= 	[spawn land units, spawn water units]															DEFAULT: [true,false]
					(both values are true or false)
	spawn vehicles =[spawn land vehicles, spawn water vehicles, spawn air vehicles] 								DEFAULT: [true,false,false]
					(all values are true or false)	
	still 		= 	true or false 	(if false, then units will patrol in radius, checkin also buildings) 			DEFAULT: false
	men ratio 	=	(amount of spawning men is radius * men ratio, ie: 250 * 0.2 = 50 units) 						DEFAULT: 0.3
					NOTE: Array - you can also use following syntax: [amount,random amount] for example:
					[10,5] will spawn at least 10 units + random 1-5 units 
	vehicle ratio= 	(amount of spawning vehicles is radius * vehicle ratio, ie: 250 * 0.1 = 25 vehicles) 			DEFAULT: 0.1
					NOTE: Same array syntax as in "men ratio" works here too!
	skills 		= 	"default" 	(default AI skills) 																DEFAULT: "default"
				or	number	=	0-1.0 = this value will be set to all AI skills, ex: 0.8
				or	array	=	all AI skills invidiually in array, values 0-1.0, order:
		[aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general, endurance, reloadSpeed] 
		ex: 	[0.75,0.5,0.6,0.85,0.9,1,1,0.75,1,1] 
	group 		= 	group name or nil (if you want units in existing group, set it here. if nil, new group is made) DEFAULT: nil
					EXAMPLE: (group player)
	custom init = 	"init commands" (if you want something in init field of units, put it here) 					DEFAULT: nil
				NOTE: Keep it inside quotes, and if you need quotes in init commands, you MUST use ' or "" instead of ".
				EXAMPLE: "hint 'this is hint';"
	ID 			= 	number (if you want to delete units this script creates, you'll need ID number for them) 		DEFAULT: nil

EXAMPLE: nul = [this,2,50,[true,true],[true,false,true],false,[10,0],0.1,[0.2,0.2,0.2,0.85,0.9,0.75,0.1,0.6,1,1],nil,nil,13] execVM "LV\militarize.sqf";


Customized: CBA_fnc_taskDefend
don't spawn vehicles
EXAMPLE: nul = [this,50,[true,false],[10,0],[0.2,0.2,0.2,0.85,0.9,0.75,0.1,0.6,1,1],nil,nil,13] execVM "LV\militarize.sqf";
*/
//if (!isServer)exitWith{};
private ["_formation","_geararray","_grpId","_customInit","_cPos","_skls","_skills","_dir","_range","_unitType","_unit","_radius","_still","_centerPos","_menAmount","_milGroup","_menArray","_redMenArray","_pos","_allUnitsArray","_menRatio","_validPos","_whichOne","_thisArray","_smokesAndChems"];

//Extra options:
_smokesAndChems = false;
//

_cPos = if(count _this > 0)then{_this select 0;};
//_side = if (count _this > 1) then { _this select 1; }else{2;};
_radius = if (count _this > 1) then { _this select 1; }else{150;};
//_men = if (count _this > 2) then { _this select 2; }else{[true,false];};
//_vehicles = if (count _this > 4) then { _this select 4; }else{[true,false,false];};
//_still = if (count _this > 5) then { _this select 5; }else{false;};
_menRatio = if (count _this > 2) then { _this select 2; }else{0.3;};
//_vehRatio = if (count _this > 7) then { _this select 7; }else{0.02;};
_skills = if (count _this > 3) then { _this select 3; }else{"default";};
_milGroup = if (count _this > 4) then { _this select 4; }else{nil;}; if(!isNil("_milGroup"))then{if(_milGroup == "nil0")then{_milGroup = nil;};};
_customInit = if (count _this > 5) then { _this select 5; }else{nil;}; if(!isNil("_customInit"))then{if(_customInit == "nil0")then{_customInit = nil;};};
_grpId = if (count _this > 6) then { _this select 6; }else{nil;}; 
_geararray = ["ftl","r","rat","ar","gren","aar","matg","mmgg","sn","r","m"];
_formation = "STAG COLUMN"; if (random(1)>0.4) then {_formation = "WEDGE";};
if(_cPos in allMapMarkers)then{
	_centerPos = getMarkerPos _cPos;
}else{
	if (typeName _cPos == "ARRAY") then{
		_centerPos = _cPos;
	}else{
		_centerPos = getPos _cPos;
	};
};

if(isNil("LV_ACskills"))then{LV_ACskills = compile preprocessFile "LV\LV_functions\LV_fnc_ACskills.sqf";};
if(isNil("LV_vehicleInit"))then{LV_vehicleInit = compile preprocessFile "LV\LV_functions\LV_fnc_vehicleInit.sqf";};

if(typeName _menRatio == "ARRAY")then{	
	_menAmount = (_menRatio select 0) + (random (_menRatio select 1));
}else{
	_menAmount = round (_radius * _menRatio);
};
_allUnitsArray = [];

_MenArray = ["O_G_Soldier_A_F","O_G_soldier_AR_F","O_G_medic_F","O_G_Soldier_GL_F","O_G_soldier_M_F","O_G_soldier_LAT_F","O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_lite_F","O_G_Soldier_TL_F","O_G_Soldier_TL_F","O_G_soldier_LAT_F"];


if(isNil("_milGroup"))then{_milGroup = createGroup east;}else{_milGroup = _milGroup;};
/*
_validPos = false;
while {!_validPos} do {
	_dir = random 360;
	_range = _radius;
	if (_range > 400) then {_range = 400};
	_pos = [(_centerPos select 0) + (sin _dir) * _range, (_centerPos select 1) + (cos _dir) * _range, 0];
	_validPos = true;
	if(surfaceIsWater _pos)then{_validPos = false;};
};*/
//find buildingpos
_range = _radius; 
_height = [.3,1];
_bpos = [];
{
  _bposwip = [];
  for [{_i = 0;_p = _x buildingpos _i},{str _p != "[0,0,0]"},{_i = _i + 1;_p = _x buildingpos _i}] do {
    _bposwip set [count _bposwip,_p];
  };
  _bpos pushBack _bposwip;
} foreach (nearestObjects [_cPos, ["Building"], _range]);

_tmp = [];
_min = _height select 0;
_max = _height select 1;
{
_tmpwip = [];
{
  _h = _x select 2;
  if (_h >= _min && _h <= _max) then { _tmpwip set [count _tmpwip,_x] };
} foreach _x;
if (count _tmpwip > 0) then {
_tmp pushBack _tmpwip;
};
} foreach _bpos;
_bpos = _tmp call BIS_fnc_selectRandom;
	
for "_i" from 1 to _menAmount do{
	_validPos = false;
	while{!_validPos}do{
		_unitType = _menArray select (floor(random(count _menArray)));
		_validPos = true;
	};
	_pos = _bpos select(floor (random (count _bpos)));
	_unit = _milGroup createUnit [_unitType, _pos, [], 0, "NONE"];
	_unit setPos _pos;

	//if(!_still)then{
	//	if(_unitType in _menArray)then{
	//		nul = [_unit,_cPos,_radius,_doorHandling] execVM "LV\patrol-vD.sqf";
	//	}else{
	//		nul = [_unit,_pos] execVM 'LV\patrol-vH.sqf';
	//	};
	//};
	//_unit allowDamage false;
	_allUnitsArray set [(count _allUnitsArray), _unit];
	
	//_gear = _geararray call BIS_fnc_selectRandom; 
	//[_gear,_unit] call f_fnc_assignGear;
	_unit execVM "f\assignGear\f_assignGear_AI.sqf";
	
	//_unit addMagazine "SmokeShell";
	//_unit addMagazine ["Chemlight_green","Chemlight_red","Chemlight_yellow","Chemlight_blue"] call BIS_fnc_selectRandom;
};

_milGroup setVariable ["f_cacheExcl", true];
[_milGroup]spawn { 
	sleep 30; 
	_this select 0 setVariable ["f_cacheExcl", false];
};
_milGroup setBehaviour "SAFE";

	{
		if((typeName _skills != "STRING")&&((side _x) != civilian))then{ _skls = [_x,_skills] call LV_ACskills; }; 
		if(!isNil("_customInit"))then{ 
			[_x,_customInit] spawn LV_vehicleInit;
		};
		
	_x addEventHandler ["killed", {_this select 0 execVM "c\intelSpawn.sqf";}];
	
	} forEach units _milGroup;

sleep 3;
//{
//   _x allowDamage true;
//}forEach _allUnitsArray;

{
	if (_x == leader (group _x)) then{
		//if (isNil "c_var_addons" || {c_var_addons == 0}) then {
		//[group _x, getPos _x, _radius] call bis_fnc_taskPatrol;
		//} else {
		[_x, _x, _radius, 7, "MOVE", "SAFE", "WHITE", "NORMAL", _formation, nil, [3,6,9]] call CBA_fnc_taskPatrol;
		//};
		group _x allowfleeing 0;
	};
	//debug
	//_x execVM "c\posMark.sqf"; 
	//hint format ["_x %1",_x ];
}forEach units _milGroup;

if(!isNil("_grpId"))then{
	call compile format ["LVgroup%1 = _milGroup",_grpId];
	call compile format["LVgroup%1spawned = true;", _grpId];
	_thisArray = [];
	{ 
		if(isNil("_x"))then{
			_thisArray set[(count _thisArray),"nil0"];
		}else{
			_thisArray set[(count _thisArray),_x];
		};
	}forEach _this;
	call compile format["LVgroup%1CI = ['taskPatrol',%2]",_grpId,_thisArray];
};

[_milGroup] spawn {
	private ["_grp","_poslist","_i","_pos","_dist"];
	_grp = _this select 0;
	_poslist = [];
	_i = 0;
	_dist = 25;
	sleep 3;
	{
	_poslist pushback (getpos _x);
	}forEach units _grp;
	
	sleep 12;
	//secure leader
	if ((leader _grp) distance (_poslist select _i) < 4) then {
		_notsafe = true;
		while {_notsafe} do {
			_notsafe = false;
			_pos = [getpos (leader _grp),5,_dist,0.4,0,4,0] call BIS_fnc_findSafePos;
			if ((getpos (leader _grp)) distance _pos > 300) then {
			_notsafe = true;
			_dist = _dist + 10;
			};
		};
		(leader _grp) setpos _pos;
	};
	sleep 20;
	//secure squadmembers
	{
		if (_X distance (_poslist select _i) < 4) then {
			_x setpos (getpos (leader _x));
		};
		_i = _i + 1;
		sleep 3;
	}forEach units _grp;
};

if(_smokesAndChems)then{
[_milGroup] spawn {
	private ["_grp","_chance"];
	_grp = _this select 0;
	while{(count units _grp) > 0}do{
			{
				if((behaviour _x) == "COMBAT")then{
					if(daytime > 23 || daytime < 5)then{
						_chance = floor(random 100);
						if(_chance < 3)exitWith{
							if("Chemlight_green" in (magazines _x))exitWith{
								_x fire ["ChemlightGreenMuzzle","ChemlightGreenMuzzle","Chemlight_green"];
							};
							if("Chemlight_red" in (magazines _x))exitWith{
								_x fire ["ChemlightRedMuzzle","ChemlightRedMuzzle","Chemlight_red"];
							};
							if("Chemlight_yellow" in (magazines _x))exitWith{
								_x fire ["ChemlightYellowMuzzle","ChemlightYellowMuzzle","Chemlight_yellow"];
							};
							if("Chemlight_blue" in (magazines _x))exitWith{
								_x fire ["ChemlightBlueMuzzle","ChemlightBlueMuzzle","Chemlight_blue"];
							};
						};
					};
					if("SmokeShell" in (magazines _x))exitWith{ 
						_chance = floor(random 100);
						if(_chance < 3)exitWith{
							_x fire ["SmokeShellMuzzle","SmokeShellMuzzle","SmokeShell"];
						};
					};
				};
			}forEach units _grp;
		sleep 10;
	};
};
};
_milGroup