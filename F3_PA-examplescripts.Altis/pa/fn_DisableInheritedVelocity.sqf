/*disables projectiles inheriting vehicle velocity to allow for easier aiming of
aircraft turrets while vehicle is moving.


arguments: vehicle(obj), enabled(bool)
return: true


Can be turned on and off by passing true or false in the second argument.  
Useful if you want to dynamically enable or disable this functionality.


Reccomended for use on Blackfish, Blackfoot, Kajman, and Xi'an gunships.
*/


params [
["_veh", objNull, [objNull], 1],
["_act", false, [true], 1]
];
_var = _veh getVariable "JWL_vars_disableInheritedVelocity";
if (_act) then [{
  _ind = _veh addEventHandler ["Fired",{
    _ammo = (_this select 4);
    _path = (configFile >> "CfgAmmo");
    if ((_ammo isKindOf ["BulletCore", _path]) || (_ammo isKindOf ["ShellCore", _path])) then {
      (_this select 6) setVelocity ((velocity (_this select 6)) vectorDiff (velocity (_this select 0)));
    };
  }];
  _veh setVariable ["JWL_vars_disableInheritedVelocity",_ind,true];
},{
  if (!(isNil "_var")) then {
    _veh removeEventHandler ["fired",_var];
    _veh setVariable ["JWL_vars_disableInheritedVelocity",nil,true];
  };
}];
true