/*
//player caching 
	_units = ["UnitNATO_CO_P1","UnitNATO_CO_P2","UnitNATO_CO_P3","UnitNATO_CO_PC","UnitNATO_CO","UnitNATO_CO_EN","UnitNATO_CO_FAC"] select {isNil _x};
	_sNeeds = (player in _units);
	[{[_this select 0] call cb_fnc_playerCaching;}, 5, _sNeeds] call CBA_fnc_addPerFrameHandler;
*/

//todo:
//dont cache group leader? done
//uncache new group leader when group leader dies? done
//deal with slingroping vehicles
//deal with dragging crate/putting in car?
//if someone enters a cached car, uncache it
//

private ["_checkDist","_cached"];
_checkDist = getObjectViewDistance select 0; //base check dist on player settings.. was using 700 myself

	// cache dead stuff 
	{
		if (_x distance2D player < _checkDist)then{_x hideobject false; _x enablesimulation true;}else{_x hideobject true; _x enablesimulation false;}; 
	}foreach alldead; //alldeadmen; //playableunits - [player] +
	
	//allmisssionobjects "all" "" 
//"SmokeShell" "GroundWeaponHolder","WeaponHolderSimulated" "Ruins_F"  "Ruins"

	
	
	{
		if (!isplayer leader _x) then { //dont cache player groups
		
        _cached = _x getvariable ["c_cached", false];
		leader _x hideobject false; leader _x enablesimulation true; // always uncache leader in case the old leader died
		if (leader _x distance2D player < _checkDist)then{
			if (_cached) then {
			_x setvariable ["c_cached", false];
			{
				_x hideobject false; _x enablesimulation true; //getobjectviewdistance2D?
			}foreach units _x - [leader _x];
			};
		} else {
			if (!_cached) then {
			_x setvariable ["c_cached", true];
			{
				_x hideobject true; _x enablesimulation false;
			}foreach units _x - [leader _x];
			};
		};
		
		};
		
	}foreach allgroups; 
	
	
/*
	//cache vehicle wrecks, used to be alive vehs?
	{
		if (_x isKindOf "LandVehicle") then {
			_checkDist = 1000;
		} else {
		if (_x isKindOf "air") then {
			_checkDist = 2000;
		}else {
			_checkDist = 250;
		};
		};
		if (_x distance2D player < _checkDist)then{_x hideobject false; _x enablesimulation true;}else{if ({alive _x} count crew _x == 0) then{_x hideobject true; _x enablesimulation false;}};
		
	}foreach alldead - alldeadmen; //vehicles +
*/