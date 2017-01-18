/*
 * Author: Blaffer
 * Spawns x groups that attacks an area
 *
 * Arguments:
 * 0: array of units
 * 1: array of spawn markers
 * 2: side of group
 * 3: trigger or marker area marker to attack/search
 * 4: amount of squads to spawn
 * 5: behaviour of group, eg "CARELESS","SAFE","AWARE","COMBAT","STEALTH"
 * 6: combat mode, eg "BLUE","GREEN","WHITE","YELLOW","RED"
 * 7: speed of group "LIMITED","NORMAL","FULL"
 * 8: formation aka "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE" or "LINE". ignore
 * 9: Oncomplete code to run when done: aka ignore this
 * 10: timeout, but ignore this one as well.
 * Return Value:
 * Nothing.
 *
 * Example:
 * [["ftl","r","m","rat","ar","aar"],["spawnmarker_1","spawnmarker_2","spawnmarker_3"],independent,attacktrigger,6,"AWARE","YELLOW","FULL","WEDGE"] call p_fnc_massattack;
 * Public: [Yes/No]
 */

params ["_unitarray","_positionarray","_side","_marker","_amount",
    ["_behaviour", "UNCHANGED", [""]],
    ["_combat", "NO CHANGE", [""]],
    ["_speed", "UNCHANGED", [""]],
    ["_formation", "NO CHANGE", [""]],
    ["_onComplete", "", [""]],
    ["_timeout", [0,0,0], [[]], 3]
	];
  private ["_group","_curposition","_thenr"];
  
 if(_positionarray in allMapMarkers)then{
	_positionarray = [_positionarray];
};
 
 for "_i" from 0 to (_amount -1) do {
 
 _thenr = _I % (count _positionarray);
 _curposition = _positionarray select _thenr;

 [_unitarray,_curposition,_side,_marker,_behaviour,_combat,_speed,_formation,_onComplete,_timeout] call p_fnc_spawnattack;

};
