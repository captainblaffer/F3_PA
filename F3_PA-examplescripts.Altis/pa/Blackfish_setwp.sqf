/*
 executes on server
 
 you can tweak fly height and radius here I guess
*/

_pos = _this select 0;
_pilot = driver  (_this select 1);
_gunner = (crew (_this select 1)) select 1;
_flyradius = 1200;
_flyheight = 700;
_aslheight = (ATLToASL _pos) select 2;
if (_aslheight < 0) then {_aslheight = 0};
_aslheight = _aslheight + _flyheight;

 (_this select 1) setfuel 1;
 (_this select 1)  flyinheight 500;
 (_this select 1)  flyinheightasl [_aslheight,_aslheight,_aslheight];
[(_this select 1),_aslheight,_pos,_flyradius] SPAWN{
	//sleep 5; 
	//(_this select 0) flyinheightasl [(_this select 1),(_this select 1),(_this select 1)];
	waitUntil {sleep 2; (_this select 2) distance2d (_this select 0) < ((_this select 3)+200)}; 
	(_this select 0) flyinheightasl [(_this select 1),(_this select 1),(_this select 1)];
};

(group _pilot) setBehaviour "CARELESS";
_pilot disableAI "TARGET";
_pilot disableAI "AUTOTARGET";
_gunner disableAI "TARGET";
_gunner disableAI "AUTOTARGET";
_gunner disableAI "AUTOCOMBAT";

while {(count (waypoints group _pilot)) > 0} do { deleteWaypoint ((waypoints group _pilot) select 0); };

_newwp = (group _pilot) addWaypoint [_pos, 0];

_newwp setWaypointType "LOITER";
_newwp setWaypointLoiterRadius _flyradius;
_newwp setWaypointSpeed "NORMAL";
_newwp setWaypointBehaviour "CARELESS";
_newwp setWaypointLoiterType "CIRCLE_L"; //"CIRCLE";
//_newwp setWaypointCombatMode "BLUE";