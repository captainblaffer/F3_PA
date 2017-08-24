        private ["_alivedudes","_grp","_remainingtoattack"];
 
		_grp = group _this;
		_remainingtoattack = _grp getvariable "remainingtoattack";
		
		 _alivedudes = 0;
		{
			if (alive _x) then {_alivedudes=_alivedudes+1;};
		}foreach (units group _this);

		if (_alivedudes <= _remainingtoattack) then {
			{
				//_EHleaveBIdx = _x getvariable "EHleaveBIdx";
				//_x removeeventhandler ["killed",_EHleaveBIdx];
				
				_x forceSpeed -1;
				_x enableAI "TARGET";
				[_x]spawn{
				sleep 5;
				(_this select 0) commandMove (getpos (_this select 0));
				};
			}foreach (units group _this);
			
			[_this] call CBA_fnc_taskPatrol;
		};