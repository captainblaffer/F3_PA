params ["_position","_tanktype",
["_dugin",true,[true]]];
private ["_tank","_dir","_spawnpos","_bag1","_bag2","_bag3","_bag4","_bag5","_bag6"];

_spawnpos = getMarkerPos _position;

if(_position in allMapMarkers)then{
	_spawnpos = getMarkerPos _position;
	_dir = markerDir _position;
}else{
	if (typeName _position == "ARRAY") then{
		_spawnpos = _position;
		_dir = 0;
	}else{
		_spawnpos = getPos _position;
		_dir = getdir _position;
	};
};


_tank = createVehicle  [_tanktype, _spawnpos, [], 15, "NONE"];

_tank setDir _dir;
_tank setFuel 0;
_tank lock 3;
clearWeaponCargoGlobal _tank;
clearMagazineCargoGlobal _tank;
clearItemCargoGlobal _tank;
clearBackpackCargoGlobal _tank;

if (_dugin) then {
_bag1 = createVehicle ["Land_BagFence_Long_F", _spawnpos, [], 15, "NONE"];
_bag1 attachTo [_tank, [2,-1.5,-1.5]];
_bag1 setDir 90;

_bag2 = createVehicle ["Land_BagFence_Long_F", _spawnpos, [], 15, "NONE"];
_bag2 attachTo [_tank, [2,1.5,-1.5]];
_bag2 setDir 90;

_bag3 = createVehicle ["Land_BagFence_Long_F", _spawnpos, [], 15, "NONE"];
_bag3 attachTo [_tank, [-1,3.5,-1.5]];

_bag4 = createVehicle ["Land_BagFence_Long_F", _spawnpos, [], 15, "NONE"];
_bag4 attachTo [_tank, [1,3.5,-1.5]];

_bag5 = createVehicle ["Land_BagFence_Long_F", _spawnpos, [], 15, "NONE"];
_bag5 attachTo [_tank, [-2,-1.5,-1.5]];
_bag5 setDir 90;

_bag6 = createVehicle ["Land_BagFence_Long_F", _spawnpos, [], 15, "NONE"];
_bag6 attachTo [_tank, [-2,1.5,-1.5]];
_bag6 setDir 90;
};

_tank
