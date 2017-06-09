// File: murk_spawn.sqf
// Function: To allow for simple trigger based spawning using editor placed units and waypoints. The script deletes all units when the mission start and the recreate them on command.
// Parameters:
//  _this select 0: OBJECT - unit name (this)
//      _this select 1: BOOL - use F3 assigngear?
//      _this select 2: STRING - spawn type ("once","repeated","wave" and "reset")
//      _this select 3 (optional): NUMBER - spawn lives (the amount of time the unit respawns, or wave number)
//      _this select 4 (optional): NUMBER - spawn delay
//      _this select 5 (optional): STRING - init string called for the leader of the group
//      _this select 6 (optional): NUMBER-  will start removal sequence of all dead group members after X seconds (default 120)
//      _this select 7 (optional): NUMBER-  will auto-delete units when waypoint reached if no player is within X distance (default 0 = DISABLED)
// Usage:
//  Example trigger: Anybody Once (or whatever you want), onActivation: triggername setVariable ["murk_spawn",true,true];
//      Unit (leader of group): nul = [this,F3GEAR,"SPAWNTYPE",LIVES,DELAY,"SL INIT",DEADDELETETIME,NOPLAYERDELETEDIST] execVM "murk\murk_spawn.sqf";
//            
// Example: nul = [this,true,"once"] execVM "murk\murk_spawn.sqf"; ---- Will spawn the editor unit once based on the trigger
// Example: nul = [this,true,"repeated",4,30] execVM "murk\murk_spawn.sqf"; ---- Will spawn the editor unit based on the trigger, then respawn it 4 times with a 30 second delay upon death
// Example: nul = [this,true,"wave",5,60] execVM "murk\murk_spawn.sqf"; ---- Will spawn the editor unit once based on the trigger, then respawn the entire group (regardless of deaths) 5 times with 60 seconds between
// Example: nul = [this,true,"reset",5] execVM "murk\murk_spawn.sqf"; ---- Will spawn the editor unit once based on the trigger, then reset the trigger after a preset time (15 seconds default). The unit will be created when trigger is true again, maximum number of lives.
// Example: nul = [this,true,"repeated",4,90,"",120,300] execVM "murk\murk_spawn.sqf"; ---- same as example 2, but will automatically delete units when last waypoint is reached and no players are within 300m. IF players return, squad respawns from their beginning.
// -----------------------------------------------------------------------------------------------------
// V9.PA_1 (Captainblaffer)
// - Changes for PA
// V9.? Working Build (Wulfy Wulf)
// - Change: unitInfoArray handles uniforms, vests, backpacks, and objects within now
// - Fix: Some RPT errors from incorrect conditions not entering or terminating properly
// - Fix: Some RPT errors from spawnUnit initializing to Object- uses null now
// V9 (Murklor again :p)
// - Note: Initial Arma 3 test script. Note that some functionality from V8/V7 has been taken out because my brain is too foggy to understand everything, this is simplified. Sort of.
// - Fix: setVehicleInit has been removed from A3, testing another way
// - Add: New example mission on Stratis
// - Change: The trigger variable is held in the object that is synchronized to the group for improved WYSIWYG. This means that the trigger argument is no longer needed.
// - Change: Updated this readme to reflect the changes
// V8 (ArmAIIholic)
// - Waypoints are also remembered -- no dummy groups at all!!!
// - You get the output on Clipboard you can paste and execute. Added loader for Clipboard missions.
// V7 (ArmAIIholic)
// - Added GameLogic center to reduce number of dummy groups at the beginning, and in modes repeated and reset
// - Changed beginning scope to isServer, rather than using exitWith
// - Shortened initializing trigger part in init.sqf
// - Added original instructions and examples, adapted for v7
// - SQM is from v5 with some groups added
// V6
// - See older versions
 
