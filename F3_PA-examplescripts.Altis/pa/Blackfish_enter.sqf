/*
to use:
see blackfish_selectwp.sqf
*/



_UAV = player getvariable "UAV";
_UAVname = "BLACKFISH";
{
	if (_x iskindof "RHS_C130J") then{
		_UAVname = "AC-130";
	};
} forEach attachedObjects _UAV;  

if (isnil "_UAV") exitWith {hint "Blackfish_enter.sqf error: UAV undefined";};
if (!alive _UAV) exitWith {hint format ["%1 has been destroyed!" ,_UAVname];};

if ((count (crew _UAV)) > 1) then { 


if (!alive ((crew _UAV) select 0) || !alive ((crew _UAV) select 1)) exitWith {
	hint "UAV crew was killed!";
};

(_this select 0) removeaction (_this select 2);


_UAVplayer = crew _UAV select 1;
	
if (!(isplayer _UAVplayer)) then {
if (alive _UAVplayer) then {
origplayer = player; 

if ((!(isplayer _UAVplayer))&&(alive _UAVplayer)) then {
	selectplayer _UAVplayer;
	_exitstr = format ["%1 - EXIT" ,_UAVname];
	LeaveUAVAction = _UAVplayer addaction  [_exitstr, "pa\Blackfish_leave.sqf"];
	
	{
		if (_x iskindof "RHS_C130J") then{
			_x setobjecttexture [0,""];
			_x setobjecttexture [1,""];
		};
	} forEach attachedObjects _UAV;  
	
	//[[origplayer],{(_this select 0) switchmove "acts_aidlpercmstpslowwrfldnon_warmup_7_loop";}] remoteExec ["bis_fnc_call", 0]; 
	origplayer setUnitPos "MIDDLE";
	origplayer allowfleeing 0;
	origplayer forceSpeed 0;
	dostop origplayer;
	origplayer disableAI "TARGET";
	commandstop origplayer;
	
	origplayer allowdamage false;
	//origplayer setvariable ["ace_medical_enableUnconsciousnessAI",1,false]; //not working, if it does only 50%?

hitcounter = true;
UAVkilledEH = _UAVplayer addEventHandler ["killed", {_this execVM "pa\Blackfish_leave.sqf"}];
OPERATORkilledEH = origplayer addEventHandler ["killed", {[] execVM "pa\Blackfish_leave.sqf"}];
OPERATORhitEH = origplayer addEventHandler ["HitPart", { if (hitcounter)then{[] execVM "pa\Blackfish_leave.sqf";hitcounter=false;};}];

//UncEH = ["ace_unconscious", {if ((origplayer == (_this select 0))||(_thisArgs == (_this select 0))) then {[] execVM "pa\Blackfish_leave.sqf"}}, _UAVplayer] call CBA_fnc_addEventHandlerArgs;

} else {
	hint "action canceled, target was a player or killed!";
	_gunningstr = format ["%1 - GUNNING" ,_UAVname];
	origplayer addaction  [_gunningstr, "pa\Blackfish_enter.sqf"];
};


};
};

};