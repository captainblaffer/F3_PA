origplayer = player; 
_UAV = player getvariable "UAV";
if (isnil "_UAV") then {hint "UAV_enter.sqf error: UAV guy undefined";};

_UAVplayer = driver _UAV;

if ((!(isplayer _UAVplayer))&&(alive _UAVplayer)) then {
	selectplayer _UAVplayer;
	_UAVplayer addaction  ["Leave UAV", "pa\UAV_leave.sqf"];
} else {
	hint "action canceled, target was a player or killed!";
	origplayer addaction  ["Enter UAV", "pa\UAV_enter.sqf"];
};

UAVkilledEH = _UAVplayer addEventHandler ["killed", {_this execVM "pa\UAV_leave.sqf"}];

(_this select 0) removeaction UAVdriveraction;
(_this select 0) removeaction UAVgunneraction;