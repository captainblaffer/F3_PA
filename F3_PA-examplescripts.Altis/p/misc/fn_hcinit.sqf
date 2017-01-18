/*
 * Author: Poulern
 * Description: Initializes the headless framework component
 *
 * Public: [Yes]
 */
 if !(isServer) exitWith {};

_allHCs = entities "HeadlessClient_F";
_allHCids = [];
{
  _hcid = format ["%1count", _x];
  missionNamespace setVariable [_hcid,0, true];

   _allHCids pushBackUnique _hcid;

  [_x,_hcid] remoteExec ["p_fnc_hccount", _x, true];
} forEach _allHCs;

missionNamespace setVariable ["ca_hclist",_allHCs, true];
missionNamespace setVariable ["ca_hcidlist",_allHCids, true];

if (count _allHCs == 0) then {
  missionNamespace setVariable ["ca_hc",false, true];
  missionNamespace setVariable ["ca_hcrand",false, true];
} else {
  missionNamespace setVariable ["ca_hc",true, true];
  missionNamespace setVariable ["ca_hcrand",true, true];

};

[]spawn { while {true} do {
  _HCaicounts = [];
  {

    _hcai = call compile _x;

     _HCaicounts pushBack _hcai;
  } forEach ca_hcidlist;

  missionNamespace setVariable ["ca_hccount",_HCaicounts, true]; sleep 1;

}; };
