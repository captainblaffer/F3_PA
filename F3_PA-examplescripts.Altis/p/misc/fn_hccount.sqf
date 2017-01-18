/*
 * Author: Poulern
 * Locally execute on each headless a function to count how many entities that particular Headless client owns and put it into a publicVariable
 *
 * Arguments:
 * 0: headless
 * 1: headless id
 *
 * Return Value:
 * nothing
 *
 * Example:
 *   [headless, "headless1count2"] remoteExec ["ca_fnc_hccount", headless, true];
 *
 */
params ["_hc","_hcid"];

while {alive _hc} do {
_count = {local _x} count allUnits;

missionNamespace setVariable [_hcid,_count, true];
uisleep 0.1;
};
