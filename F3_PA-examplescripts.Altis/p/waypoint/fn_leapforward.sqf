/*
 * Author: Blaffer
 * Leaps vehicle closer to target until it reaches, then patrols
 *
 * Arguments:
 * 0: group
 * 1: attack marker
 * 2: distance to leap. (optional)
 * Return Value:
 * Nothing.
 *
 * Example:
 * [this,"attackmarker"] call p_fnc_leapforward;
 * Public: [Yes/No]
 */

params ["_group","_attackmarker",
    ["_leapdist", 0, [0]]
	];
	
private ["_group","_attackmarkerpos","_leapdist","_newwppos","_speed","_safewppos"];

if(_attackmarker in allMapMarkers)then{
	_attackmarkerpos = getMarkerPos _attackmarker;
}else{
	if (typeName _attackmarker == "ARRAY") then{
		_attackmarkerpos = _attackmarker;
	}else{
		_attackmarkerpos = getPos _attackmarker;
	};
};

leader _group setvariable ["myattackpos",_attackmarker, false];

_distance = (getpos leader _group) distance _attackmarkerpos;

if (_distance < 1200) then {
	gunner (vehicle (leader _group)) doWatch _attackmarkerpos;
	uisleep (15 + random(15));
	gunner (vehicle (leader _group)) doWatch objnull;
};

if (_distance > 100) then {
	
	if (_leapdist < 1) then {
		_leapdist = ((getpos leader _group) distance _attackmarkerpos) / 5 + 80;
	};
	_newwppos = [ (getpos leader _group) , _leapdist, ((leader _group) getdir _attackmarkerpos) ] call BIS_fnc_relPos; 
	if (_distance > 800) then {_speed = "NORMAL"} else {_speed = "LIMITED"};
	
	_safewppos = [_newwppos, 0, 60, 3, 0, 0.5, 0, [], [_newwppos,_newwppos]] call BIS_fnc_findSafePos;
	if ( count _safewppos < 1 ) then { _safewppos = _newwppos; }; 
	if ( count _safewppos < 3 ) then { _safewppos pushback 0 }; 

	_wp1 = _group addWaypoint [_safewppos, 0];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointBehaviour "COMBAT";
	_wp1 setWaypointCombatMode "RED";
	_wp1 setWaypointSpeed _speed;
	//_wp1 setWaypointTimeout [30,45,60];
	_wp1 setWaypointStatements ["true","deleteWaypoint [group this, currentWaypoint (group this)]; [(group this),((leader group this) getvariable 'myattackpos')] spawn p_fnc_leapforward"]; 
	
} else {

	gunner (vehicle (leader _group)) doWatch _attackmarkerpos;
	_mname = format ["leap_%1",_attackmarker];
	_marker = createMarkerlocal [_mname,_attackmarkerpos];
	_marker setMarkerShapelocal "ELLIPSE";
	_marker setmarkersizelocal [300,300];
	_marker setMarkeralphalocal 0;
	[_group,_marker,"COMBAT","RED","LIMITED"] call CBA_fnc_taskSearchArea;
};


