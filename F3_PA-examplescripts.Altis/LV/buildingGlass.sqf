_bglass = _this select 0;
for "_i" from 1 to 20 do {
	sleep .1;
	if ((_i % 4 > 1) || (random(1)>0.5)) then{
	_bglass sethit [(format ["glass_%1",_i]),1];
	_bglass animate [(format ["shutter%1",_i]),1];
	};
};

//   {_x animate ["shutter1",1];} foreach (nearestObjects [getpos player, ["Building"], 50]);