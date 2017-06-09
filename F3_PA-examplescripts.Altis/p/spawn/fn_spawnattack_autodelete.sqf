/*
 * Author: Poulern
 * Spawns a group that attacks an area
 *
 * Arguments:
 * 0: array of units
 * 1: start position
 * 2: side of group
 * 3: area marker to attack/search
 * 4: behaviour of group, eg "CARELESS","SAFE","AWARE","COMBAT","STEALTH"
 * 5: combat mode, eg "BLUE","GREEN","WHITE","YELLOW","RED"
 * 6: speed of group "LIMITED","NORMAL","FULL"
 * 7: formation aka "COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE" or "LINE"
 * 8: Oncomplete code to run when done: aka ignore this
 * 9: timeout, but ignore this one as well.
 * Return Value:
 * Nothing.
 *
 * Example:
 * [["ftl","r","m","rat","ar","aar"],"spawnmarker",independent,"attackmarker","COMBAT","YELLOW","FULL","WEDGE"] call p_fnc_spawnattack;
 *
 * Public: [Yes/No]
 */

params ["_unitarray","_position","_side","_marker",
    ["_behaviour", "UNCHANGED", [""]],
    ["_combat", "NO CHANGE", [""]],
    ["_speed", "UNCHANGED", [""]],
    ["_formation", "NO CHANGE", [""]],
    ["_onComplete", "", [""]],
    ["_timeout", [0,0,0], [[]], 3],
	["_autoDeleteDist", 0, [0]]];
private ["_group"];
_group = [_unitarray,_position,_side] call p_fnc_spawngroup;

{
  _x allowFleeing 0;
  _x setskill ["courage",1]

} forEach (units _group);

if (_marker in allMapMarkers) then {
	if (markerShape _marker ==  "RECTANGLE" || markerShape _marker == "ELLIPSE") then {
	  [_group,_marker,_behaviour,_combat,_speed,_formation,_onComplete,_timeout] call CBA_fnc_taskSearchArea;
	}else{
	  [_group,_marker] call CBA_fnc_taskAttack;
	};
} else {
[_group,_marker,_behaviour,_combat,_speed,_formation,_onComplete,_timeout] call CBA_fnc_taskSearchArea;
};

 // This deletes group when waypoint reached and no players nearby
_fnc_autoDeleteGroup = {
        _group = _this select 0;
        _unitsGroup = units _group;
		_dist = _this select 1;
		_wpPos = _this select 2;
		if(_wpPos in allMapMarkers)then{
			_wpPos = getMarkerPos _wpPos;
		}else{
			if (typeName _wpPos == "ARRAY") then{
			}else{
				_wpPos = getPos _wpPos;
			};
		};

		_nearWP = false;
		_pNear = true;
        // Hold until the entire group is dead
        while { ({alive _x} count _unitsGroup) > 0 } do { 
			sleep 5; 
			if (_wpPos distance (Getpos leader _group)<125) then {_nearWP = true;};
			if (_nearWP) then {
				_pNear = [leader _group,_dist] call f_fnc_nearplayer;
			};
			if (!_pNear) exitWith {};// no players near? delete group!
		};
        {
                _origPos = getPos _x;
                _z = _origPos select 2;
                _desiredPosZ = if ( (vehicle _x) iskindOf "Man") then { (_origPos select 2) - 0.5 } else { (_origPos select 2) - 3 };
                if ( (vehicle _x == _x) && _pNear ) then {
                        _x enableSimulation false;
                        while { _z > _desiredPosZ } do {
                                _z = _z - 0.01;
                                _x setPos [_origPos select 0, _origPos select 1, _z];
                                sleep 0.1;
                        };
                };
                deleteVehicle _x;
        } forEach _unitsGroup;         
        // Now we know that all units are deleted
        deleteGroup _group;
};

if (_autoDeleteDist > 0) then {
	[_group, _autoDeleteDist,_marker] spawn _fnc_autoDeleteGroup;
};