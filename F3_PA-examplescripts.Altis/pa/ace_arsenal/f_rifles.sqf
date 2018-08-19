//f_rifles.sqf 
//
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//
// This file defines Weapon Groups, i.e. variants of one weapon. For example,
// the group "m4a1_block_2" will contain all variants of the M4A1 Block II,
// with various rails and camos.

params ["_group"];

private ["_gcontents"];
_gcontents = [];

switch _group do {
    case "ebr": {
        _gcontents = [
             "rhs_weap_m14ebrri"
            ,"srifle_EBR_F"
            // Ammo
            // For rhs_weap_m14ebrri and srifle_ebr_f
            ,"rhsusf_20Rnd_762x51_m118_special_Mag"
            ,"rhsusf_20Rnd_762x51_m62_Mag"
            ,"rhsusf_20Rnd_762x51_m993_Mag"
            // Only for srfile_ebr_f
            ,"20Rnd_762x51_Mag"
            ,"ACE_20Rnd_762x51_M118LR_Mag"
            ,"ACE_20Rnd_762x51_M993_AP_Mag"
            ,"ACE_20Rnd_762x51_Mag_SD"
            ,"ACE_20Rnd_762x51_Mag_Tracer"
            ,"ACE_20Rnd_762x51_Mag_Tracer_Dim"
            ,"ACE_20Rnd_762x51_Mk316_Mod_0_Mag"
            ,"ACE_20Rnd_762x51_Mk319_Mod_0_Mag"
            ];
    };
    case "m4a1_block2": {
        _gcontents = [
             "rhs_weap_m4a1_blockII"
            ,"rhs_weap_m4a1_blockII_bk"
            ,"rhs_weap_m4a1_blockII_d"
            ,"rhs_weap_m4a1_blockII_KAC"
            ,"rhs_weap_m4a1_blockII_KAC_bk"
            ,"rhs_weap_m4a1_blockII_KAC_d"
            ,"rhs_weap_m4a1_blockII_KAC_wd"
            ,"rhs_weap_m4a1_blockII_M203"
            ,"rhs_weap_m4a1_blockII_M203_bk"
            ,"rhs_weap_m4a1_blockII_M203_d"
            ,"rhs_weap_m4a1_blockII_M203_wd"
            ,"rhs_weap_m4a1_blockII_wd"
            // Ammo
            ,"rhs_mag_30Rnd_556x45_M855_Stanag"
            ,"rhs_mag_30Rnd_556x45_Mk262_Stanag"
            ,"rhs_mag_30Rnd_556x45_Mk318_Stanag"
            // Grenades for M203
            ,"UGL_FlareGreen_F"
            ,"UGL_FlareRed_F"
            ,"UGL_FlareWhite_F"
            ,"UGL_FlareYellow_F"
            ,"UGL_FlareCIR_F"
            ,"1Rnd_SmokeBlue_Grenade_shell"
            ,"1Rnd_SmokeGreen_Grenade_shell"
            ,"1Rnd_SmokeOrange_Grenade_shell"
            ,"1Rnd_SmokePurple_Grenade_shell"
            ,"1Rnd_SmokeRed_Grenade_shell"
            ,"1Rnd_SmokeWhite_Grenade_shell"
            ,"1Rnd_SmokeYellow_Grenade_shell"
            ,"1Rnd_HE_Grenade_shell"
            // Flash hiders
            ,"rhsusf_acc_sf3p556"
            ,"rhsusf_acc_sfmb556"
            ,"ace_muzzle_mzls_l"
            ];
    };
    case "mk18": {
        _gcontents = [
             "rhs_weap_mk18"
            ,"rhs_weap_mk18_bk"
            ,"rhs_weap_mk18_d"
            ,"rhs_weap_mk18_KAC"
            ,"rhs_weap_mk18_KAC_bk"
            ,"rhs_weap_mk18_KAC_d"
            ,"rhs_weap_mk18_KAC_wd"
            ,"rhs_weap_mk18_m320"
            ,"rhs_weap_mk18_wd"
            // Ammo
            ,"rhs_mag_30Rnd_556x45_M855_Stanag"
            ,"rhs_mag_30Rnd_556x45_Mk262_Stanag"
            ,"rhs_mag_30Rnd_556x45_Mk318_Stanag"
            // Grenades for M320
            ,"UGL_FlareGreen_F"
            ,"UGL_FlareRed_F"
            ,"UGL_FlareWhite_F"
            ,"UGL_FlareYellow_F"
            ,"UGL_FlareCIR_F"
            ,"1Rnd_SmokeBlue_Grenade_shell"
            ,"1Rnd_SmokeGreen_Grenade_shell"
            ,"1Rnd_SmokeOrange_Grenade_shell"
            ,"1Rnd_SmokePurple_Grenade_shell"
            ,"1Rnd_SmokeRed_Grenade_shell"
            ,"1Rnd_SmokeWhite_Grenade_shell"
            ,"1Rnd_SmokeYellow_Grenade_shell"
            ,"1Rnd_HE_Grenade_shell"
            // Suppressors
            //,"rhsusf_acc_nt4_black"
            //,"rhsusf_acc_nt4_tan"
            //,"rhsusf_acc_rotex5_grey"
            //,"rhsusf_acc_rotex5_tan"
            // Flash hiders
            ,"rhsusf_acc_sf3p556"
            ,"rhsusf_acc_sfmb556"
            ];
    };
    case "sr25";
    case "mk11": {
        _gcontents = [
             "rhs_weap_sr25"
            ,"rhs_weap_sr25_d"
            ,"rhs_weap_sr25_ec"
            ,"rhs_weap_sr25_ec_d"
            ,"rhs_weap_sr25_ec_wd"
            ,"rhs_weap_sr25_sup_marsoc"
            ,"rhs_weap_sr25_sup_usmc"
            ,"rhs_weap_sr25_usmc"
            ,"rhs_weap_sr25_wd"
            // Ammo
            ,"rhsusf_20Rnd_762x51_m118_special_Mag"
            ,"rhsusf_20Rnd_762x51_m62_Mag"
            ,"rhsusf_20Rnd_762x51_m993_Mag"
            // Suppressors
            //,"rhsusf_acc_sr25s"
            //,"rhsusf_acc_sr25s_d"
            //,"rhsusf_acc_sr25s_wd"
            ];
    };

    case "m24": {
        _gcontents = [
             "rhs_weap_m24sws"
            ,"rhs_weap_m24sws_blk"
            ,"rhs_weap_m24sws_ghillie"
            // Ammo
            ,"rhsusf_5Rnd_762x51_m118_special_Mag"
            ,"rhsusf_5Rnd_762x51_m62_Mag"
            ,"rhsusf_5Rnd_762x51_m993_Mag"
            ];
    };
    case "m590": {
        _gcontents = [
              "rhs_weap_M590_5RD"
             ,"rhs_weap_M590_8RD"
             // Ammo
             ,"rhs_8Rnd_00buck"
             // OP ,"rhs_8Rnd_Frag"
             // OP ,"rhs_8Rnd_HE"
             ,"rhs_8Rnd_Slug"
            ];
    };
    case "mk46"; 
    case "mk46mod0": {
        _gcontents = [
             "hlc_lmg_mk46"
             // Ammo
            ,"200Rnd_556x45_Box_F"
            ,"200Rnd_556x45_Box_Red_F"
            ,"200Rnd_556x45_Box_Tracer_F"
            ,"200Rnd_556x45_Box_Tracer_Red_F"
            ,"rhsusf_100Rnd_556x45_M200_soft_pouch"
            ,"rhsusf_100Rnd_556x45_soft_pouch"
            ,"rhsusf_200Rnd_556x45_soft_pouch"
            ,"hlc_200rnd_556x45_B_SAW"
            ,"hlc_200rnd_556x45_Mdim_SAW"
            ,"hlc_200rnd_556x45_M_SAW"
            ,"hlc_200rnd_556x45_T_SAW"
            ];
    };
    case "mk46m1";
    case "mk46mod1": {
        _gcontents = [
             "hlc_lmg_mk46mod1"
             // Ammo
            ,"200Rnd_556x45_Box_F"
            ,"200Rnd_556x45_Box_Red_F"
            ,"200Rnd_556x45_Box_Tracer_F"
            ,"200Rnd_556x45_Box_Tracer_Red_F"
            ,"rhsusf_100Rnd_556x45_M200_soft_pouch"
            ,"rhsusf_100Rnd_556x45_soft_pouch"
            ,"rhsusf_200Rnd_556x45_soft_pouch"
            ,"hlc_200rnd_556x45_B_SAW"
            ,"hlc_200rnd_556x45_Mdim_SAW"
            ,"hlc_200rnd_556x45_M_SAW"
            ,"hlc_200rnd_556x45_T_SAW"
            ];
    };
    default {
    	hint format ["Weapon group %1 not known", _group];
    };
};

_gcontents;
