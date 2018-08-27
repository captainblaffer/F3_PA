//f_items.sqf 
//
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//
// Various items for meidcs, engineers and everybody else

params ["_group"];

private ["_gcontents"];
_gcontents = [];

switch _group do {
    case "backpacks": {
        _gcontents = [
             "UK3CB_BAF_B_Bergen_MTP_Rifleman_L_A"
            ,"UK3CB_BAF_B_Bergen_MTP_Rifleman_L_B"
            ,"ACE_TacticalLadder_Pack"
        ];
    };
    case "binos": {
        _gcontents = [
            // "ACE_MX2A"       // Thermals
            //,"ACE_Vector"     // NV
            //,"ACE_Vector_day"  
            //,"ACE_Yardage450"
            "Binocular"
            ,"Laserbatteries" // Needed for *some* RF
            //,"Laserdesignator" // NV (same for all variants), needs batteries   
            //,"Laserdesignator_01_khk_F"
            //,"Laserdesignator_02"
            //,"Laserdesignator_02_ghex_F"
            //,"Laserdesignator_03"
            //,"lerca_1200_black" // Needs batteries
            //,"lerca_1200_tan"
            //,"Leupold_Mk4" // Spotting scope
            ,"Rangefinder" // NV, does not need batteries
            //,"rhsusf_lrf_Vector21"
            //,"UK3CB_BAF_Soflam_Laserdesignator" // NV, Thermals, no batt
        ];
    };
    case "engineers": {
        _gcontents = [
             "ACE_Clacker"
            ,"ACE_DefusalKit"
            ,"ACE_M26_Clacker"
            //,"B_UavTerminal"
            ,"MineDetector"
            ,"ToolKit"
            // Explosives
            //,"APERSBoundingMine_Range_Mag"
            //,"APERSMine_Range_Mag"
            //,"ATMine_Range_Mag"
            //,"ClaymoreDirectionalMine_Remote_Mag"
            ,"DemoCharge_Remote_Mag"
            //,"rhs_mine_M19_mag" // AT mine
            ,"SatchelCharge_Remote_Mag"
            //,"SLAMDirectionalMine_Wire_Mag"
        ];
    };
    case "goggles": {
        _gcontents = [
            // Glasses (these *aren't* NVGs!)
             "rhs_googles_black"
            ,"rhs_googles_clear"
        ];
    };
    case "gps": {
        _gcontents = [
             "ACE_MapTools"
            ,"ACE_microDAGR"
            ,"ItemCompass"
            ,"ItemGPS"
            ,"ItemMap"
        ];
    };
    case "helmets": {
        _gcontents = [
            "UK3CB_BAF_H_Mk7_Camo_A",
            "UK3CB_BAF_H_Mk7_Camo_B",
            "UK3CB_BAF_H_Mk7_Camo_C",
            "UK3CB_BAF_H_Mk7_Camo_D",
            "UK3CB_BAF_H_Mk7_Camo_E",
            "UK3CB_BAF_H_Mk7_Camo_F",
            "UK3CB_BAF_H_Mk7_Camo_CESS_A",
            "UK3CB_BAF_H_Mk7_Camo_CESS_B",
            "UK3CB_BAF_H_Mk7_Camo_CESS_C",
            "UK3CB_BAF_H_Mk7_Camo_CESS_D",
            "UK3CB_BAF_H_Mk7_Camo_ESS_A",
            "UK3CB_BAF_H_Mk7_Camo_ESS_B",
            "UK3CB_BAF_H_Mk7_Camo_ESS_C",
            "UK3CB_BAF_H_Mk7_Camo_ESS_D",
            "UK3CB_BAF_H_Mk7_Net_A",
            "UK3CB_BAF_H_Mk7_Net_B",
            "UK3CB_BAF_H_Mk7_Net_C",
            "UK3CB_BAF_H_Mk7_Net_D",
            "UK3CB_BAF_H_Mk7_Net_CESS_A",
            "UK3CB_BAF_H_Mk7_Net_CESS_B",
            "UK3CB_BAF_H_Mk7_Net_CESS_C",
            "UK3CB_BAF_H_Mk7_Net_CESS_D",
            "UK3CB_BAF_H_Mk7_Net_ESS_A",
            "UK3CB_BAF_H_Mk7_Net_ESS_B",
            "UK3CB_BAF_H_Mk7_Net_ESS_C",
            "UK3CB_BAF_H_Mk7_Net_ESS_D",
            "H_PilotHelmetHeli_B"
        ];
    };
    case "medics": {
        _gcontents = [
             "ACE_bloodIV"
            ,"ACE_bloodIV_250"
            ,"ACE_bloodIV_500"
            ,"ACE_bodyBag"
            ,"ACE_fieldDressing"
            ,"ACE_morphine"
            ,"ACE_epinephrine"
        ];
    };
    case "misc": {
        _gcontents = [
             "ACE_Banana"
            ,"ACE_CableTie"
            ,"ACE_EarPlugs"
            ,"ACE_EntrenchingTool"
            ,"ACE_Flashlight_XL50"
            ,"ACE_Tripod"
            ,"ACE_wirecutter"
            ,"ItemWatch"
        ];
    };
    case "nvgs": {
        _gcontents = [
             "NVGoggles" // Base vanilla model
        ];
    };
    case "radios": {
        _gcontents = [
            // Long Range
            // ILBE radios with whip antenna
             "tfw_ilbe_a_wd"
            ,"tfw_ilbe_a_coy"
            ,"tfw_ilbe_a_d" 
            ,"tfw_ilbe_a_gr"
            // Base TFAR
            ,"tf_rt1523g_big"
            ,"tf_rt1523g_big_bwmod"
            ,"tf_rt1523g_big_bwmod_tropen"
            ,"tf_rt1523g_big_rhs"
            ,"tf_rt1523g_black"
            ,"tf_rt1523g_fabric"
            ,"tf_rt1523g_green"
            ,"tf_rt1523g_sage"
            // Short Range
            //,"tf_anprc148jem"
            ,"tf_anprc152"
            //,"tf_anprc154"
            //,"tf_rf7800str"
            // Programmer
            ,"tf_microdagr"
        ];
    };
    case "univests": {
        _gcontents = [
             "MNP_Vest_DS_1"
            ,"MNP_Vest_DS_2"
            ,"U_B_CombatUniform_mcam"
            ,"U_B_CombatUniform_mcam_tshirt"
            ,"U_B_HeliPilotCoveralls"
            ,"V_TacVest_blk"
        ];
    };

    default {
    	hint format ["Item group %1 not known", _group];
    };
};

_gcontents;
