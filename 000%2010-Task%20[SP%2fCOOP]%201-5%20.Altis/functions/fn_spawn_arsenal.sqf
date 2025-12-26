
params ["_mode", ["_params", []]];

switch (_mode) do {
    case "INIT": {
        if (!hasInterface) exitWith {};
        
        // Wait for player object
        waitUntil { !isNull player };
        
        player addAction [
            localize "STR_ACTION_ARSENAL", 
            {
                // Open Virtual Arsenal on player
                ["Open", [true]] call BIS_fnc_arsenal;
            },
            [],
            1.5, 
            true, 
            true, 
            "",
            "player inArea arsenal_request"
        ];
    };
};
