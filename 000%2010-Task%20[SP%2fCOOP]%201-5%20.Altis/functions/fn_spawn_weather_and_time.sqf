params ["_mode"];

if (_mode == "INIT") exitWith {
    // Attendre que la mission commence
    [] spawn {
        waitUntil {time > 0};
        
        // Ajouter l'action au joueur
        // La condition "player inArea weather_and_time_request" assure que l'action n'apparaît que dans la zone
        player addAction [
            localize "STR_ACTION_WEATHER", 
            {
                ["OPEN"] call MISSION_fnc_spawn_weather_and_time;
            },
            [],
            1.5, 
            true, 
            true, 
            "", 
            "player inArea weather_and_time_request"
        ];
    };
};

if (_mode == "OPEN") exitWith {
    createDialog "Refour_Weather_Time_Dialog";
    
    // Remplir la liste des Heures
    // 3,5,7,10,11,13,17,18,19,22
    private _ctrlTime = (findDisplay 9999) displayCtrl 2100;
    private _times = [3,5,7,10,11,13,17,18,19,22];
    {
        private _index = _ctrlTime lbAdd format ["%1:00", _x];
        _ctrlTime lbSetData [_index, str _x];
    } forEach _times;
    _ctrlTime lbSetCurSel 0;

    // Remplir la liste de Couverture Nuageuse
    // 05,10,15,30,45,55,60,75,80,95
    private _ctrlClouds = (findDisplay 9999) displayCtrl 2101;
    private _clouds = [5,10,15,30,45,55,60,75,80,95];
    {
        private _index = _ctrlClouds lbAdd format ["%1%2", _x, "%"];
        _ctrlClouds lbSetData [_index, str (_x / 100)];
    } forEach _clouds;
    _ctrlClouds lbSetCurSel 0;

    // Remplir la liste du Brouillard
    // 00,10,15,20,25,30,45,55,60,75
    private _ctrlFog = (findDisplay 9999) displayCtrl 2102;
    private _fogs = [0,10,15,20,25,30,45,55,60,75];
    {
        private _index = _ctrlFog lbAdd format ["%1%2", _x, "%"];
        _ctrlFog lbSetData [_index, str (_x / 100)];
    } forEach _fogs;
    _ctrlFog lbSetCurSel 0;
};

if (_mode == "APPLY") exitWith {
    private _ctrlTime = (findDisplay 9999) displayCtrl 2100;
    private _ctrlClouds = (findDisplay 9999) displayCtrl 2101;
    private _ctrlFog = (findDisplay 9999) displayCtrl 2102;

    private _timeSel = _ctrlTime lbData (lbCurSel _ctrlTime);
    private _cloudSel = _ctrlClouds lbData (lbCurSel _ctrlClouds);
    private _fogSel = _ctrlFog lbData (lbCurSel _ctrlFog);

    if (_timeSel != "" && _cloudSel != "" && _fogSel != "") then {
        // Appliquer l'heure
        private _hour = parseNumber _timeSel;
        private _date = date;
        _date set [3, _hour];
        _date set [4, 0];
        setDate _date;

        // Appliquer la météo
        // 0 transition time pour effet immédiat
        0 setOvercast (parseNumber _cloudSel);
        0 setFog (parseNumber _fogSel);
        
        // Forcer le changement immédiat
        forceWeatherChange;

        hint format [
            "%1: %2:00\n%3: %4%5\n%6: %7%8", 
            localize "STR_LABEL_TIME", _hour,
            localize "STR_LABEL_CLOUDS", (parseNumber _cloudSel) * 100, "%",
            localize "STR_LABEL_FOG", (parseNumber _fogSel) * 100, "%"
        ];
        
        closeDialog 0;
    } else {
        hint "Error: Invalid selection";
    };
};