// This script is serverside
if(isServer) then
{
 
// -------------------  Init  ----------------------- //
_countThis = count _this;
_waitingPeriod = 8;  // Waiting period between script refresh
 
// ----------------  Parameters  -------------------- //
_unit = _this select 0;
_f3gear = _this select 1;
_spawntype = _this select 2;
_spawnlives = if (_countThis >= 4) then { _this select 3; } else { 1 }; // Optional
_spawndelay = if (_countThis >= 5) then { _this select 4; } else { 1 }; // Optional
_initString = if (_countThis >= 6) then { _this select 5; } else { "" }; // Optional
_bodyRemove = if (_countThis >= 7) then { _this select 6; } else { 360 }; // Optional
_autoDeleteDist = if (_countThis >= 8) then { _this select 7; } else { 0 }; // Optional
 
// The object (trigger, whatever) the unit is synchronized to hold the trigger variable
_triggerObject = (synchronizedObjects _unit) select 0;
_triggerObject setVariable ["murk_spawn",false,false];
 
// --  Delete the unit (this is always done ASAP)  -- //
_unitArray = [];
_unitGroup = group _unit;
_unitsInGroup = units _unitGroup;
_unitCount = count _unitsInGroup;
_unitsInGroupAdd = [];
_side = side _unitGroup;
 
while { count units _unitGroup > 0 } do {
        // The currently worked on unit
        _unitsInGroup = units _unitGroup;
        _unit = _unitsInGroup select 0;
        _unitCount = count _unitsInGroup;
        diag_log format["Unit: %1, Units left: %2",_unit,units _unitGroup];
        //hint format ["Deleting: %1 - vehicleVarName: %2", _unit, vehicleVarName _unit]; sleep 1;
       
        // Check if its a vehicle
        if ( (vehicle _unit) isKindOf "LandVehicle" OR (vehicle _unit) isKindOf "Air") then {
                _vcl = vehicle _unit;
                if (!(_vcl in _unitsInGroupAdd) AND (typeOf _vcl != "")) then {
                        _unitsInGroupAdd set [count _unitsInGroupAdd, _vcl];
                        _unitCrewArray = [];
                        _crew = crew _vcl;
                        { _unitCrewArray set [count _unitCrewArray, typeOf _x]; } forEach _crew;
                       
                        _unitInfoArray = [
                                typeOf _vcl,
                                getPos _vcl,
                                getDir _vcl,
                                vehicleVarName _vcl,
                                skill _vcl,
                                rank _vcl,
                                _unitCrewArray,
                                weapons _vcl,
                                assignedItems _vcl,
                                uniform _vcl,
                                uniformItems _vcl,
                                vest _vcl,
                                vestItems _vcl,
                                backpack _vcl,
                                backpackItems _vcl,
                                headgear _vcl,
                                goggles _vcl,  
                                face _vcl
                        ];
                        _unitArray set [count _unitArray, _unitInfoArray];
                        deleteVehicle _vcl;
                        { deleteVehicle _x; } forEach _crew;
                };
        }
        // Otherwise its infantry
        else {
                _unitInfoArray = [
                        typeOf _unit,
                        getPos _unit,
                        getDir _unit,
                        vehicleVarName _unit,
                        skill _unit,
                        rank _unit,
                        [],
                        weapons _unit,
                        assignedItems _unit,
                        uniform _unit,
                        uniformItems _unit,
                        vest _unit,
                        vestItems _unit,
                        backpack _unit,
                        backpackItems _unit,
                        headgear _unit,
                        goggles _unit,  
                        face _unit  
                       
                ];
                _unitArray set [count _unitArray, _unitInfoArray];
                deleteVehicle _unit;
        };
        sleep 0.01;
};
 
// Gathering waypoints
_countWaypoints = 0;
_waypointsArray = [];
_waypointsEntry = [];
_countWaypoints = count(waypoints _unitGroup);
 
for [{_i=0}, {_i < _countWaypoints}, {_i=_i+1}] do
{
        _waypointsEntry = [];
       
        _wPos = waypointPosition [_unitGroup, _i];
        _wHPos = waypointHousePosition [_unitGroup, _i];
        _wBih = waypointBehaviour [_unitGroup, _i];
        _wCM = waypointCombatMode [_unitGroup, _i];
        _wCR = waypointCompletionRadius [_unitGroup, _i];
        _wDes = waypointDescription [_unitGroup, _i];
        _wForm = waypointFormation [_unitGroup, _i];
        _wScr = waypointScript [_unitGroup, _i];
        _wShw = waypointShow [_unitGroup, _i];
        _wSp = waypointSpeed [_unitGroup, _i];
        _wSt = waypointStatements [_unitGroup, _i]; //diag_log _wSt;
        _wTo = waypointTimeout [_unitGroup, _i];
        _wTy = waypointType [_unitGroup, _i];
       
        _waypointsEntry = _waypointsEntry + [_wPos] + [_wHPos] + [_wBih] + [_wCM] + [_wCR] + [_wDes] + [_wForm] + [_wScr] + [_wShw] + [_wSp] + [_wSt] + [_wTo] + [_wTy];
 
        _waypointsArray = _waypointsArray + [_waypointsEntry];
};
 
//diag_log format ["Waypoints' array : %1",_waypointsArray];
 
deleteGroup _unitGroup;
 
// -----------------  Functions  -------------------- //
 
// *WARNING* BIS FUNCTION RIPOFF - Taken from fn_returnConfigEntry as its needed for turrets and shortened a bit
_fnc_returnConfigEntry = {
        private ["_config", "_entryName","_entry", "_value"];
        _config = _this select 0;
        _entryName = _this select 1;
        _entry = _config >> _entryName;
        //If the entry is not found and we are not yet at the config root, explore the class' parent.
        if (((configName (_config >> _entryName)) == "") && (!((configName _config) in ["CfgVehicles", "CfgWeapons", ""]))) then {
                [inheritsFrom _config, _entryName] call _fnc_returnConfigEntry;
        }
        else { if (isNumber _entry) then { _value = getNumber _entry; } else { if (isText _entry) then { _value = getText _entry; }; }; };
        //Make sure returning 'nil' works.
        if (isNil "_value") exitWith {nil};
        _value;
};
       
// *WARNING* BIS FUNCTION RIPOFF - Taken from fn_fnc_returnVehicleTurrets and shortened a bit
_fnc_returnVehicleTurrets = {
        private ["_entry","_turrets", "_turretIndex"];
        _entry = _this select 0;
        _turrets = [];
        _turretIndex = 0;
        //Explore all turrets and sub-turrets recursively.
        for "_i" from 0 to ((count _entry) - 1) do {
                private ["_subEntry"];
                _subEntry = _entry select _i;
                if (isClass _subEntry) then {
                        private ["_hasGunner"];
                        _hasGunner = [_subEntry, "hasGunner"] call _fnc_returnConfigEntry;
                        //Make sure the entry was found.
                        if (!(isNil "_hasGunner")) then {
                                if (_hasGunner == 1) then {
                                        _turrets = _turrets + [_turretIndex];          
                                        //Include sub-turrets, if present.
                                        if (isClass (_subEntry >> "Turrets")) then { _turrets = _turrets + [[_subEntry >> "Turrets"] call _fnc_returnVehicleTurrets]; }
                                        else { _turrets = _turrets + [[]]; };
                                };
                        };
                        _turretIndex = _turretIndex + 1;
                };
        };
        _turrets;
};
 
_fnc_moveInTurrets = {
        private ["_turrets","_path","_i"];
        _turrets = _this select 0;
        _path = _this select 1;
        _currentCrewMember = _this select 2;
        _crew = _this select 3;
        _spawnUnit = _this select 4;
        _i = 0;    
        while {_i < (count _turrets) AND _currentCrewMember < count _crew} do {
                 _turretIndex = _turrets select _i;
                _thisTurret = _path + [_turretIndex];
                (_crew select _currentCrewMember) moveInTurret [_spawnUnit, _thisTurret]; _currentCrewMember = _currentCrewMember + 1;
                //Spawn units into subturrets.
                [_turrets select (_i + 1), _thisTurret, _currentCrewmember, _crew, _spawnUnit] call _fnc_moveInTurrets;
                _i = _i + 2;
        };
};
 
// This is the general cleanup function running in the background for the group, replaces the removebody eventhandler and delete group in V5
_fnc_cleanGroup = {
        _group = _this select 0;
        _unitsGroup = units _group;
        _sleep = _this select 1;
        // Hold until the entire group is dead
        while { ({alive _x} count _unitsGroup) > 0 } do { sleep 5; };
        sleep _sleep;
        {
                _origPos = getPos _x;
                _z = _origPos select 2;
                _desiredPosZ = if ( (vehicle _x) iskindOf "Man") then { (_origPos select 2) - 0.5 } else { (_origPos select 2) - 3 };
                if ( vehicle _x == _x ) then {
                        _x enableSimulation false;
                        while { _z > _desiredPosZ } do {
                                _z = _z - 0.01;
                                _x setPos [_origPos select 0, _origPos select 1, _z];
                                sleep 0.1;
                        };
                };
                deleteVehicle _x;
                sleep 5;
        } forEach _unitsGroup;        
        // Now we know that all units are deleted
        deleteGroup _group;
};
 
 // This deletes group when waypoint reached and no players nearby
_fnc_autoDeleteGroup = {
        _group = _this select 0;
        _unitsGroup = units _group;
        _sleep = _this select 1;
        _dist = _this select 2;
        _wpPos = _this select 3;
		_triggerObject = _this select 4;
                
        _nearWP = false;
        _pNear = true;
        // Hold until the entire group is dead
        while { ({alive _x} count _unitsGroup) > 0 } do {
            sleep 5;
            if (_wpPos distance (Getpos leader _group)<125) then {_nearWP = true;};
            if (_nearWP) then {
                _pNear = [leader _group,_dist] call f_fnc_nearplayer;
            };
            if (!_pNear) exitWith {_sleep = 0;};// no players near? delete group!
        };
        sleep _sleep;
        _sleep = 5;
        if (!_pNear) then {_sleep = 0};
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
                sleep _sleep;
        } forEach _unitsGroup;        
        // Now we know that all units are deleted
		_triggerObject setVariable ["murk_spawn",false,false];
        deleteGroup _group;
};
 
