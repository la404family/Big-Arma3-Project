// Variables définies en jeu 

// hostageVIP est un civil otage dans le village
// vehiculeBLUFOR est camion 
// BLUFOR_players sont les joueurs ou les unités jouables
// player_1, player_2, player_3, player_4, player_5, sont les membres de BLUFOR_players
// spawn_01, spawn_02, spawn_03, spawn_04, spawn_05, spawn_06, spawn_07, spawn_08 sont les points de spawn
// zoneCouvertureDrone est un marker qui permet de définir la zone de couverture du drone
// droneBLUFOR est le drone qui surveille la zone
// directionDroneFinDeMission est un objet vide dans le jeu qui permet de définir la direction du drone à la fin de la mission
// volEnAttente est un Waypoint qui permet de définir le vol en attente du drone
// heliFINDEMISSION est un hélicoptère qui intervient à la fin de la mission

// lancer les fonctions en début de mission
if (isServer) then {
    // Introduction de la mission
    //[] execVM "fn_introductionMission.sqf";
    // mettre tous les BLUFOR et le civil du jeu en voix Françaises :
    [] execVM "fn_BLUFORforcingENGLISH.sqf";
    // Mettre des noms et prénoms français aux unités BLUFOR
    [] execVM "fn_identityChange.sqf";
    // AJouter un boutton d'action pour se soigner
    [] execVM "fn_addActionHeal.sqf";
    // Ajouter un bouton d'action pour se regrouper
    [] execVM "fn_addActionRegroup.sqf";
    // Ajouter un spawn aléatoire
    // [] execVM "fn_addRandomSpawn.sqf";
    // Otage devient BLUFOR
    // [] execVM "fn_addHostageToBLUFOR.sqf"; (dans trigger)
    // Systeme de drone
    //[] execVM "fn_droneSystem.sqf"; (dans trigger)
    // film d'introduction
    // [] execVM "fn_introductionFilm.sqf";
    // Script de fin de mission
    [] execVM "fn_endMission.sqf";
};