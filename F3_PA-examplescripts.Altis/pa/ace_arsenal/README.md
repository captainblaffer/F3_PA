# Limited ACE Arsenal helper scripts

Author: klausman
License: [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Usage

Plop down any container and add this to its init:

```sqf
nul = [this] execVM "pa\ace_arsenal\fn_set_ace_arsenal.sqf";
```

This will place the default arsenal (`baseNato`) on the box. Make sure to
clear out whatever items the box normally has if you don't want them. Also
note that to open the ACE arsenal in game, you have to use the ACE interaction
menu (instead of the vanilla scroll menu).

Note that you still need to handle the base equipment the players get through
`assignGear`. Also, if they have gear that is not in the arsenal and switch
around things, they may lose that gear!

## Customization

Customization of what's in the Arsenal is the key aspect of this script.

The different types of arsenals are defined in
`pa\ace_arsenal\fn_set_ace_arsenal.sqf` itself. For example:

```sqf
    case "baseNato": {
        // Rifles
        {   _a = [_x] call f_rifles; 
            _contents = _contents + _a; } foreach 
            ["ebr" ,"m4a1_block2" ,"m24" ,"mk11" ,"mk18" ,"mk46m1"];
        // Optics
        {   _a = [_x] call f_optics; 
            _contents = _contents + _a; } foreach 
            ["holosights" ,"rco" ,"scopes"];
        // Handguns
        {   _a = [_x] call f_handguns; 
            _contents = _contents + _a; } foreach 
            ["m1911a1" ,"fnx45"];
        // Launchers
        {   _a = [_x] call f_launchers; 
            _contents = _contents + _a; } foreach 
            ["at-4", "maaws"];
        // Hand grenades etc.
        {   _a = [_x] call f_throwables; 
            _contents = _contents + _a; } foreach 
            ["frags", "smoke", "incendiary"];

        // Specialist Roles
        {   _a = [_x] call f_items; 
            _contents = _contents + _a; } foreach
            ["engineers", "medics"];
        // Stuff for everybody
        {   _a = [_x] call f_items; 
            _contents = _contents + _a; } foreach
            ["backpacks", "binos", "goggles", "gps", "helmets", "misc",
             "radios", "univests"];
    }; // End of natoDefault
```

This will add the items defined by, e.g. `mk46m1` to the arsenal. The strings
are arbitrary, so you can make up your own classes and define their contents
in the corresponding files. For example, the `mk46m1` class is defined in
`f_rifles.sqf`:


```sqf
    // The same class can have multiple names. All but the last should
    // end with ";". The last one (or sole one) must end with ":"
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
```

In this case, this will add the Mk46 Mod1 to the arsenal, along with assorted
types of ammunition. For some weapons, one could also put accessories like
bipods, foregrips, suppressors and the like in the class for easier
management. In the example classes here, I have done so for everything except
optics, which are all in one big class in `f_optics.sqf`, since it was easier
to just add all non-russian, non-thermal optics this way. For a more
restrictive set, on e.g. sniper rifles, it may make more sense to group the
optics with their rifles. Whatever works for you! One last tip: when you have
a long list of stuff, sort it by type. E.g. the Mk11 class in `f_rifles.sqf`
has the Mk11 variants first, then the ammo types, then the (commented out)
suppressors. 

## Troubleshooting

Typically, when you get errors from the script, it will either be a message
about an unknown class/arsenal type, which typically indicates a typo.

Or it will be an error message about a mismatched type ("expected number, got
string"). Most often, this will be causes by one of the lists in a class file
not having the right number of commas, i.e. a comma before the first element,
or a missing comma between to elements. Also, make sure to not for get the
closing `];` and `};` for the lists and `case` statements. Do not worry about
classes that you don't use: they will simply be ignored silently.
