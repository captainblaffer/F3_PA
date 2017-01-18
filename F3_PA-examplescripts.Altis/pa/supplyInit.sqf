/*
			TUTORIAL
	https://www.youtube.com/watch?v=YZ4QC96Kqe0
	
			FOR RADIO TRIGGERS
	[[["","CLASSNAME OF BOX","FNC NAME"],"supply\supply.sqf"], "BIS_fnc_execVM", true] call BIS_fnc_MP;

			TRIGGER WITH ADDACTION
	this addaction ["Supply Drop", {[[["","B_CargoNet_01_ammo_F","FncSupplyCargo1"],"supply\supply.sqf"], "BIS_fnc_execVM", true] call BIS_fnc_MP;}];
	
			CLASSNAMES
	https://community.bistudio.com/wiki/Arma_3_Assets
*/

FncSupplyLight = { FncBoxLight = _this addAction ["Light Off",{_supplyLight = nearestObject [player, "Chemlight_green"];
												deleteVehicle _supplyLight; _this select 0 removeAction FncBoxLight;}];}; 

FncSupplyVAS = {_this addAction["<t color='#ff11ff'>Virtual Ammobox</t>", "VAS\open.sqf"];};

//:::::::::::::|SNIPER GEAR|::::::::::::::::				
FncSupplyCargo1 = { 
					_this addWeaponCargoGlobal ["hgun_Pistol_Signal_F",3];
					_this addMagazineCargoGlobal ["6Rnd_RedSignal_F", 10];
					_this addWeaponCargoGlobal ["hgun_Pistol_heavy_01_snds_F",3];
					_this addMagazineCargoGlobal ["11Rnd_45ACP_Mag", 10];
					_this addWeaponCargoGlobal ["srifle_GM6_LRPS_F",3];
					_this addMagazineCargoGlobal ["5Rnd_127x108_APDS_Mag", 10];
					_this addItemCargoGlobal ["V_PlateCarrierGL_rgr", 10];
					_this addItemCargoGlobal ["U_I_GhillieSuit", 10];
					_this addBackpackCargoGlobal ["B_AssaultPack_ocamo", 10];
					};

FncSupplyCargo2 = { 
					_this addweaponcargo ["hgun_Pistol_heavy_02_Yorris_F",10];
					_this addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 10];
					};

FncSupplyCargo3 = { 
					_this addweaponcargo ["srifle_EBR_F",10];
					};

FncSupplyCargo4 = { 
					["crate_large",_this,"blu_f"] call f_fnc_assignGear
					};
