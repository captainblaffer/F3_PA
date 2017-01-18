/*
		TUTORIAL
	https://www.youtube.com/watch?v=YZ4QC96Kqe0
	
	arguments:
		0: nothing
		1:crate
		2:inventory (supplyinit.sqf)
		3:(optional) drop position
	["","B_CargoNet_01_ammo_F","FncSupplyCargo4",[x,y,z]] remoteExec ["pa_fnc_supply", 2]; 
	
	laptop_1 addAction ["Call Supplies", "dosupplies_1 = true; publicvariable 'dosupplies_1'; {removeallactions laptop_1; } remoteExec ['bis_fnc_call', 0, true]; "];
	place a trigger that only executes on server... condition: dosupplies_1 ... on act: _bla = ["","B_CargoNet_01_ammo_F","FncSupplyCargo4",[x,y,z]] spawn pa_fnc_supply; 
	
*/	
	private ["_autopos"];
	
	_supplyBoxFnc = _this select 1;
	_supplyCargoFnc = _this select 2;
	_autopos = _this select 3;
	if !(isnil ("_autopos")) then {	
		_supplyLocArray = [+1000,-1375,-1500,-1125,+1250,-1000,+1375,-1250,+1500,+1125];
		//:::::::::::|USE THE ONE BELOW FOR TESTING, IT SPAWNS THE HELI MUCH CLOSER|:::::::::::
		//_supplyLocArray = [+500,-500];
		_supplyRandomLocX = _supplyLocArray select floor random count _supplyLocArray;
		_supplyRandomLocY = _supplyLocArray select floor random count _supplyLocArray;
		_supply = [[(_autopos select 0)+_supplyRandomLocX,
					(_autopos select 1)+_supplyRandomLocY, 
					(_autopos select 2)+50], 180, "B_Heli_Transport_03_unarmed_F", WEST] call bis_fnc_spawnvehicle; //I_Heli_Transport_02_F B_Heli_Transport_03_unarmed_F
		_supplyHeli = _supply select 0;
		_supplyHeliPos = getPos _supplyHeli;
		_supplyMrkrHeli = createMarker ["supplyMrkrHeli", _supplyHeliPos];
		_supplyCrew = _supply select 1;
		_supplyGrp = _supply select 2;
		_supplyGrp setSpeedMode "FULL";
		_supplyGrp setBehaviour "CARELESS";
		_supplyWP1 =_supplyGrp addWaypoint [(_autopos),1];
		_supplyWP1 setWaypointType "MOVE";
		_supplyWP2 = _supplyGrp addWaypoint [[(_autopos select 0)+_supplyRandomLocX, 
											(_autopos select 1)+_supplyRandomLocY, 
											_autopos select 2], 2];
		_supplyMrkrLZ = createMarker ["supplyMrkrLZ", _autopos];
		"supplyMrkrLZ" setMarkerType "Empty";
		"supplyMrkrHeli" setMarkerType "Empty";
		_supplyHeli flyInHeight 150;
		clicked = 1;


	}else{
	openMap [true,true];
	clicked = 0;
	hintc "Left click on the map where you want the supplies dropped";

	["supplymapclick", "onMapSingleClick", {
		_supplyLocArray = [+1000,-1375,-1500,-1125,+1250,-1000,+1375,-1250,+1500,+1125];
//:::::::::::|USE THE ONE BELOW FOR TESTING, IT SPAWNS THE HELI MUCH CLOSER|:::::::::::
		//_supplyLocArray = [+500,-500];
		_supplyRandomLocX = _supplyLocArray select floor random count _supplyLocArray;
		_supplyRandomLocY = _supplyLocArray select floor random count _supplyLocArray;
		_supply = [[(_pos select 0)+_supplyRandomLocX,
					(_pos select 1)+_supplyRandomLocY, 
					(_pos select 2)+50], 180, "B_Heli_Transport_03_unarmed_F", WEST] call bis_fnc_spawnvehicle; //I_Heli_Transport_02_F B_Heli_Transport_03_unarmed_F
		_supplyHeli = _supply select 0;
		_supplyHeliPos = getPos _supplyHeli;
		_supplyMrkrHeli = createMarker ["supplyMrkrHeli", _supplyHeliPos];
		_supplyCrew = _supply select 1;
		_supplyGrp = _supply select 2;
		_supplyGrp setSpeedMode "FULL";
		_supplyGrp setBehaviour "CARELESS";
		_supplyWP1 =_supplyGrp addWaypoint [(_pos),1];
		_supplyWP1 setWaypointType "MOVE";
		_supplyWP2 = _supplyGrp addWaypoint [[(_pos select 0)+_supplyRandomLocX, 
											(_pos select 1)+_supplyRandomLocY, 
											_pos select 2], 2];
		_supplyMrkrLZ = createMarker ["supplyMrkrLZ", _pos];
		"supplyMrkrLZ" setMarkerType "Empty";
		"supplyMrkrHeli" setMarkerType "Empty";
		_supplyHeli flyInHeight 150;
		clicked = 1;
		openmap [false,false];
		onMapSingleClick '';}] call BIS_fnc_addStackedEventHandler; 
	};
	
	waitUntil {(clicked == 1)};
		hintsilent "The supplies are on the way";
		_supplyMrkrHeliPos = getMarkerPos "supplyMrkrHeli";
		_supplyMrkrHeliPos2 = [_supplyMrkrHeliPos select 0, 
								_supplyMrkrHeliPos select 1, 
								(_supplyMrkrHeliPos select 2)+50];
		_supplyHeli = _supplyMrkrHeliPos2 nearestObject "B_Heli_Transport_03_unarmed_F"; //I_Heli_Transport_02_F B_Heli_Transport_03_unarmed_F
		_supplyMrkrLZPos = getMarkerPos "supplyMrkrLZ"; 
		_supplyLZ = createVehicle ["Land_Laptop_device_F", getMarkerPos "supplyMrkrLZ", [], 0, "NONE"];
		deleteMarker "supplyMrkrHeli";
		deleteMarker "supplyMrkrLZ";
		_supplyLZ hideObjectGlobal true;
		
	waitUntil {( _supplyLZ distance _supplyHeli)<400};
		_supplyHeli animateDoor ["Door_rear_source",1]; //Door_rear_source CargoRamp_Open
		_supplyChute = createVehicle ["B_parachute_02_F", [getpos _supplyHeli select 0,getpos _supplyHeli select 1,(getpos _supplyHeli select 2)+500], [], 0, "CAN_COLLIDE"];
		_supplyChute allowDamage false;
		_supplyChute hideObjectGlobal true;
		_supplyChute disableCollisionWith _supplyHeli;
		_supplyHeli disableCollisionWith _supplyChute;
	waitUntil {( _supplyLZ distance _supplyHeli)<200};
		sleep 2;
		
		_supplyHeli allowDammage false;
		_supplyBox = createVehicle 
						[_supplyBoxFnc, position _supplyHeli, [], 0, "CAN_COLLIDE"];
						clearBackpackCargoGlobal _supplyBox;
						clearWeaponCargoGlobal _supplyBox;
						clearMagazineCargoGlobal _supplyBox;
						clearItemCargoGlobal _supplyBox;
		_supplyBox allowDammage false;
		_supplyBox attachTo [_supplyHeli, [0, 0, 0], "CargoRamp"]; 
		_supplyBox setDir ([_supplyBox, _supplyHeli] call BIS_fnc_dirTo);
		_supplyBox setpos [getpos _supplyHeli select 0,getpos _supplyHeli select 1,(getpos _supplyHeli select 2)-3];
		detach _supplyBox;
		deleteVehicle _supplyLZ;
		[_supplyBox,_supplyCargoFnc,nil,true] spawn BIS_fnc_MP;
		[_supplyBox,"FncSupplyLight",nil,true] spawn BIS_fnc_MP; 
	
	_supplyChute setPos [getpos _supplyBox select 0,getpos _supplyBox select 1,(getpos _supplyBox select 2)+4];
	_supplyBox attachTo [_supplyChute,[0,0,0.0]];	
	_supplyChute hideObjectGlobal false;
																			
//:::::::::::|LIGHT|:::::::::::
	_supplyLight = "Chemlight_green" createVehicle (position _supplyBox);
	_supplyLight attachTo [_supplyBox, [0,0,0]];
//:::::::::::::::::::::::::::::		
	
	sleep 1;
	hintsilent "The supplies have been dropped";
	_supplyHeli allowDammage true;
	_supplyBox allowDammage true;
	_supplyHeli animateDoor ["Door_rear_source",0];// Door_rear_source CargoRamp_Open
	
//:::::::::::|SMOKE|:::::::::::
	_supplySmoke = "SmokeShell" createVehicle (position _supplyBox);
	_supplySmoke attachTo [_supplyBox, [0,0,0]];
//:::::::::::::::::::::::::::::
	
	waitUntil {(getPos _supplyBox select 2)<2}; 
	detach _supplyBox;
		_supplyChute setPos [ (getPos _supplyChute select 0)+0.75, getPos _supplyChute select 1, getPos _supplyChute select 2];
		hintsilent "";
		sleep 5;
		{deleteVehicle _x;}forEach crew _supplyHeli;deleteVehicle _supplyHeli;
		//hint "end";





