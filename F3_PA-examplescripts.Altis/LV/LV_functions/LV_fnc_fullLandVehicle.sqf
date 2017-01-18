//ARMA3Alpha function LV_fnc_fullLandVehicle v1.2 - by SPUn / lostvar
//Spawns random vehicle full of random units and returns driver 
private ["_unitType","_MenArray","_types","_BLUhq","_BLUgrp","_veh","_grp","_OPFhq","_OPFgrp","_INDhq","_INDgrp","_roads","_radius","_pos1","_man1","_man","_i","_pos","_side","_BLUveh","_OPFveh","_INDveh","_veh1","_vehSpots","_roadFound","_vehicle","_vCrew","_unit","_wp","_allUnitsArray","_crew","_driver"];
_pos = _this select 0;
_side = _this select 1;
_types =  _this select 2;

/*
switch(_types)do{
	case 0:{
		//_BLUveh = ["B_MRAP_01_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_Quadbike_01_F","B_Truck_01_transport_F","B_Truck_01_covered_F","B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_AA_F","B_APC_Wheeled_01_cannon_F","B_MBT_01_cannon_F","B_MBT_01_arty_F","B_MBT_01_mlrs_F"];
		_OPFveh = ["B_G_Offroad_01_armed_F"];
		//_INDveh = ["I_MRAP_03_F","I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_Quadbike_01_F","I_Truck_02_transport_F","I_Truck_02_covered_F","I_APC_Wheeled_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_APC_Wheeled_03_cannon_F"];
	};
	case 1:{
		_OPFveh = ["O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","O_MRAP_02_hmg_F"];
		};
	case 2:{
		_OPFveh = ["O_MBT_02_arty_F","O_APC_Tracked_02_AA_F"];
		};
	case 3:{
		_OPFveh = ["O_Truck_02_transport_F","O_Truck_02_covered_F","I_Truck_02_transport_F","I_Truck_02_covered_F"];
};
};*/

switch(_types)do{
	case 0:{
		//_BLUveh = ["B_MRAP_01_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_Quadbike_01_F","B_Truck_01_transport_F","B_Truck_01_covered_F","B_APC_Tracked_01_rcws_F","B_APC_Tracked_01_AA_F","B_APC_Wheeled_01_cannon_F","B_MBT_01_cannon_F","B_MBT_01_arty_F","B_MBT_01_mlrs_F"];
		_OPFveh = ["LandRover_MG_TK_EP1","BAF_Offroad_D_HMG"];
		//_INDveh = ["I_MRAP_03_F","I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_Quadbike_01_F","I_Truck_02_transport_F","I_Truck_02_covered_F","I_APC_Wheeled_03_cannon_F","I_APC_Wheeled_03_cannon_F","I_APC_Wheeled_03_cannon_F"];
	};
	case 1:{
		_OPFveh = ["rhs_btr60_msv","rhs_btr70_msv","rhs_btr80_msv","rhs_btr80a_msv"];
	};
	case 2:{
		_OPFveh = ["rhs_bmp1_msv","rhs_bmp2_msv"];
	};
	case 3:{
		_OPFveh = ["O_Truck_02_transport_F","RHS_Ural_Open_MSV_01","RHS_Ural_Open_Civ_01","RHS_Ural_Open_Civ_02","RHS_Civ_Truck_02_transport_F"];
};
};

_veh = [];

switch(_side)do{
	case 0:{
		//_BLUhq = createCenter west;
		//_BLUgrp = createGroup west;
		_veh = _OPFveh;
		//_grp = _BLUgrp;
	};
	case 1:{
		//_OPFhq = createCenter east;
		//_OPFgrp = createGroup east;
		_veh = _OPFveh;
		//_grp = _OPFgrp;
	};
	case 2:{
		//_INDhq = createCenter resistance;
		//_INDgrp = createGroup resistance;
		_veh = _OPFveh;
		//_grp = _INDgrp;
	};
};


_veh1 = _veh select (floor(random(count _veh)));
_vehSpots = getNumber (configFile >> "CfgVehicles" >> _veh1 >> "transportSoldier");

_radius = 40;
_roads = [];
while{(count _roads) == 0}do{
	_roads = _pos nearRoads _radius;
	_radius = _radius + 10;
};
if(((_roads select 0) distance _pos)<200)then{
	_pos = getPos(_roads select 0);
	_radius = 25;
	_pos1 = [_pos,0,_radius,5,0,1,0] call BIS_fnc_findSafePos;
	while {_pos distance _pos1 > 300} do {
		_radius = _radius + 20;
		_pos1 = [_pos,0,_radius,5,0,1,0] call BIS_fnc_findSafePos;
		if (_radius > 250) exitwith {_pos = _this select 0};
	};
}else{
	_radius = 100;
	_pos1 = [_pos,0,_radius,5,0,1,0] call BIS_fnc_findSafePos;
	while {_pos distance _pos1 > 300} do {
		_radius = _radius + 20;
		_pos1 = [_pos,0,_radius,5,0,1,0] call BIS_fnc_findSafePos;
		if (_radius > 250) exitwith {_pos = _this select 0};
	};
};
_pos = [_pos1 select 0, _pos1 select 1, 0];

sleep 0.5;

_vehicle = createVehicle [_veh1, _pos, [], 0, "NONE"];
_vehicle setPos _pos;

