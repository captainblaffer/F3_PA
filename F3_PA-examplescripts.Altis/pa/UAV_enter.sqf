/*
to use:
1. create a uav object (with AI in it)
2. give uav a name (e.g. UAV1)
3. create player
4. in player init add: this setvariable ["UAV",UAV1]; this addaction ["Enter UAV", "pa\UAV_enter.sqf"];
*/


_UAV = player getvariable "UAV";
if (isnil "_UAV") exitWith {hint "UAV_enter.sqf error: UAV guy undefined";};

if ((alive driver _UAV) || (alive gunner _UAV)) then {(_this select 0) removeaction (_this select 2);
} else {hint "UAV crew was killed!"};

if (!isplayer driver _UAV) then {
if (alive driver _UAV) then {
// add driver action
UAVdriveraction = (_this select 1) addaction  ["Enter UAV Driver", "pa\UAV_driver.sqf"];
};
};

if (!(isplayer (gunner _UAV))) then {
if (alive gunner _UAV) then {
// add gunner action;
UAVgunneraction = (_this select 1) addaction  ["Enter UAV Gunner", "pa\UAV_gunner.sqf"];
};
};