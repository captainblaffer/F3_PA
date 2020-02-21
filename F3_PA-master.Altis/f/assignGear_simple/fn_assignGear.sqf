// klausman's simple assignGear

// DECLARE VARIABLES AND FUNCTIONS

private ["_faction","_typeofUnit","_unit","_ff"];

// The unit's favtion is defined by the base game (or the mod) and
// can be an arbitrary string, though "BLU_F" and OPF_F" are
// common values

_typeofUnit = toLower (_this select 0);
_unit = _this select 1;
_ff = false; // Track if we have found a script for this unit's faction

_faction = toLower (faction _unit);
if(count _this > 2) then
{
  _faction = toLower (_this select 2);
};

// This block will give units insignia on their uniforms, i.e.
// "CO" or "A1" or the like, from the insignia subdirectory.
[_unit,_typeofUnit] spawn {
	#include "f_assignInsignia.sqf"
};

// Only run once, where the unit is local
if !(local _unit) exitWith {};

// This public (global) variable is used in F3's respawn component.
_unit setVariable ["f_var_assignGear",_typeofUnit,true];

// These variables simply track the progress of the gear assignation process,
// for other scripts to reference.
_unit setVariable ["f_var_assignGear_done",false,true];

// Debugging output
if (f_var_debugMode == 1) then
{
  _unit sideChat format ["DEBUG (assignGear.sqf): unit faction: %1",_faction];
};
p
// Any unit with a faction of "blu_f" gets a NATO loadout.
// NOTE: if you use units of other factions, an if-include like the
// one here may be needed.
if (_faction == "blu_f") then {
  #include "f_assignGear_nato.sqf"
  _ff = true;
};

// OPF_F -> CSAT
if (_faction == "opf_f") then {
  #include "f_assignGear_csat.sqf"
  _ff = true;
};

// INDEPEDENT -> AAF
if(_faction == "ind_f") then {
  #include "f_assignGear_aaf.sqf";
  _ff = true;
};

// FIA units can be BLUFOR, OPFOR or INDEPENDENT, the "g"
// in the faction strings probably stands for guerrilla.
if (_faction in ["blu_g_f","opf_g_f","ind_g_f"]) then {
  #include "f_assignGear_fia.sqf"
  _ff = true;
};

private _ff = _unit getVariable ["f_var_assignGear_found_faction"];
if (!_ff) {
   player globalchat format ["DEBUG f\assignGear_simple\fn_assignGear.sqf: Faction '%1' is not known, unit '%2' left untouched.", _faction, _unit];
};