_vehicle allowDamage false;
sleep 2;
_vehicle setpos (getpos _vehicle vectoradd [0,0,0.3]);
if(((vectorUp _vehicle) select 2) != 0)then{ _vehicle setvectorup [0,0,0]; };
sleep 2;
_vehicle allowDamage true;


switch(_side)do{
	case 0:{
		//_BLUhq = createCenter west;
		_BLUgrp = createGroup west;
		_grp = _BLUgrp;
	};
	case 1:{
		//_OPFhq = createCenter east;
		if(isNil("_OPFgrp"))then{_OPFgrp = createGroup east;}else{_OPFgrp = _OPFgrp;};
		_grp = _OPFgrp;
	};
	case 2:{
		//_INDhq = createCenter resistance;
		_INDgrp = createGroup resistance;
		_grp = _INDgrp;
	};
};

		_unit = _grp createUnit ["O_G_Soldier_lite_F", _pos, [], 0, "NONE"];
		["car",_unit] call f_fnc_assignGear;
		
		_unit moveInAny _vehicle;

switch(_types)do{
	case 0:{
		_unit = _grp createUnit ["O_G_Soldier_lite_F", _pos, [], 0, "NONE"];
		["car",_unit] call f_fnc_assignGear;
		
		_unit moveInGunner _vehicle;
	};
	case 1:{
		_unit = _grp createUnit ["O_G_Soldier_lite_F", _pos, [], 0, "NONE"];
		["car",_unit] call f_fnc_assignGear;
		
		_unit moveInCommander _vehicle;

		_unit = _grp createUnit ["O_G_Soldier_lite_F", _pos, [], 0, "NONE"];
		["car",_unit] call f_fnc_assignGear;
		
		_unit moveInAny _vehicle;
	};
	case 2:{
		_unit = _grp createUnit ["O_G_Soldier_lite_F", _pos, [], 0, "NONE"];
		["car",_unit] call f_fnc_assignGear;
		
		_unit moveInCommander _vehicle;

		_unit = _grp createUnit ["O_G_Soldier_lite_F", _pos, [], 0, "NONE"];
		["car",_unit] call f_fnc_assignGear;
		
		_unit moveInAny _vehicle;
	};
	case 3:{
		//_geararray = ["ftl","r","rat","ar","gren","aar","matg","ar","sn","mmgg","m"];
		_MenArray = ["O_G_Soldier_A_F","O_G_soldier_AR_F","O_G_medic_F","O_G_Soldier_GL_F","O_G_soldier_M_F","O_G_soldier_LAT_F","O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_lite_F","O_G_Soldier_TL_F","O_G_Soldier_TL_F","O_G_soldier_LAT_F"];

		for "_i" from 1 to ((random(6)) + 6) do {
			//_theGear = _geararray call BIS_fnc_selectRandom;
			_unitType = _menArray select (floor(random(count _menArray)));
			_unit = _grp createUnit [_unitType, _pos, [], 0, "NONE"];
			_unit execVM "f\assignGear\f_assignGear_AI.sqf";
			//[_theGear,_unit] call f_fnc_assignGear;
			
			_unit moveInAny _vehicle;
		};
	};
};

/*
if (_types>0) then {
_unit = _grp createUnit ["O_Soldier_lite_F", _pos, [], 0, "NONE"];
["car",_unit] call f_fnc_assignGear;
_unit moveInCommander _vehicle;

_unit = _grp createUnit ["O_Soldier_lite_F", _pos, [], 0, "NONE"];
["car",_unit] call f_fnc_assignGear;
_unit moveInAny _vehicle;

_unit = _grp createUnit ["O_Soldier_lite_F", _pos, [], 0, "NONE"];
["car",_unit] call f_fnc_assignGear;
_unit moveInAny _vehicle;
} else {
_unit = _grp createUnit ["O_Soldier_lite_F", _pos, [], 0, "NONE"];
["car",_unit] call f_fnc_assignGear;
_unit moveInGunner _vehicle;

_unit = _grp createUnit ["O_Soldier_lite_F", _pos, [], 0, "NONE"];
["car",_unit] call f_fnc_assignGear;
_unit moveInAny _vehicle;
};
if (_types==3) then {
_geararray = ["ftl","r","rat","ar","gren","aar","rat","ar","sn","mmgg","m"];
for "_i" from 1 to (random (8)) do {
	_theGear = _geararray call BIS_fnc_selectRandom;
	_unit = _grp createUnit ["O_Soldier_lite_F", _pos, [], 0, "NONE"];
	[_theGear,_unit] call f_fnc_assignGear;
	_unit moveInAny _vehicle;
};
};*/
_grp setVariable ["f_cacheExcl", true];

//hint format ["-1 %1",(units _grp)];
sleep 2;

//_vCrew = [_vehicle, _grp] call BIS_fnc_spawnCrew;
//_allUnitsArray set [(count _allUnitsArray), _vehicle];
_crew = crew _vehicle;
//hint format ["-2 %1",_crew ];

/*if(_vehSpots > 0)then{
	_i = 1; 
	for "_i" from 1 to _vehSpots do {
		_man1 = getText (configFile >> "CfgVehicles" >> _veh1 >> "crew");
		_man = _grp createUnit [_man1, _pos, [], 0, "NONE"];
		_man moveInCargo _vehicle;
		sleep 0.3;
	};
};*/

_driver = driver _vehicle;
_driver