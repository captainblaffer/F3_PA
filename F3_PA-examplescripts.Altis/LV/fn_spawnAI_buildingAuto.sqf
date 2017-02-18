// _cPos is where ai are spawned, pos or marker
// _num1 = percentage of building spots filled. E.g. 0.5 is half filled.
// _num2 = max AI to spawn, e.g. 30
// _skill is AI skill, e.g. 0.3
// _side , e.g. "WEST" "EAST" "GUE"
// _radius is radius around  _cPos AI will spawn
// call with nul = [_cPos, _num1, _num2, _skill, _radius] execVM "LV\spawnAI_buildingAuto.sqf";

//if (!isserver) exitwith {};

private ["_maxdudes","_bglass","_thenumwip","_thenum","_bcurtemp","_bcur","_tmpwip","_cPos","_pos","_num1","_num2","_skill","_unitlist","_tmp","_min","_max","_h","_grp","_ranDir","_xPos","_MenArray"];

_cPos = (_this select 0);
if(_cPos in allMapMarkers)then{
	_pos = getMarkerPos _cPos;
}else{
	if (typeName _cPos == "ARRAY") then{
		_pos = _cPos;
	}else{
		_pos = getPos _cPos;
	};
};

_num1 = (_this select 1);
_num2 = (_this select 2);
_skill = (_this select 3);
_side = (_this select 4);
_unitlist = []; //list of units created
switch (_side) do {
	case "WEST":	{
		_side = west;
		_MenArray = ["B_Soldier_A_F","B_soldier_AR_F","B_medic_F","B_Soldier_GL_F","B_Soldier_M_F","B_soldier_LAT_F","B_Soldier_F","B_Soldier_SL_F","B_Soldier_lite_F","B_Soldier_TL_F","B_Soldier_TL_F","B_soldier_LAT_F"]; //NATO 
	};
	case "EAST": {
		_side = east;
		_MenArray = ["O_Soldier_A_F","O_soldier_AR_F","O_medic_F","O_Soldier_GL_F","O_Soldier_M_F","O_soldier_LAT_F","O_Soldier_F","O_Soldier_SL_F","O_Soldier_lite_F","O_Soldier_TL_F","O_Soldier_TL_F","O_soldier_LAT_F"]; //CSAT 
		//_MenArray = ["O_G_Soldier_A_F","O_G_soldier_AR_F","O_G_medic_F","O_G_Soldier_GL_F","O_G_soldier_M_F","O_G_soldier_LAT_F","O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_lite_F","O_G_Soldier_TL_F","O_G_Soldier_TL_F","O_G_soldier_LAT_F"]; //EAST FIA
	};
	case "GUE": {
		_side = resistance;
		_MenArray = ["I_Soldier_A_F","I_soldier_AR_F","I_medic_F","I_Soldier_GL_F","I_Soldier_M_F","I_soldier_LAT_F","I_Soldier_F","I_Soldier_SL_F","I_Soldier_lite_F","I_Soldier_TL_F","I_Soldier_TL_F","I_soldier_LAT_F"]; //AAF 
	};
	default {
		_side = east;
		_MenArray = ["O_Soldier_A_F","O_soldier_AR_F","O_medic_F","O_Soldier_GL_F","O_Soldier_M_F","O_soldier_LAT_F","O_Soldier_F","O_Soldier_SL_F","O_Soldier_lite_F","O_Soldier_TL_F","O_Soldier_TL_F","O_soldier_LAT_F"]; //CSAT 
	};
};

//find building positions
_range = (_this select 5); 
_height = [.3,28];
_bpos = [];
{
	if (!(isObjectHidden _x)) then {
  /*_bposwip = [];
  for [{_i = 0;_p = _x buildingpos _i},{str _p != "[0,0,0]"},{_i = _i + 1;_p = _x buildingpos _i}] do {
    _bposwip set [count _bposwip,_p];
  };
  _bpos pushBack _bposwip;*/
  if ([_x] call BIS_fnc_isBuildingEnterable) then {
	_bpos pushback ([_x] call BIS_fnc_buildingPositions);
  };
  };
} foreach (nearestObjects [_pos, ["Building"], _range]);

_grp = grpNull;
_tmp = []; //array of array of b positions
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

