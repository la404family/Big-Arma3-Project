
params ["_mode", ["_params", []]];

switch (_mode) do {
    case "INIT": {
        if (!hasInterface) exitWith {};
        
        // Wait for player and mission objects
        waitUntil { !isNull player };
        
        player addAction [
            "<t color='#00FFFF'>Garage</t>", // Hardcoded for now as I don't have the stringtable
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
        createDialog "Refour_Recruit_Dialog";
        
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

        // Prepare a sortable array: [SortKey, DisplayName, ClassName]
        private _sortableUnits = [];

        {
            private _class = _x;
            private _className = configName _class;
            
            // Logic for filtering Vehicles specifically
            // Include: Car, Tank, Helicopter
            // Exclude: UAV, Ship, Plane, StaticWeapon, Men, etc.
            
            // Check inclusions
            private _isLandOrAir = (_className isKindOf "Car") || (_className isKindOf "Tank") || (_className isKindOf "Helicopter");
            
            if (_isLandOrAir) then {
                // Check exclusions
                private _isExcluded = 
                    (_className isKindOf "UAV") ||          // Drone
                    (_className isKindOf "Ship") ||         // Bateaux/Submersibles
                    (_className isKindOf "Plane") ||        // Avions
                    (_className isKindOf "StaticWeapon") || // Tourelles
                    (_className isKindOf "Man");            // Infanterie (should be covered by isKindOf Car/Tank check usually, but good to be safe)

                if (!_isExcluded) then {
                    private _displayName = getText (_class >> "displayName");
                    private _factionClass = getText (_class >> "faction");
                    
                    // Get Faction Display Name
                    private _factionDisplayName = getText (configFile >> "CfgFactionClasses" >> _factionClass >> "displayName");
                    if (_factionDisplayName == "") then { _factionDisplayName = _factionClass; }; // Fallback
        
                    // Construct Entry Text: [Faction] Vehicle Name
                    private _entryText = format ["[%1] %2", _factionDisplayName, _displayName];
                    
                    // Push to array
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
            // Optional: Picture
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
            systemChat "Erreur : Aucun véhicule sélectionné.";
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
        } else {
            // Fallback if marker/object is missing
            _spawnPos = player getRelPos [10, 0]; 
            _spawnDir = getDir player;
        };

        // Spawn Process
        // Vehicles are spawned empty (can_collide or none?)
        // NONE is safer for vehicles to avoid exploding inside ground, but might fail if blocked.
        // CAN_COLLIDE ensures it spawns but might clip.
        // Let's use NONE and a slightly higher pos or rely on engine.
        
        private _veh = createVehicle [_classname, _spawnPos, [], 0, "NONE"];
        _veh setDir _spawnDir;
        _veh setPosATL _spawnPos; // Force position
        
        // Notification
        systemChat format ["%1 est apparu.", _displayName];
    };
};
