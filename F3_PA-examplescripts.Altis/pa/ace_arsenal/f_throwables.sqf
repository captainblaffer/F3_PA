//f_items.sqf 
//
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//
// Stuff that can be thrown

params ["_group"];

private ["_gcontents"];
_gcontents = [];

switch _group do {
    case "chemlights": {
        _gcontents = [
             "ACE_Chemlight_HiOrange"
            ,"ACE_Chemlight_HiRed"
            ,"ACE_Chemlight_HiWhite"
            ,"ACE_Chemlight_HiYellow"
            ,"ACE_Chemlight_IR"
            ,"ACE_Chemlight_Orange"
            ,"ACE_Chemlight_Shield"
            ,"ACE_Chemlight_White"
            ,"Chemlight_blue"
            ,"Chemlight_green"
            ,"Chemlight_red"
            ,"Chemlight_yellow"

        ];
    };
    case "frags": {
        _gcontents = [
             "HandGrenade"
            //,"MiniGrenade"
            ,"rhs_mag_f1"
            //,"rhs_mag_m67"
            ,"rhs_mag_rgn"
            ,"rhs_mag_rgo"
        ];
    };
    case "handflares": {
        _gcontents = [
             "ACE_HandFlare_Green"
            ,"ACE_HandFlare_Red"
            ,"ACE_HandFlare_White"
            ,"ACE_HandFlare_Yellow"
        ];
    };
    case "incendiary": {
        _gcontents = [
             "ACE_M14"
            ,"rhs_mag_an_m14_th3"
        ];
    };
    case "infrared": {
        _gcontents = [
             "B_IR_Grenade"
            ,"ACE_IR_Strobe_Item"
        ];
    };
    case "smoke": {
        _gcontents = [
             "rhs_mag_an_mh8c"
            ,"rhs_mag_m18_green"
            ,"rhs_mag_m18_purple"
            ,"rhs_mag_m18_red"
            ,"rhs_mag_m18_yellow"
            ,"SmokeShellBlue"
            //,"SmokeShellGreen"
            ,"SmokeShellOrange"
            ,"SmokeShellPurple"
            //,"SmokeShellRed"
            //,"SmokeShellYellow"
            //,"UK3CB_BAF_SmokeShell"
            //,"UK3CB_BAF_SmokeShellBlue"
            //,"UK3CB_BAF_SmokeShellGreen"
            //,"UK3CB_BAF_SmokeShellOrange"
            //,"UK3CB_BAF_SmokeShellPurple"
            //,"UK3CB_BAF_SmokeShellRed"
            //,"UK3CB_BAF_SmokeShellYellow"
        ];
    };
    default {
    	hint format ["Throwables group %1 not known", _group];
    };
};

_gcontents;
