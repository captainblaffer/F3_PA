//f_launchers.sqf 
//
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//


params ["_group"];

private ["_gcontents"];
_gcontents = [];

switch _group do {
    case "FIM92"; 
    case "Stinger": {
        _gcontents = [
             "rhs_weap_fim92"
            ,"rhs_fim92_mag"
        ];
    };
    case "m136"; 
    case "at4";
    case "at-4": {
        _gcontents = [
             "rhs_weap_m136"
            ,"rhs_weap_m136_hedp"
            ,"rhs_weap_m136_hp"
        ];
    };
    case "m72a7": {
        _gcontents = [
             "rhs_weap_m72a7"
            ,"rhsusf_acc_anpeq15side"
        ];
    };

    case "maaws": {
        _gcontents = [
            // There are two sources for the MAAWS: RHS and the Tanks DLC
            // It's recommended to comment out one of the two (and its
            // accessories and ammo) to avoid confusion.
             "rhs_weap_maaws" 
            // Tanks DLC
            //,"launch_MRAWS_green_rail_F"
            //,"launch_MRAWS_olive_rail_F"
            //,"launch_MRAWS_sand_rail_F"
            //,"launch_MRAWS_green_F"
            //,"launch_MRAWS_olive_F"
            //,"launch_MRAWS_sand_F"

            // Optics and accessories
            // RHS
            ,"rhs_optic_maaws"   // Only useful for the RHS MAAWS
            // Tanks DLC
            //,"ace_acc_pointer_green"
            //,"ace_acc_pointer_it"
            //,"acc_flashlight"

            // Ammo
            // RHS version
            ,"rhs_mag_maaws_HE"
            ,"rhs_mag_maaws_HEDP"
            ,"rhs_mag_maaws_HEAT"
            // Tanks DLC
            //,"MRAWS_HE_F"
            //,"MRAWS_HEAT_F"
        ];
    };
    case "smaw": {
        _gcontents = [
             "rhs_weap_smaw"
            ,"rhs_weap_smaw_green"
            // Optics and accessories
            ,"rhs_weap_optic_smaw"
            // While these also work, their use is not particulary realistic
            ,"rhsusf_acc_acog"
            ,"rhsusf_acc_acog2"
            ,"rhsusf_acc_acog3"
            ,"rhsusf_acc_acog_usmc"
            ,"rhsusf_acc_acog2_usmc"
            ,"rhsusf_acc_acog3_usmc"
            ,"rhsusf_acc_eotech_552"
            ,"optic_holosight"
            ,"ace_acc_pointer_green"
            ,"ace_acc_pointer_it"
            ,"acc_flashlight"
            // Ammo
            ,"rhs_mag_smaw_HEDP"
            ,"rhs_mag_smaw_HEAA"
        ];
    };
    default {
    	hint format ["Launcher group %1 not known", _group];
    };
};

_gcontents;