_fnc_spawnUnit = {
        // We need to pass the old group so we can copy waypoints from it, the rest we already know
        _oldGroup = _this select 0;
        _newGroup = createGroup (_this select 1);
        _waypointsArray = _this select 2;
        // If the old group doesnt have any units in it its a spawned group rather than respawned
        if ( count (units _oldGroup) == 0) then { deleteGroup _oldGroup; };
        {
                _spawnUnit = nil;
                _unitType = _x select 0; _unitPos  = _x select 1; _unitDir  = _x select 2;
                _unitName = _x select 3; _unitSkill = _x select 4; _unitRank = _x select 5;
                _unitCrew = _x select 6;
                // New A3 related gear
                _unitWeapons = _x select 7; _unitItems = _x select 8;
                _unitUniform = _x select 9; _unitUniformItems = _x select 10;
                _unitVest = _x select 11; _unitVestItems = _x select 12;
                _unitBackpack = _x select 13; _unitBackpackItems = _x select 14;
                _unitHeadgear = _x select 15; _unitGoggles = _x select 16;
                _unitFace = _x select 17;
                // Check if the unit has a crew, if so we know its a vehicle
                if (count _unitCrew > 0) then {
                        if (_unitPos select 2 >= 10) then {
                                _spawnUnit = createVehicle [_unitType,_unitPos, [], 0, "FLY"];
                                _spawnUnit setVelocity [50 * (sin _unitDir), 50 * (cos _unitDir), 0];
                        }
                        else { _spawnUnit = _unitType createVehicle _unitPos; };
                        // Create the entire crew
                        _crew = [];
                { _unit = _newGroup createUnit [_x, getPos _spawnUnit, [], 0, "NONE"]; _crew set [count _crew, _unit]; } forEach _unitCrew;
                // We assume that all vehicles have a driver, the first one of the crew
                        (_crew select 0) moveInDriver _spawnUnit;
                        // Count the turrets and move the men inside          
                _turrets = [configFile >> "CfgVehicles" >> _unitType >> "turrets"] call _fnc_returnVehicleTurrets;
                [_turrets, [], 1, _crew, _spawnUnit] call _fnc_moveInTurrets;          
                }
                // Otherwise its infantry
                else {
                        _spawnUnit = _newGroup createUnit [_unitType,_unitPos, [], 0, "NONE"];
                        removeAllWeapons _spawnUnit;
                        removeAllItems _spawnUnit;
                        removeAllAssignedItems _spawnUnit;
                        removeUniform _spawnUnit;
                        removeVest _spawnUnit;
                        removeBackpack _spawnUnit;
                        removeHeadgear _spawnUnit;
                        removeGoggles _spawnUnit;
                       
                        _spawnUnit forceAddUniform _unitUniform;
                        {_spawnUnit addItemToUniform _x} forEach _unitUniformItems;
               
                        _spawnUnit addVest _unitVest;
                        {_spawnUnit addItemToVest _x} forEach _unitVestItems;
                       
                        _spawnUnit addBackpack _unitBackpack;
                        {_spawnUnit addItemToBackpack _x} forEach _unitBackpackItems;
       
                        _spawnUnit addHeadgear _unitHeadgear;
                        _spawnUnit addGoggles _unitGoggles;
                        {_spawnUnit linkItem _x} forEach _unitItems;
                       
                        {_spawnUnit addWeapon _x} forEach _unitWeapons;
                        _spawnUnit selectWeapon (primaryWeapon _spawnUnit);
 
                        //_spawnUnit setFace _unitFace;
                };
                // Set all the things common to the spawned unit
                _spawnUnit triggerDynamicSimulation false; //this unit should not uncache other cached entities
                _spawnUnit setDir _unitDir;
                _spawnUnit setSkill _unitSkill;
                _spawnUnit setUnitRank _unitRank;
                //disable ACE unconcious
                [_spawnUnit]spawn{
                    _spawnUnit = _this select 0;
                    //waitUntil {(!isNil {_spawnUnit getVariable "ace_medical_enableUnconsciousnessAI"})};
                    _spawnUnit setvariable ["ace_medical_enableUnconsciousnessAI",0,false];
                };
                if (!isNil _unitName AND (_spawntype == "once" OR _spawntype == "repeated")) then {
                        diag_log _unitName;
                        _spawnUnit call compile format ["%1= _this; _this setVehicleVarName '%1'; PublicVariable '%1';",_unitName];
                };
        } forEach _unitArray;
		//_newGroup setVariable ["f_cacheExcl", true];
		//_newGroup setvariable ["f_cached", false];
		//[_newGroup,"f_fnc_gUncache", false,false] spawn BIS_fnc_MP;
		//_newGroup enableDynamicSimulation true; //disable dyanimc caching because unit prolly wont move cached
			
		//f3 assigngear
		if (_f3gear) then {
			units _newGroup execVM "f\assignGear\f_assignGear_AI.sqf";
		};

        private ["_i"]; _i = 0;
 
        //Let's return them their waypoints
        {
                //diag_log format ["All data : %1",_x];
                _wp = _newGroup addWaypoint [(_x select 0),0,_i];
                [_newGroup, _i] setWaypointHousePosition (_x select 1);
                [_newGroup, _i] setWaypointBehaviour (_x select 2);
                [_newGroup, _i] setWaypointCombatMode (_x select 3);
                [_newGroup, _i] setWaypointCompletionRadius (_x select 4);
                [_newGroup, _i] setWaypointDescription (_x select 5);
                [_newGroup, _i] setWaypointFormation (_x select 6);
                [_newGroup, _i] setWaypointScript (_x select 7);
                [_newGroup, _i] showWaypoint (_x select 8);
                [_newGroup, _i] setWaypointSpeed (_x select 9);
                [_newGroup, _i] setWaypointStatements (_x select 10);
                [_newGroup, _i] setWaypointTimeout (_x select 11);
                [_newGroup, _i] setWaypointType (_x select 12);
               
                _i = _i + 1;
               
        } forEach _waypointsArray;
 
        (vehicle (leader _newGroup)) call compile format ["%1",_initString];
       
        // hint format ["Created object: %1 - vehicleVarName: %2", (vehicle (leader _newGroup)), vehicleVarName (vehicle (leader _newGroup))]; sleep 1;
       
        // Run the cleanup function for this group
        if (_autoDeleteDist > 0) then {
            [_newGroup, _bodyRemove,_autoDeleteDist,(_waypointsArray select (count _waypointsArray - 1) select 0),_triggerObject] spawn _fnc_autoDeleteGroup;
        } else {
            [_newGroup, _bodyRemove] spawn _fnc_cleanGroup;
        };
        // Have to return the new group
        _newGroup;
};
 
