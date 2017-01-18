// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY

if (!isDedicated && (isNull player)) then
{
    waitUntil {sleep 0.1; !isNull player};
};

// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_unitSide"];

waitUntil {!isnil "f_var_debugMode"};

// ====================================================================================

// DETECT PLAYER FACTION
// The following code detects what side the player's slot belongs to, and stores
// it in the private variable _unitSide

_unitSide = side player;

// DEBUG
	if (f_var_debugMode == 1) then
	{
	player sideChat format ["DEBUG (briefing.sqf): Player faction: %1",str _unitSide];
	};

// ====================================================================================

// BRIEFING: ADMIN
// The following block of code executes only if the player is the current host
// it automatically includes a file which contains the appropriate briefing data.

if (serverCommandAvailable "#kick") then {

#include "f\briefing\f_briefing_admin.sqf"

// DEBUG
	if (f_var_debugMode == 1) then
	{
		player sideChat format ["DEBUG (briefing.sqf): Briefing for host selected."];
	};
};

// ====================================================================================

// BRIEFING: WEST
// The following block of code executes only if the player is in a BLU slot; it
// automatically includes a file which contains the appropriate briefing data.

if (_unitSide == west) exitwith {

#include "f\briefing\f_briefing_west.sqf"

// DEBUG
	if (f_var_debugMode == 1) then
	{
	player sideChat format ["DEBUG (briefing.sqf): Briefing for %1 slot selected.",str _unitSide];
	};
};

// ====================================================================================

// BRIEFING: EAST
// The following block of code executes only if the player is in a OPF slot; it
// automatically includes a file which contains the appropriate briefing data.

if (_unitSide == east) exitwith {

#include "f\briefing\f_briefing_east.sqf"

// DEBUG
	if (f_var_debugMode == 1) then
	{
	player sideChat format ["DEBUG (briefing.sqf): Briefing for %1 slot selected.",str _unitSide];
	};
};
// ====================================================================================

// BRIEFING: INDEPENDENT
// The following block of code executes only if the player is in a GUER
// slot; it automatically includes a file which contains the appropriate briefing data.

if (_unitSide == resistance) exitwith {

#include "f\briefing\f_briefing_resistance.sqf"

// DEBUG
	if (f_var_debugMode == 1) then
	{
	player sideChat format ["DEBUG (briefing.sqf): Briefing for %1 slot selected.",str _unitSide];
	};
};

// ====================================================================================

// BRIEFING: CIVILIAN
// The following block of code executes only if the player is in a CIVILIAN
// slot; it automatically includes a file which contains the appropriate briefing data.

if (_unitSide == civilian) exitwith {

#include "f\briefing\f_briefing_civ.sqf"

// DEBUG
	if (f_var_debugMode == 1) then
	{
	player sideChat format ["DEBUG (briefing.sqf): Briefing for %1 slot selected.",str _unitSide];
	};
};



// ====================================================================================

// ERROR CHECKING
// If the faction of the unit cannot be defined, the script exits with an error.

player globalchat format ["DEBUG (briefing.sqf): Side %1 is not defined.",str _unitSide];
