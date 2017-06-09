/*
fn_CscGroupmanagement
make pa_AIGroups array to be used in clientside caching.
delete empty groups
*/
pa_AIGroups = [];
	{
			if ((count (units _x)) > 0) then {
				if (alive leader _x) then {
				if (!isplayer leader _x) then { // is leader a player? dont add to array
					pa_AIGroups pushback _x;
				};
				} else { // if leader is dead, check other units in group
					private ["_hasplayer"];
					_hasplayer = false;
					{
						if (isplayer _x) exitWith {_hasplayer = true;};
					}foreach units _x;
					if (!_hasplayer) then {pa_AIGroups pushback _x;};
				};
			} else { //delete empty groups
				deleteGroup _x;
				_x = grpNull;
				_x = nil;
			};
	} foreach allGroups;