/*
 * Author: Poulern
 * [Returns the headless client with the least amount of AI assigned to it]
 *
 *
 * Return Value:
 * Return Name <TYPE>
 *
 * Example:
 * [] call ca_fnc_hcfind
 *
 * Public: [Yes/No]
 */


 _HCaicounts = [];
 {

   _hcai = call compile _x;

    _HCaicounts pushBack _hcai;
 } forEach ca_hcidlist;

_headlessclient = "";
_hclist = [];
_hclist append _HCaicounts;
_hclist sort true;

_hcid = _hclist select 0;

_result = _HCaicounts find _hcid;
if (_result == -1) then {
    _headlessclient = 2;
} else {
  _headlessclient = ca_hclist select _result;
};

_headlessclient
