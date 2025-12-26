
params ["_mode", ["_params", []]];

switch (_mode) do {
    case "INIT": {
        if (!hasInterface) exitWith {};
        
        // Wait for player and mission objects
        waitUntil { !isNull player };
        
        player addAction [
            localize "STR_ACTION_GARAGE", 
            {
                ["OPEN_UI"] call MISSION_fnc_spawn_vehicles;
            },
            [],
            1.5, 
            true, 
            true, 
            "",
            "player inArea vehicles_request"
        ];
    };

    case "OPEN_UI": {
        createDialog "Refour_Vehicle_Dialog";
        
        // Wait for dialog to open
        waitUntil {!isNull (findDisplay 8888)};
        
        private _display = findDisplay 8888;
        private _ctrlList = _display displayCtrl 1500;
        
        lbClear _ctrlList;

        // Get config classes - Filter by Side
        private _sideInt = (side player) call BIS_fnc_sideID;
        private _cfgVehicles = configFile >> "CfgVehicles";
        
        // Initial broad filter
        private _units = "
            (getNumber (_x >> 'scope') >= 2) && 
            (getNumber (_x >> 'side') == _sideInt)
        " configClasses _cfgVehicles;

        // Prepare a sortable array
        private _sortableUnits = [];

        {
            private _class = _x;
            private _className = configName _class;
            
            // Logic for filtering Vehicles specifically
            // Include: Car, Tank, Helicopter
            // Exclude: UAV, Ship, Plane, StaticWeapon, Men
            
            private _isLandOrAir = (_className isKindOf "Car") || (_className isKindOf "Tank") || (_className isKindOf "Helicopter");
            
            if (_isLandOrAir) then {
                // Check exclusions
                private _isExcluded = 
                    (_className isKindOf "UAV") ||          
                    (_className isKindOf "Ship") ||         
                    (_className isKindOf "Plane") ||        
                    (_className isKindOf "StaticWeapon") || 
                    (_className isKindOf "Man");            

                if (!_isExcluded) then {
                    private _displayName = getText (_class >> "displayName");
                    private _factionClass = getText (_class >> "faction");
                    
                    private _factionDisplayName = getText (configFile >> "CfgFactionClasses" >> _factionClass >> "displayName");
                    if (_factionDisplayName == "") then { _factionDisplayName = _factionClass; }; // Fallback
        
                    private _entryText = format ["[%1] %2", _factionDisplayName, _displayName];
                    
                    _sortableUnits pushBack [_entryText, _className];
                };
            };

        } forEach _units;

        // Sort alphabetically
        _sortableUnits sort true;

        // Add to Listbox
        {
            _x params ["_text", "_data"];
            private _index = _ctrlList lbAdd _text;
            _ctrlList lbSetData [_index, _data];
            
            private _pic = getText (configFile >> "CfgVehicles" >> _data >> "picture");
            if (_pic != "") then {
                _ctrlList lbSetPicture [_index, _pic];
            };
        } forEach _sortableUnits;

        if (lbSize _ctrlList > 0) then {
            _ctrlList lbSetCurSel 0;
        };
    };

    case "SPAWN": {
        disableSerialization;
        private _display = findDisplay 8888;
        private _listBox = _display displayCtrl 1500;

        // Validation
        private _indexSelection = lbCurSel _listBox;
        if (_indexSelection == -1) exitWith {
            systemChat (localize "STR_ERR_NO_VEHICLE_SELECTED");
        };

        // Data Retrieval
        private _classname = _listBox lbData _indexSelection;
        private _displayName = _listBox lbText _indexSelection;

        // Close Dialog
        closeDialog 1;

        // Define Spawn Position
        private _spawnPos = [];
        private _spawnDir = 0;

        if (!isNil "vehicles_spawner" && {!isNull vehicles_spawner}) then {
            _spawnPos = getPosATL vehicles_spawner;
            _spawnDir = getDir vehicles_spawner;
            
            // Adjust Z slightly to prevent ground clipping
            _spawnPos = [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) + 0.1];
        } else {
            systemChat (localize "STR_DEBUG_NO_SPAWNER");
            // Fallback
            _spawnPos = player getRelPos [10, 0]; 
            _spawnDir = getDir player;
            _spawnPos = [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) + 0.1];
        };

        // Spawn Process - Empty vehicle
        private _veh = createVehicle [_classname, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _spawnDir;
        _veh setPosATL _spawnPos;
        
        // Notification
        hint format [localize "STR_VEHICLE_AVAILABLE", _displayName];
    };
};