//spawn dudes
if (count _tmp > 0) then {
_grp=creategroup _side;

_thenumwip = 0;
{
_thenumwip = _thenumwip + (count _x);
}foreach _tmp;

_thenum = ceil(_thenumwip*_num1*(random(0.2)+ 1));
//num1 * tan(atan(sqrt(60 - a1^2) / a1) + pi / 4) + 10 * tan(atan(sqrt(60 - a1^2) / a1) + pi / 4) - 10;
if (_thenum < 6) then {_thenum = 6};
if (_thenum > _thenumwip) then {_thenum = _thenumwip};
if (_thenum > _num2) then {_thenum = _num2;};


_x = 0 ; for "_x" from 1 to (_thenum) do {
	_unitType = _menArray select (floor(random(count _menArray)));
	_unitType CreateUnit [getmarkerpos "nogo1",_grp,"commandstop this",_skill,"private"]; //_pos
};

_grp setVariable ["f_cacheExcl", true];
[_grp]spawn { 
	sleep 30; 
	_this select 0 setVariable ["f_cacheExcl", false];
};


//put dudes in buildings
_bcur = _tmp call BIS_fnc_selectRandom; 
_bdudes = 0;
_bcurtemp = _bcur;

//_thenumwip = totalnr of spots in buildings
//_thenum = dudes amount created
_maxdudes = round (count _bcur * (_thenum / _thenumwip + random(0.1)+ 0.15)); //max dudes in this building ,remind fallu, was 0.12 before 
if (_maxdudes > count _bcur) then {_maxdudes = count _bcur;};
if (_maxdudes > 8) then {_maxdudes = 8;}; //max 9 dudes per building
if (_maxdudes < 2) then {_maxdudes = 2;}; //min 2 dudes per building, remind fallu
{
while {_maxdudes <= _bdudes} do {
	if (count _tmp > 1) then {
		_tmp set [_tmp find _bcur,-1];
		_tmp = _tmp - [-1];
		_bcur = _tmp call BIS_fnc_selectRandom;
		_maxdudes = round(count _bcur * (_thenum / _thenumwip + random(0.1)+ 0.12));
		if (_maxdudes > count _bcur) then {_maxdudes = count _bcur;};
		if (_maxdudes > 8) then {_maxdudes = 8;}; //max 9 dudes per building
		if (_maxdudes < 2) then {_maxdudes = 2;}; //min 2 dudes per building, remind fallu
		if (count _bcur > 0) then {
			_bglass = nearestObject [(_bcur select 0), "Building"]; 
			[[[_bglass],"LV\buildingGlass.sqf"],"BIS_fnc_execVM",true] call BIS_fnc_MP;
		};
	} else { 
		_bcur = [_pos];
		_maxdudes = 9999;
	};
	_bdudes = 0;
	_bcurtemp = _bcur;
};
_bdudes = _bdudes + 1;
_ranDir =  random (360);
_x setformdir _ranDir;
_x setdir _ranDir;
_xPos = _bcurtemp select(floor (random (count _bcurtemp)));

if (isnil "_xPos") then {
	if (_x == leader group _x) then {
		_xPos = _pos;
	} else {
		_xPos = getpos (leader _x);
	};
} else {
if (_bcur find _pos<0) then {
	_bcurtemp set [_bcurtemp find _xPos,-2];
	_bcurtemp = _bcurtemp - [-2];
};
};

_x setpos _xPos;
_x allowfleeing 0;
_x forceSpeed 0;
dostop _x;
_x disableAI "TARGET";
commandstop _x;

//debugmarkers
//_mname = format ["btestmrk_%1",_x];
//createMarker [_mname,(position _x)];
//_mname setMarkerShape "ICON";
//_mname setMarkerType "mil_dot";

/*
_gearOpt = round random 4;
switch (_gearOpt) do {
	case 0:	{
		[_x] execVM "loadouts\mg.sqf";
	};
	case 1: {
		[_x] execVM "loadouts\ak1.sqf";
	};
	case 2: {
		[_x] execVM "loadouts\ak2.sqf";
	};
	case 3: {
		[_x] execVM "loadouts\gl.sqf";
	};
	case 4: {
		[_x] execVM "loadouts\rpg.sqf";
	};
	default {
		[_x] execVM "loadouts\ak1.sqf";
	};
};*/


} foreach units _grp;

(units _grp) execVM "f\assignGear\f_assignGear_AI.sqf";
[units _grp]spawn{
	sleep 10;
	{
	_x setUnitPos "UP";
	}foreach (_this select 0);
};
};
_grp
