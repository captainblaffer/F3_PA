// klausman's simplified assignGear - NATO Faction
// List of commonly-used types of units:
//  co	- commander
//  dc 	- deputy commander / squad leader
//  m 	- medic
//  ftl	- fire team leader
//  ar 	- automatic rifleman
//  aar	- assistant automatic rifleman
//  rat	- rifleman (AT)
//  dm	- designated marksman
//  mmgg	- medium mg gunner
//  mmgag	- medium mg assistant
//  matg	- medium AT gunner
//  matag	- medium AT assistant
//  hmgg	- heavy mg gunner (deployable)
//  hmgag	- heavy mg assistant (deployable)
//  hatg	- heavy AT gunner (deployable)
//  hatag	- heavy AT assistant (deployable)
//  mtrg	- mortar gunner (deployable)
//  mtrag	- mortar assistant (deployable)
//  msamg	- medium SAM gunner
//  msamag	- medium SAM assistant gunner
//  hsamg	- heavy SAM gunner (deployable)
//  hsamag	- heavy SAM assistant gunner (deployable)
//  sn	- sniper
//  sp	- spotter (for sniper)
//  vc	- vehicle commander
//  vg	- vehicle gunner
//  vd	- vehicle driver (repair)
//  pp	- air vehicle pilot / co-pilot
//  pcc	- air vehicle co-pilot (repair) / crew chief (repair)
//  pc	- air vehicle crewman
//  eng	- engineer (demo)
//  engm	- engineer (mines)
//  uav	- UAV operator
//  div	- diver
//  r 	- rifleman
//  car	- carabineer
//  smg	- submachinegunner
//  gren	- grenadier

// NOTE: Those strings are abritrary. That is, if you want to have any
// random name for unit types, you can make them up. E.g., if you have
// a placed unit with this in its init function:
//
// ["herpderp",this] call f_fnc_assignGear;
//
// and in the switch statement below, a section like this:
//
// case "herpderp": {
//    _unit setUnitLoadout [[...stuff...]];
// };
//
// Then the unit will get the "stuff" loadout. This way, you can have
// multiple different types of Automatic Rifleman, for example.

// Define a few shorthand variables from parameters
private _typeofUnit = toLower (_this select 0);	// "co", "ar" etc.
private _unit = _this select 1;			// E.g. B A 1-3 (bluefor, Alpha 1-3)

// Remove everything
removeBackpack _unit;
removeAllWeapons _unit;
removeAllItemsWithMagazines _unit;
removeAllAssignedItems _unit;

