
params ["_funzctionparams","_namefncrito"];

//find headless client to abuse
_hc = "";
if (ca_hcrand) then {
  _hc = selectRandom ca_hclist;
}else{
  _hc = [] call p_fnc_hcfind;
};

_namestrfncrito = str _namefncrito;
_funzctionparams remoteExec [_namefncrito, _hc];
