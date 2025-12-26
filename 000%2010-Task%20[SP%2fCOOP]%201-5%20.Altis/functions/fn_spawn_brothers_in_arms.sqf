
params ["_mode", ["_params", []]];

switch (_mode) do {
    case "INIT": {
        if (!hasInterface) exitWith {};
        
        // Wait for player and mission objects
        waitUntil { !isNull player };
        
        player addAction [
            localize "STR_ADD_BROTHER", 
            {
                ["OPEN_UI"] call MISSION_fnc_spawn_brothers_in_arms;
            },
            [],
            1.5, 
            true, 
            true, 
            "",
            "player inArea brothers_in_arms_request"
        ];
    };

    case "OPEN_UI": {
        createDialog "Refour_Recruit_Dialog";
        
        // Wait for dialog to open
        waitUntil {!isNull (findDisplay 8888)};
        
        private _display = findDisplay 8888;
        private _ctrlList = _display displayCtrl 1500;
        
        lbClear _ctrlList;

        // Get config classes - Filter by Side (to include all friendly factions like NATO, FIA, etc.)
        private _sideInt = (side player) call BIS_fnc_sideID;
        private _cfgVehicles = configFile >> "CfgVehicles";
        
        private _units = "
            (getNumber (_x >> 'scope') == 2) && 
            (getText (_x >> 'simulation') == 'soldier') && 
            (getNumber (_x >> 'side') == _sideInt)
        " configClasses _cfgVehicles;

        // Prepare a sortable array: [SortKey, DisplayName, ClassName]
        // SortKey will be "FactionName UnitName" to group by faction
        private _sortableUnits = [];

        {
            private _class = _x;
            private _displayName = getText (_class >> "displayName");
            private _className = configName _class;
            private _factionClass = getText (_class >> "faction");
            
            // Get Faction Display Name
            private _factionDisplayName = getText (configFile >> "CfgFactionClasses" >> _factionClass >> "displayName");
            if (_factionDisplayName == "") then { _factionDisplayName = _factionClass; }; // Fallback

            // Construct Entry Text: [Faction] Unit Name
            private _entryText = format ["[%1] %2", _factionDisplayName, _displayName];
            
            // Push to array
            _sortableUnits pushBack [_entryText, _className];

        } forEach _units;

        // Sort alphabetically
        _sortableUnits sort true;

        // Add to Listbox
        {
            _x params ["_text", "_data"];
            private _index = _ctrlList lbAdd _text;
            _ctrlList lbSetData [_index, _data];
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
            systemChat (localize "STR_ERR_NO_UNIT_SELECTED");
        };

        // Data Retrieval
        private _classname = _listBox lbData _indexSelection;
        private _displayName = _listBox lbText _indexSelection;

        // Close Dialog
        closeDialog 1;

        // Define Spawn Position
        private _spawnPos = [];
        if (!isNil "brothers_in_arms_spawner" && {!isNull brothers_in_arms_spawner}) then {
            _spawnPos = getPosATL brothers_in_arms_spawner;
        } else {
            _spawnPos = player getRelPos [5, 0]; // Fallback
        };

        // Spawn Process
        [_classname, _spawnPos, _displayName] spawn {
            params ["_class", "_pos", "_name"];
            
            // Create temp group
            private _tempGroup = createGroup [side player, true];
            
            // Create Unit
            private _newUnit = _tempGroup createUnit [_class, _pos, [], 0, "CAN_COLLIDE"];
            
            // Set direction
            if (!isNil "brothers_in_arms_spawner" && {!isNull brothers_in_arms_spawner}) then {
                _newUnit setDir (getDir brothers_in_arms_spawner);
            };
            
            // Notification
            systemChat format [localize "STR_UNIT_ARRIVING", _name];
            
            // Critical Wait
            sleep 0.7;
            
            // Join player group
            [_newUnit] joinSilent (group player);
            
            // Final Notification
            hint format [localize "STR_UNIT_JOINED", _name];
            
            // Cleanup
            deleteGroup _tempGroup;
        };
    };
};
