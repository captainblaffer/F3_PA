// ACE Arsenal templates
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//
// This script is intended to make adding limited ACE Arsenals to items easier

// Author: Tobias Klausmann
// License: Apache-2 (https://www.apache.org/licenses/LICENSE-2.0)
// Version: v0.1
//
//
// Parameters:
// 0: The box to add the arsenal to
// 1: (optional) The arsenal type. If nil, use the default arsenal
//
// Examples:
//
//  nul = [this] call "pa\ace_arsenal\fn_set_ace_arsenal.sqf";  // Default Arsenal
//  nul = [this, "baseOpfor"];             // Arsenal by explicit name
//  nul = [someBox, "baseNato"];            // Add arsenal to someBox
//
// More info can be found in README.md


private ["_argc", "_box", "_atype", "_contents", "_a"];

if (!isServer) exitWith {};

f_handguns = compile preprocessFileLineNumbers "pa\ace_arsenal\f_handguns.sqf";
f_items = compile preprocessFileLineNumbers "pa\ace_arsenal\f_items.sqf";
f_launchers = compile preprocessFileLineNumbers "pa\ace_arsenal\f_launchers.sqf";
f_optics = compile preprocessFileLineNumbers "pa\ace_arsenal\f_optics.sqf";
f_rifles = compile preprocessFileLineNumbers "pa\ace_arsenal\f_rifles.sqf";
f_throwables = compile preprocessFileLineNumbers "pa\ace_arsenal\f_throwables.sqf";

_contents= [];

_argc = count _this;
_box = _this select 0;
if (_argc > 1) then {
    _atype = _this select 1;
} else {
    _atype = "baseNato";
};

if (isNil "_box") then {
        hint format ["ace_arsenal called with nil box"];
};

switch (_atype) do {

    case "baseNato": {
        // Rifles
        {   _a = [_x] call f_rifles; 
            _contents = _contents + _a; } foreach 
            ["ebr" ,"m4a1_block2" ,"m24" ,"mk11" ,"mk18" ,"mk46m1"];
        // Optics
        {   _a = [_x] call f_optics; 
            _contents = _contents + _a; } foreach 
            ["holosights" ,"rco" ,"scopes"];
        // Handguns
        {   _a = [_x] call f_handguns; 
            _contents = _contents + _a; } foreach 
            ["m1911a1" ,"fnx45"];
        // Launchers
        {   _a = [_x] call f_launchers; 
            _contents = _contents + _a; } foreach 
            ["at-4", "maaws"];
        // Hand grenades etc.
        {   _a = [_x] call f_throwables; 
            _contents = _contents + _a; } foreach 
            ["frags", "smoke", "incendiary"];

        // Specialist Roles
        {   _a = [_x] call f_items; 
            _contents = _contents + _a; } foreach
            ["engineers", "medics"];
        // Stuff for everybody
        {   _a = [_x] call f_items; 
            _contents = _contents + _a; } foreach
            ["backpacks", "binos", "goggles", "gps", "helmets", "misc",
             "radios", "univests"];
    }; // End of natoDefault

    default {
            hint format ["ace_arsenal on %1 called with unknow arsenal type %2",
                          _box, _atype];
            _contents = [];
    };
}; // End of switch(_atype)

[_box, _contents, true] call ace_arsenal_fnc_initBox;