// Depending on _typeofUnit, give them a loadout exported from the ACE Arsenal
switch (_typeofUnit) do
{
  // Commanding Officer
  case "co": {
    _unit setUnitLoadout [["hlc_rifle_G36TAC","","","RKSL_optic_EOT552",["hlc_30rnd_556x45_EPR_G36",30],[],""],[],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",15],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_30rnd_556x45_EPR_G36",10,30],["hlc_12Rnd_357SIG_B_P226",2,12]]],["tfw_ilbe_a_wd",[["ACE_EntrenchingTool",1],["ACE_MapTools",1],["ACE_microDAGR",1],["rhs_mag_an_m8hc",4,1],["UK3CB_BAF_SmokeShellRed",4,1],["UK3CB_BAF_SmokeShellGreen",4,1],["HandGrenade",4,1],["Laserbatteries",1,1]]],"MNP_Helmet_Germany","G_Aviator",["Laserdesignator","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];
  };

  // 2IC and Squad leaders
  case "dc": {
    _unit setUnitLoadout [["hlc_rifle_G36TAC","","","RKSL_optic_EOT552",["hlc_30rnd_556x45_EPR_G36",30],[],""],[],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",15],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_30rnd_556x45_EPR_G36",10,30],["hlc_12Rnd_357SIG_B_P226",2,12]]],["tfw_ilbe_a_wd",[["ACE_EntrenchingTool",1],["ACE_MapTools",1],["ACE_microDAGR",1],["rhs_mag_an_m8hc",4,1],["UK3CB_BAF_SmokeShellRed",4,1],["UK3CB_BAF_SmokeShellGreen",4,1],["HandGrenade",4,1],["Laserbatteries",1,1]]],"MNP_Helmet_Germany","",["Laserdesignator","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];    
  };

  // Medic
  case "m": {
    _unit setUnitLoadout [["hlc_rifle_g36KTac","","","RKSL_optic_EOT552",["hlc_30rnd_556x45_EPR_G36",30],[],""],[],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",20],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["ACE_fieldDressing",10],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_30rnd_556x45_EPR_G36",8,30]]],["TRYK_B_Carryall_wood",[["ACE_EntrenchingTool",1],["ACE_fieldDressing",20],["ACE_epinephrine",10],["ACE_bloodIV_500",15],["rhs_mag_an_m8hc",10,1],["UK3CB_BAF_SmokeShellRed",4,1],["UK3CB_BAF_SmokeShellGreen",4,1],["HandGrenade",6,1],["Laserbatteries",1,1]]],"MNP_Helmet_Germany","",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];    
  };

  // Fire Team Leader
  case "ftl": {
    _unit setUnitLoadout [["hlc_rifle_g36KTac","","","RKSL_optic_EOT552",["hlc_30rnd_556x45_EPR_G36",30],[],""],[],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",20],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["ACE_fieldDressing",10],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_30rnd_556x45_EPR_G36",8,30]]],["TRYK_B_Carryall_wood",[["ACE_EntrenchingTool",1],["ACE_fieldDressing",20],["ACE_epinephrine",10],["ACE_bloodIV_500",15],["rhs_mag_an_m8hc",10,1],["UK3CB_BAF_SmokeShellRed",4,1],["UK3CB_BAF_SmokeShellGreen",4,1],["HandGrenade",6,1],["Laserbatteries",1,1]]],"MNP_Helmet_Germany","",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];
  };

  // Automatic Rifleman
  case "ar": {
    _unit setUnitLoadout [["hlc_lmg_minimi_railed","","","rhsusf_acc_ELCAN",["rhsusf_200Rnd_556x45_mixed_soft_pouch",200],[],""],[],["hlc_pistol_P229R_357Combat","","","HLC_Optic228_Romeo1_RX",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",15],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["Laserbatteries",1,1]]],["MNP_Vest_Germany_2",[["SmokeShellGreen",1,1],["Chemlight_green",1,1],["rhsusf_200Rnd_556x45_mixed_soft_pouch",2,200]]],["TRYK_B_Carryall_wood",[["ACE_EntrenchingTool",1],["rhs_mag_an_m8hc",2,1],["UK3CB_BAF_SmokeShellGreen",2,1],["HandGrenade",3,1],["UK3CB_BAF_SmokeShellRed",2,1],["rhsusf_200Rnd_556x45_mixed_soft_pouch",4,200]]],"MNP_Helmet_Germany","",["Laserdesignator","","","",["Laserbatteries",1],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];  
  };

  // Assistant Automatic Rifleman
  case "aar": {
    _unit setUnitLoadout [["hlc_rifle_G36TAC","","","RKSL_optic_EOT552",["hlc_30rnd_556x45_EPR_G36",30],[],""],[],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",15],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_30rnd_556x45_EPR_G36",10,30],["hlc_12Rnd_357SIG_B_P226",2,12]]],["TRYK_B_Carryall_wood",[["ACE_EntrenchingTool",1],["rhs_mag_an_m8hc",4,1],["UK3CB_BAF_SmokeShellRed",4,1],["UK3CB_BAF_SmokeShellGreen",4,1],["HandGrenade",6,1],["Laserbatteries",1,1],["hlc_30rnd_556x45_EPR_G36",2,30],["rhsusf_200Rnd_556x45_mixed_soft_pouch",3,200]]],"MNP_Helmet_Germany","",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];  
  };

  // Rifleman (AT)
  case "rat": {
    _unit setUnitLoadout [["hlc_rifle_G36TAC","","","RKSL_optic_EOT552",["hlc_30rnd_556x45_EPR_G36",30],[],""],["launch_MRAWS_olive_F","","","",["MRAWS_HEAT_F",1],[],""],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",15],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_30rnd_556x45_EPR_G36",8,30],["hlc_12Rnd_357SIG_B_P226",2,12]]],["TRYK_B_Carryall_wood",[["ACE_EntrenchingTool",1],["rhs_mag_an_m8hc",4,1],["HandGrenade",6,1],["Laserbatteries",1,1],["MRAWS_HEAT_F",3,1]]],"MNP_Helmet_Germany","",[],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];  
  };

  // Designated Marksman
  case "dm": {
    _unit setUnitLoadout [["hlc_rifle_g3sg1ris","","","RKSL_optic_LDS",["ACE_20Rnd_762x51_Mk319_Mod_0_Mag",20],[],""],[],["hlc_pistol_P229R_357Combat","","","",["hlc_10Rnd_357SIG_B_P229",10],[],""],["MNP_CombatUniform_Germany",[["ACE_fieldDressing",15],["ACE_morphine",10],["SmokeShell",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12]]],["MNP_Vest_Germany_2",[["SmokeShellGreen",1,1],["Chemlight_green",1,1],["hlc_12Rnd_357SIG_B_P226",2,12],["ACE_10Rnd_762x51_Mk319_Mod_0_Mag",10,10]]],["TRYK_B_Carryall_wood",[["ACE_EntrenchingTool",1],["rhs_mag_an_m8hc",4,1],["UK3CB_BAF_SmokeShellRed",4,1],["UK3CB_BAF_SmokeShellGreen",4,1],["HandGrenade",6,1],["Laserbatteries",1,1],["ACE_20Rnd_762x51_M993_AP_Mag",3,20]]],"MNP_Helmet_Germany","",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];
  };

  // This block is executed if the unit assignGear was called on does
  // not have a known type. So do nothing except warn the MM about this
  default {
    // the if (true) is necessary due to the way exitWith works
    if (true) exitwith {
      player globalchat format ["DEBUG (f\assignGear_simple\f_assignGear_nato.sqf): Unit = %1. Gear template %2 does not exist.", _unit, _typeofunit]
    };
  };
// End of loadouts
};

// Make sure the primary weapon is in the unit's hands.
_unit selectweapon primaryweapon _unit;