// --------------  Waiting period  ------------------ //
while { !(_triggerObject getVariable "murk_spawn") } do { sleep _waitingPeriod; };
 
//hint "Triggered spawn!";
 
// ---------------  Spawn Modes  ------------------- //
// REPEAT MODE, i.e. basic respawn based on lives
if (_spawntype == "repeated") then {
        while { _spawnlives > 0 } do {
                _unitGroup = [_unitGroup,_side,_waypointsArray] call _fnc_spawnUnit;
                _spawnLives = _spawnLives - 1;
                _unitsGroup = units _unitGroup;
                while { ({alive _x} count _unitsGroup) > 0 } do { sleep 2; };
                sleep _spawndelay;
				if (!(_triggerObject getVariable "murk_spawn")) then { // murk spawn is set to false if units are autodeleted, dont spawn new units until trigger gets activated again
					_spawnLives = _spawnLives + 1;
					while { !(_triggerObject getVariable "murk_spawn") } do { sleep _waitingPeriod; };
				};
        };
};
 
// WAVE MODE, this is fairly simple, just sleep a while then respawn. Spawnlives in this case is number of waves
if (_spawntype == "wave") then {
        while { _spawnlives > 0 } do {
                _unitGroup = [_unitGroup,_side,_waypointsArray] call _fnc_spawnUnit;
                _spawnLives = _spawnLives - 1;
                sleep _spawndelay;
				if (!(_triggerObject getVariable "murk_spawn")) then { // murk spawn is set to false if units are autodeleted, dont spawn new units until trigger gets activated again
					_spawnLives = _spawnLives + 1;
					while { !(_triggerObject getVariable "murk_spawn") } do { sleep _waitingPeriod; };
				};
        };
};
 
// RESET MODE, sleep a while then set the variable to false (even if you set it like 50 times over). Spawn lives is used to tick how many times its possible to reset.
if (_spawntype == "reset") then {
        while { _spawnlives > 0 } do {
                _unitGroup = [_unitGroup,_side,_waypointsArray] call _fnc_spawnUnit;
                _spawnLives = _spawnLives - 1;
                sleep 15;
                _triggerObject setVariable ["murk_spawn",false,false];
                while { !(_triggerObject getVariable "murk_spawn") } do { sleep _waitingPeriod; };
        };
};
 
// ONCE MODE
if (_spawntype == "once") then { _unitGroup = [_unitGroup,_side,_waypointsArray] call _fnc_spawnUnit; };
 
};