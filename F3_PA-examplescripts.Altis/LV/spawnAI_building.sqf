// _pos is where ai are spawned, _area is where ai are headed _num1 is min num and _num2 is max num
// call with nul = [this, "aia_", 30, 2, 0.3, 500] execVM "LV\spawnAI_building.sqf";
//if (!isserver) exitwith {};
//if ((str player) != "headless") exitwith {};

private ["_cPos","_pos","_unitname","_num1","_num2","_skill","_unitlist","_geararray","_tooclose"];

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

/*{
   if 
   ((_x distance _pos < 225)&&
   (alive _x)&&
   (isplayer _x)
   ) exitwith
   {
// too many players nearby
   };
} forEach playableunits; 
*/
_unitname = (_this select 1);
_num1 = (_this select 2);
_num2 = (_this select 3);
_skill = (_this select 4);
_unitlist = []; //list of units created
_geararray = ["gren","r","rat","ar","gren","r","rat","ar","sn","mmgg"];
_tooclose = false;
/*{
	if ((_x distance _pos < 300)&&(alive _x)&&(isplayer _x)) Exitwith {
	_tooclose = true;
	};
	sleep .1;
} forEach playableunits;
if (_tooclose) exitwith {};*/

_grp=creategroup east;
//"TK_INS_Soldier_TL_EP1" CreateUnit [ _pos ,_grp,"slldier1 = this",.7,"sergeant"];

//sleep .5;
_thenum = (_num1) + (ceil random (_num2));
_x = 0 ; for "_x" from 1 to (_thenum) do {
	//_grp=creategroup east;
	_soldiername = format ["%1%2", _unitname, _x];
	"O_G_Soldier_F" CreateUnit [_pos,_grp,"_soldiername = this",_skill,"private"]; 
	_unitlist = _unitlist + [_soldiername];
	//sleep .2; 
	//ygrp = _grp;
	//publicvariable "ygrp";
};

_grp setVariable ["f_cacheExcl", true];
[_grp]spawn { 
	sleep 120; 
	_this select 0 setVariable ["f_cacheExcl", false];
};

{	//_x addEventHandler ["killed", {_this select 0 execVM "customization\eventhandlers\deletebodyIntelB.sqf";}];
	//removeallitems _x;
	//_null = [_x, "RAN"] execVM "scripts\gearAI_taki.sqf";
	_gear = _geararray call BIS_fnc_selectRandom; 
	[_gear,_x] call f_fnc_assignGear;
	//sleep .2;
} foreach units _grp;

//put guys in buildings randomly
_range = (_this select 5); 
_height = [.3,33];
_bpos = [];
{
  for [{_i = 0;_p = _x buildingpos _i},{str _p != "[0,0,0]"},{_i = _i + 1;_p = _x buildingpos _i}] do {
    _bpos set [count _bpos,_p];
  };
} foreach (nearestObjects [_pos, ["Building"], _range]);

private ["_tmp","_min","_max","_h"];
_tmp = [];
_min = _height select 0;
_max = _height select 1;
{
  _h = _x select 2;
  if (_h >= _min && _h <= _max) then { _tmp set [count _tmp,_x] };
} foreach _bpos;

if (count _tmp > 0) then {
{_x setpos (_tmp select (floor (random (count _tmp))));
_x allowfleeing 0;
_x setUnitPos "UP";
//_x forceSpeed 0;
commandstop _x;
_x setformdir random (360);
//debugmarkers
/*_mname = format ["btestmrk_%1",_x];
createMarker [_mname,(position _x)];
_mname setMarkerShape "ICON";
_mname setMarkerType "Dot";*/
} foreach _unitlist;
};
//{
//_x allowdamage false;
//} foreach _unitlist;
sleep 3;
{
_x allowdamage true;
} foreach _unitlist;