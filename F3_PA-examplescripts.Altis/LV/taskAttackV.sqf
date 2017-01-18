/*
				***		ARMA3Alpha MILITARIZE AREA SCRIPT v2.1 - by SPUn / lostvar	***

			Calling the script:
			
		default: 	nul = [this] execVM "LV\militarize.sqf";
		
		custom:		nul = [target, radius, vehicle ratio, types, skills, group, custom init, ID] execVM "LV\militarize.sqf";

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
EXAMPLE: nul = [this,50,[1,0],[0.2,0.2,0.2,0.85,0.9,0.75,0.1,0.6,1,1],nil,nil,nil] execVM "LV\militarize.sqf";
*/
//if (!isServer)exitWith{};
private ["_types","_grpId","_customInit","_cPos","_skls","_skills","_dir","_range","_radius","_still","_centerPos","_menAmount","_vehAmount","_milHQ","_milGroup","_redMenArray","_pos","_allUnitsArray","_vehRatio","_validPos","_driver","_whichOne","_vehicle","_crew","_thisArray"];

_cPos = if(count _this > 0)then{_this select 0;};
//_side = if (count _this > 1) then { _this select 1; }else{2;};
_radius = if (count _this > 1) then { _this select 1; }else{150;};
_waypoints = if (count _this > 2) then { _this select 2; }else{[_cPos,_cPos];};
//_men = if (count _this > 3) then { _this select 3; }else{[true,false];};
//_vehicles = if (count _this > 2) then { _this select 2; }else{[true,false,false];};
//_still = if (count _this > 5) then { _this select 5; }else{false;};
//_menRatio = if (count _this > 6) then { _this select 6; }else{0.3;};
//_vehRatio = if (count _this > 2) then { _this select 2; }else{0.02;};
_types = if (count _this > 3) then { _this select 3; }else{0;};
_skills = if (count _this > 4) then { _this select 4; }else{"default";};
_milGroup = if (count _this > 5) then { _this select 5; }else{nil;}; if(!isNil("_milGroup"))then{if(_milGroup == "nil0")then{_milGroup = nil;};};
_customInit = if (count _this > 6) then { _this select 6; }else{nil;}; if(!isNil("_customInit"))then{if(_customInit == "nil0")then{_customInit = nil;};};
_grpId = if (count _this > 7) then { _this select 7; }else{nil;}; 

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

if(isNil("LV_fullLandVehicle"))then{LV_fullLandVehicle = compile preprocessFile "LV\LV_functions\LV_fnc_fullLandVehicle.sqf";};

/*if(typeName _vehRatio == "ARRAY")then{	
	_vehAmount = (_vehRatio select 0) + (random (_vehRatio select 1));
}else{
	_vehAmount = round (_radius * _vehRatio);
};*/
_allUnitsArray = [];
   

//for "_i" from 1 to _vehAmount do{
    
	_validPos = false;
	while{!_validPos}do{
		
		_dir = random 360;
		_range = random _radius;
		_pos = [(_centerPos select 0) + (sin _dir) * _range, (_centerPos select 1) + (cos _dir) * _range, 0];
		_validPos = true;
		if(surfaceIsWater _pos)then{_validPos = false};
	};	
		_driver = [_pos, 1, _types] call LV_fullLandVehicle;
		//if(!_still)then{nul = [vehicle _driver,_pos] execVM 'LV\patrol-vE.sqf';};
		
	
	
	waituntil {!isnull _driver};
	_vehicle = vehicle _driver;
    //_vehicle allowDamage false;
      
    _allUnitsArray set [(count _allUnitsArray), _vehicle];
	if(isNil("_milGroup"))then{_milGroup = createGroup east;}else{_milGroup = _milGroup;};
	(units(group _driver)) joinSilent _milGroup; 
//};
//[_milGroup]spawn { 
//	sleep 120; 
//	_this select 0 setVariable ["f_cacheExcl", false];
//};
{ 
	if(typeName _skills != "STRING")then{ _skls = [_x,_skills] call LV_ACskills; }; 
	if(!isNil("_customInit"))then{ 
		[_x,_customInit] spawn LV_vehicleInit;
	};
	_x addEventHandler ["killed", {_this select 0 execVM "c\intelSpawn.sqf";}];
} forEach units _milGroup;


sleep 3;
{
    _x allowDamage true;
}forEach _allUnitsArray;

{
	if (_x == leader (group _x)) then{
		_theWP = (group _x) addwaypoint [(_waypoints select 0),0];
		_theWP setWaypointType "UNLOAD";
		_theWP setWaypointTimeout [10, 12, 14];
		
		_theWP = (group _x) addwaypoint [(_waypoints select 1),60];
		_theWP setWaypointType "GUARD";
		//group _x) setCurrentWaypoint [(group _x),1];
		
		//[_x, _x, _radius, 7, "MOVE", "AWARE", "WHITE", "LIMITED", "STAG COLUMN", nil, [3,6,9]] call CBA_fnc_taskPatrol;
		group _x allowfleeing 0;
		//group _x setSpeedMode "LIMITED";
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