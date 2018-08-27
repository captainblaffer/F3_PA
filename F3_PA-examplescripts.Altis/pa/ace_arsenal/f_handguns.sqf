//f_handguns.sqf 
//
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//


params ["_group"];

private ["_gcontents"];
_gcontents = [];
switch _group do {
    case "m1911a1": {
        _gcontents = [
             "rhsusf_weap_m1911a1"
            ,"rhsusf_mag_7x45acp_MHP"
        ];
    };
    case "fnx45": {
        _gcontents = [
             "hgun_Pistol_heavy_01_F"
            ,"11Rnd_45ACP_Mag"
            // Optics for handguns go with their base guns
            ,"hlc_optic_docterv"
            ,"optic_mrd"
            ,"hlc_optic_romeov"
            // Accessories
            ,"acc_flashlight_pistol"
            ,"hlc_acc_dbalpl"
            ,"hlc_acc_dbalpl_fl"
            ,"hlc_acc_tlr1"
            // Flash hider
            ,"ace_muzzle_mzls_smg_01"
            // Suppressors
            //,"hlc_muzzle_evo40"
            //,"hlc_muzzle_octane45"
            //,"muzzle_snds_acp"
        ];
    };
    default {
    	hint format ["Handgun group %1 not known", _group];
    };
};

_gcontents;
