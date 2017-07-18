/*
	to use blackfish cas feature 
	1. add this in your UAV operator's init field
		_meh1 = this spawn{sleep 1;sleep 1;if (hasInterface) then { waitUntil {!isNull player}; if (local _this) then {player setvariable ["UAV",blackfishcas];  player addaction ["BLACKFISH - GUNNING", "pa\Blackfish_enter.sqf"]; click = true; player addAction ["BLACKFISH - WAYPOINTING", "pa\Blackfish_selectwp.sqf",nil,0];};};};
		
	2. place flying blackfish CAS with this in init:
		this lockTurret [[0],true];
		this lockdriver true; 
		if (isserver) then {[(getpos this),this] execVM "pa\Blackfish_setwp.sqf"};
		
	3. name the blackfish:
		blackfishcas
		
	4. remove 2nd gunner (right gunner) and copilot from blackfish
		
	5. place these 4 script files in your mission.mapname\pa folder:
		blackfish_selectwp.sqf
		blackfish_setwp.sqf
		blackfish_leave.sqf
		blackfish_enter.sqf
		
		
	OPTIONAL: if you wish the blackfish to look like a c130..
	6. add in blackfish init field:
	this setobjecttexture [0,""];this setobjecttexture [1,""];this setobjecttexture [2,""];this setobjecttexture [3,""];
	
	7. Place a c-130-j -- WITH PILOT -- IN THE SKY -- and add in its init field:
	 if (isserver) then {this attachto [blackfishcas,[0,-1.5,-6.5]]; this engineon true; this lock true; {deletevehicle _x}foreach (crew this)}; 
	
	8. Rename the addaction strings in UAV operator's init, replacing BLACKFISH with AC-130
	   e.g. "BLACKFISH - WAYPOINTING" becomes "AC-130 - WAYPOINTING"
*/

if (!click) exitWith {openMap true;};

click = false;
_UAV = player getvariable "UAV";
if (isnil "_UAV") exitWith {hint "Blackfish_selectwp.sqf error: UAV undefined";};

hint parsetext format [
"<t size=2 align=left>
BLACKFISH WAYPOINTING (FAQ)
</t>
<t align=left>
<br/>
<br/>
- Your map opens
<br/>
<br/>
- Click on the location you wish the blackfish to circle
<br/>
- Fly height: 700m
<br/>
- Loiter radius: 1200m
<br/>
<br/>
- Your map will be closed
<br/>
<br/>
- Use the other scrollwheel action to enter the gunner seat
<br/>
- If the Blackfish runs out of fuel, reset the waypoint to reset fuel
"];

openMap true;
_starttime = diag_tickTime;

onMapSingleClick "
	click = true;
onMapSingleClick '';
		_UAV = player getvariable 'UAV';
	   [[_pos,_UAV], 'pa\Blackfish_setwp.sqf'] remoteExec ['execVM', 2];

hint parsetext format [
'<t size=2 align=left>
WAYPOINT SET!
'];
";

waitUntil {click || (_starttime + 30 < diag_tickTime)};
if (!click) then {
	click = true;
	onMapSingleClick "";
	hint parsetext format [
	"<t size=2 align=left>
BLACKFISH WAYPOINTING aborted
	</t>
	<t align=left>
	<br/>
	<br/>
	You-ve waited too long to click.
	<br/>
	Try again.
	"];
} else {
sleep .6;
openMap false;
};