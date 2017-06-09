selectplayer origplayer;

_UAVguy = (_this select 0);

if (alive _UAVguy) then{
	waituntil{player == origplayer}; 
	player addaction  ["Enter UAV", "pa\UAV_enter.sqf"];

_UAVguy removeaction (_this select 2);
if (_UAVguy == driver (vehicle _UAVguy)) then {
	while {(count (waypoints group _UAVguy)) > 0} do { deleteWaypoint ((waypoints group _UAVguy) select 0); };
	_height =  getposasl (vehicle _UAVguy) select 2;
	_theWP = (group _UAVguy) addwaypoint [(getpos _UAVguy),0];
	_theWP setWaypointType "HOLD";
	(vehicle _UAVguy) flyInHeightASL [_height,_height,_height];
};

_UAVguy removeeventhandler ["killed", UAVkilledEH];

} else {
	_waitloop = true;
	_curtime = time;
	while{_waitloop} do {
	if (side player == sideLOGIC) exitWith {
		_waitloop =false; [] call F_fnc_ForceExit; 
		 _unit = player; 
		selectPlayer origplayer; 
		waituntil{player == origplayer}; 
		deleteVehicle _unit;
		player addaction  ["Enter UAV", "pa\UAV_enter.sqf"];
		};
	if (_curtime + 15 < time) exitWith {_waitloop =false};
	};
	 


if (!alive origplayer) then {
	player setdamage 1;
};
};