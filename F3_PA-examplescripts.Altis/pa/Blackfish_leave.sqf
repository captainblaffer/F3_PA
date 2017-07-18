selectplayer origplayer;
//[[origplayer],{(_this select 0) switchmove "";}] remoteExec ["bis_fnc_call", 0]; 
	origplayer allowdamage true;

private ["_UAVguy"];

_UAV = origplayer getvariable "UAV";

_UAVname = "BLACKFISH";
{
	if (_x iskindof "RHS_C130J") then{
		_UAVname = "AC-130";
	};
} forEach attachedObjects _UAV;  

if (count _this == 0) then {
_UAVguy = (crew _UAV) select 1;
} else {
_UAVguy = (_this select 0);
};

{
	if (_x iskindof "RHS_C130J") then{
	_x setobjecttexture [0,"rhsusf\addons\rhsusf_a2port_air\c130j\data\c130j_body_co.paa"];
	_x setobjecttexture [1,"rhsusf\addons\rhsusf_a2port_air\c130j\data\c130j_wings_co.paa"];
	};
} forEach attachedObjects _UAV;  

_UAVguy removeeventhandler ["killed", UAVkilledEH];
origplayer removeeventhandler ["killed", OPERATORkilledEH];
origplayer removeeventhandler ["hitpart", OPERATORhitEH];

//["ace_unconscious", UncEH] call CBA_fnc_removeEventHandler;

if (alive _UAVguy && alive origplayer) then{
	waituntil{player == origplayer}; 
	_gunningstr = format ["%1 - GUNNING" ,_UAVname];
	player addaction  [_gunningstr, "pa\Blackfish_enter.sqf"];

_UAVguy removeaction LeaveUAVAction;


_UAVguy disableAI "TARGET";
_UAVguy disableAI "AUTOTARGET";
_UAVguy disableAI "AUTOCOMBAT";

} else {
if (alive origplayer) then {
	_waitloop = true;
	_curtime = time;
	while{_waitloop} do {
	if (side player == sideLOGIC) exitWith {
		_waitloop =false; [] call F_fnc_ForceExit; 
		 _unit = player; 
		selectPlayer origplayer; 
		waituntil{player == origplayer}; 
		origplayer allowdamage true;
		deleteVehicle _unit;
		_gunningstr = format ["%1 - GUNNING" ,_UAVname];
		player addaction  [_gunningstr, "pa\Blackfish_enter.sqf"];
		};
	if (_curtime + 15 < time) exitWith {_waitloop =false};
	};
	 

} else {
sleep 5;
	[player,origplayer,true,true,true] call f_fnc_CamInit;
};

if (!alive _UAVguy) then {
	while {!alive _UAVguy} do {
	_UAVguy = (crew _UAV) select 1;
	sleep 1;
	};
	deletevehicle _UAVguy;
};

};