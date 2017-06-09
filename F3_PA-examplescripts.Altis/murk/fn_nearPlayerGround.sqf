// F3 - Near B Player Function
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS
private ["_ent","_distance","_pos","_cPos","_players","_countP"]; //,"_return"

_cPos = (_this select 0);
if(_cPos in allMapMarkers)then{
	_pos = getMarkerPos _cPos;
}else{
	if (typeName _cPos == "ARRAY") then{
		_pos = _cPos;
	}else{
		_pos = getPosATL _cPos;
	};
};
_distance = _this select 1;

// ====================================================================================

// Create a list of all players
_players = [];

{
   if (isPlayer _x) then {
   _countP = true;
   if (surfaceiswater getpos _x) then {
   if (getposasl _x select 2 > 30) then {
   if (count crew vehicle _x < 3) then {
   if (!(vehicle _x iskindof "Steerable_Parachute_F")) then {
   _countP = false;
   };
   };
   };
   } else {
   if (getposatl _x select 2 > 30) then {
   if (count crew vehicle _x < 3) then {
   if (!(vehicle _x iskindof "Steerable_Parachute_F")) then {
   _countP = false;
   };
   };
   };
   };
   //
   if (_countP) then {
	_players = _players + [_x]
   };
   };
} forEach playableUnits;

// ====================================================================================

// Check whether a player is in the given distance - return true if yes
if (({_x distance _pos < _distance} count _players) > 0) exitWith {true};

false

//bad return idea
//_return = [false,nil];
//{if (_x distance _pos < _distance) exitWith {_return = [true,_x]; };}foreach _players;

//_return
