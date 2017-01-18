/*
IN the initline of each vehicle you want increase fuel consumption
_p = [this] spawn p_fnc_incfuelcon;

init.sqf put in:
if(isserver) then {
  missionNamespace setVariable ['p_fuelrate',0.00027777777, true];
};

<font size='18'>Fuel Consumption Control</font><br/><br/>
|- <execute expression=""_riot = (0.01666666666/p_fuelrate)-5; _newnumb = (0.01666666666/_riot); missionNamespace setVariable ['p_fuelrate',_newnumb, true];"">
Increase Fuel Consumption(5min/hour)</execute><br/>
|- <execute expression=""_riot = (0.01666666666/p_fuelrate)+5; _newnumb = (0.01666666666/_riot); missionNamespace setVariable ['p_fuelrate',_newnumb, true];"">
Decrease Fuel Consumption(5min/hour)</execute><br/>
|- <execute expression="" hint format ['%1 units fps, %2 minutes left for full tank',p_fuelrate,(0.01666666666/p_fuelrate)]"">
Check consumption(fuel/second)</execute><br/>

*/
params ["_truck"];

while {true} do {

  if (isEngineOn _truck) then {
  _truck setFuel ( Fuel _truck - p_fuelrate);
  };

  uisleep 1;

};
