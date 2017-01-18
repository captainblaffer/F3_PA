/*
 * Author: Poulern
 * Spawns patrolling AI on each of the markers provided in an array.
 *
 * Arguments:
 * 0: An array of markers ["mkr","mkr_1","mkr_2","mkr_3"]
 * 1: array of units according to F3 ["ftl","r","ar","aar","rat"]
 * 2: side of group eg west east independent
 * 3: radius of area to patrol eg 200
 * Return Value:
 * Nothing.
 *
 * Example:
 * [["mkr","mkr_1","mkr_2","mkr_3"],["ftl","r","m","rat","ar","aar"],independent,200] call p_fnc_masspatrol;
 *
 * Public: [Yes/No]
 */


params ["_markerarray","_unitarray","_side",
      ["_radius", 200, [2]],
	  "_timeout"
      ];
 
if (isnil "_timeout") then {_timeout = 0};

 private ["_group"];
{
  _group = [_unitarray,_x,_side,_radius,_timeout] call p_fnc_spawnpatrol;

} forEach _markerarray;
