// F3 - Add TFR Radios Function
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// DECLARE VARIABLES

private["_unit", "_typeOfUnit", "_longRange","_radio1","_radio2","_radio3", "_backpackItems"];

_unit = player;

_typeOfUnit = _unit getVariable ["f_var_assignGear", "NIL"];

// DEFINE THE RADIOS THAT WILL BE USED

// Note that the TFAR variables (e.g. TFAR_DefaultRadio_Backpack_West)
// can be customized in the Editor under Settings > Addon Options, then
// going to the MISSION tab, and customizing the TFAR - global settings
// setup.

switch ((side player)) do { //longrange, shortrange, rifradio
    case (west): {
      _radio1 = TFAR_DefaultRadio_Backpack_West;
      _radio2 = TFAR_DefaultRadio_Personal_West;
      _radio3 = TFAR_DefaultRadio_Rifleman_West;};
    case (east): {
      _radio1 = TFAR_DefaultRadio_Backpack_East;
      _radio2 = TFAR_DefaultRadio_Personal_East;
      _radio3 = TFAR_DefaultRadio_Rifleman_East;};
    default {
      _radio1 = TFAR_DefaultRadio_Backpack_Independent;
      _radio2 = TFAR_DefaultRadio_Personal_Independent;
      _radio3 = TFAR_DefaultRadio_Rifleman_Independent;};
};

// ====================================================================================

// ASSIGN RADIOS TO UNITS
// Depending on the loadout used in the assignGear component, each unit is assigned
// a set of radios.

if(_typeOfUnit != "NIL") then {
   // Set the list of units that get a rifleman's radio
   _rifradio = ["ar","aar","rat","samag","mmgag","hmgag","matag","hatag","mtrag","sp","r","car","smg","gren","dm"];

   // Set the list of units that get a shortrange radio
   _shortrange = ["co", "dc", "ftl", "m", "samg", "mmgg", "matg", "sn", "mtrg"];

   // Give out respective radios

   if (_typeOfUnit in _rifradio) then {
     _unit linkItem _radio3;
   } else {
     if (_typeOfUnit in _shortrange) then {
       _unit linkItem _radio2;
     };
   };

   // Special cases
   _specialist = ["vc", "pp", "eng", "engm", "div","uav"];

   // If unit is leader of group and in the above list, give SR. Else, give them
   // a rifleman's radio.

   if (_typeOfUnit in _specialist) then {
     if (_unit == (leader (group _unit))) then {
       _unit linkItem _radio2;
     } else {
       _unit linkItem _radio3;
     };
   };

   if ( !(_typeOfUnit in _rifradio) && !(_typeOfUnit in _shortrange) && !(_typeOfUnit in _specialist) ) then {
     _unit linkItem _radio3;
   };

   // Give out LR backpacks according to f\radios\tfr_settings.sqf.
   if(f_radios_settings_tfr_defaultLRBackpacks) then {
     if (_unit == (leader (group _unit))) then {
       _backpackItems = backpackItems player;
       removeBackpack _unit;
       _unit addBackpack _radio1;
       {player addItemToBackpack _x;} forEach _backpackItems;
     };
   } else {
     // If unit is in the list of units that receive a long-range radio, do so.
     if(_typeOfUnit in f_radios_settings_tfr_backpackRadios) then {
       _backpackItems = backpackItems player;
       removeBackpack _unit;
       _unit addBackpack _radio1;
       {player addItemToBackpack _x;} forEach _backpackItems;
     };
   };
};

// ====================================================================================
