//f_optics.sqf 
//
// vim: shiftwidth=4 ai smartindent expandtab tabstop=4
//
// Optics. Mostly everyhting non-russian, non-thermal.
// Note that some scopes have broken zeroing when combines with certain
// weapons.

params ["_group"];

private ["_gcontents"];
_gcontents = [];

switch _group do {
    case "holosights": {
        _gcontents = [
             "ace_optic_MRCO_2D"
            ,"fhq_optic_ac11704"
            ,"fhq_optic_ac11704_tan"
            ,"fhq_optic_ac12136"
            ,"fhq_optic_ac12136_tan"
            ,"fhq_optic_AIM"
            ,"fhq_optic_AIM_tan"
            ,"fhq_optic_AimM_BLK"
            ,"fhq_optic_AimM_TAN"
            ,"fhq_optic_hws"
            ,"fhq_optic_hws_tan"
            ,"fhq_optic_mars"
            ,"fhq_optic_mars_tan"
            ,"fhq_optic_microcco"
            ,"fhq_optic_microcco_low"
            ,"fhq_optic_microcco_low_tan"
            ,"fhq_optic_microcco_tan"
            ,"optic_aco"
            ,"optic_aco_grn"
            ,"optic_aco_grn_smg"
            ,"optic_aco_red"
            ,"optic_aco_red_smg"
            ,"optic_holosight"
            ,"optic_holosight_blk_f"
            ,"optic_holosight_khk_f"
            ,"optic_holosight_smg"
            ,"optic_holosight_smg_blk_f"
            ,"optic_holosight_smg_khk_f"
            ,"optic_MRCO"
            ,"optic_yorris"
            ,"rhs_acc_rm05"
            ,"rhs_acc_rmr_ms19"
            ,"rhs_acc_rmr_ms19_fde"
            ,"rhs_acc_rx01"
            ,"rhs_acc_rx01_nofilter"
            ,"rhsusf_acc_eotech"
            ,"rhsusf_acc_eotech_552"
            ,"rhsusf_acc_eotech_552_d"
            ,"rhsusf_acc_eotech_552_wd"
            ,"rhsusf_acc_eotech_xps3"
            ,"uk3cb_baf_eotech"
            ,"UK3CB_BAF_suit"
            ,"UK3CB_BAF_susat"
        ];
    };
    case "rco": {
        _gcontents = [
             "ACE_optic_Arco_2D"
            ,"ACE_optic_Arco_PIP"
            ,"ACE_optic_Hamr_2D"
            ,"ACE_optic_Hamr_PIP"
            ,"FHQ_optic_ACOG"
            ,"FHQ_optic_ACOG_tan"
            ,"FHQ_optic_HWS_G33"
            ,"FHQ_optic_HWS_G33_tan"
            ,"FHQ_optic_vcog"
            ,"FHQ_optic_vcog_tan"
            ,"optic_Arco"
            ,"optic_Arco_blk_F"
            ,"optic_Arco_ghex_F"
            ,"optic_ERCO_blk_F"
            ,"optic_ERCO_khk_F"
            ,"optic_ERCO_snd_F"
            ,"optic_Hamr"
            ,"optic_Hamr_khk_F"
            ,"rhsusf_acc_ACOG"
            ,"rhsusf_acc_ACOG_mdo"
            ,"rhsusf_acc_acog_usmc"
            ,"rhsusf_acc_ACOG2"
            ,"rhsusf_acc_acog2_usmc"
            ,"rhsusf_acc_ACOG3"
            ,"rhsusf_acc_acog3_usmc"
            ,"rhsusf_acc_compm4"
            ,"rhsusf_acc_g33_T1"
            ,"rhsusf_acc_g33_xps3"
            ,"rhsusf_acc_g33_xps3_tan"
            ,"rhsusf_acc_specterdr"
            ,"rhsusf_acc_specterdr_a"
            ,"rhsusf_acc_specterdr_d"
            ,"rhsusf_acc_specterdr_od"
            ,"RKSL_optic_LDS"
            ,"RKSL_optic_LDS_C"
            ,"UK3CB_BAF_SpecterLDS"
            ,"UK3CB_BAF_suit"
            ,"UK3CB_BAF_susat"
            ,"UK3CB_BAF_TA31F"
            ,"UK3CB_BAF_TA31F_Hornbill"
        ];
    };
    case "scopes": {
        _gcontents = [
             "ACE_optic_LRPS_2D"
            ,"ACE_optic_LRPS_PIP"
            ,"ACE_optic_sos_2d"
            ,"ACE_optic_sos_pip"
            ,"fhq_optic_leupoldert"
            ,"fhq_optic_leupoldert_tan"
            ,"optic_AMS"
            ,"optic_AMS_khk"
            ,"optic_AMS_snd"
            ,"optic_DMS"
            ,"optic_KHS_blk"
            ,"optic_KHS_hex"
            ,"optic_KHS_old"
            ,"optic_KHS_tan"
            ,"optic_LRPS"
            ,"optic_LRPS_ghex_F"
            ,"optic_LRPS_tna_F"
            ,"optic_SOS"
            ,"optic_SOS_khk_f"
            ,"rhs_acc_elcan"
            ,"rhs_acc_elcan_ard"
            ,"RKSL_optic_PMII_312"
            ,"RKSL_optic_PMII_312_des"
            ,"RKSL_optic_PMII_312_sunshade"
            ,"RKSL_optic_PMII_312_sunshade_des"
            ,"RKSL_optic_PMII_312_sunshade_wdl"
            ,"RKSL_optic_PMII_312_wdl"
            ,"RKSL_optic_PMII_525"
            ,"RKSL_optic_PMII_525_des"
            ,"RKSL_optic_PMII_525_wdl"
            ,"UK3CB_BAF_TA648"
            ,"UK3CB_BAF_TA648_308"
        ];
    };
    case "nv_thermals": {
        _gcontents = [
             "fhq_optic_tws3050"     // Thermals
            ,"optic_nightstalker"    // Thermals
            ,"optic_nvs"
            ,"optic_tws"             // Thermals
            ,"optic_tws_mg"          // Thermals
            ,"rhsusf_acc_anpas13gv1" // Thermals
            ,"rhsusf_acc_anpvs27"
            ,"UK3CB_BAF_kite"
            ,"UK3CB_BAF_maxikite"
        ];
    };

    default {
    	hint format ["Item group %1 not known", _group];
    };
};

_gcontents;
