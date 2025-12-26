// Variables définies en jeu 

// marker_de_zone_1 est un marker qui affiche la "zone du choix des armes"
// marker_de_zone_2 est un marker qui affiche la "zone du choix de mission"
// marker_de_zone_3 est un marker qui affiche la "zone du choix de l'équipe"
// marker_de_zone_4 est un marker qui affiche la "zone du choix du véhicule"

// brothers_in_arms_request est un trigger (lorsqu'on y entre on peut choisir l'équipe)
// brothers_in_arms_spawner est un héliport invisible (lieu d'apparition des membres de l'équipe)

// vehicles_request est un trigger (lorsqu'on y entre on peut choisir le véhicule)
// vehicles_spawner est un héliport invisible (lieu d'apparition du véhicule)

// missions_request est un trigger (lorsqu'on y entre on peut choisir la mission et ses paramètres)

// arsenal_request est un trigger (lorsqu'on y entre on peut choisir l'arsenal)

// Les fonctions de préparation de mission
[] call MISSION_fnc_lang_marker_name;
["INIT"] call MISSION_fnc_spawn_brothers_in_arms;
["INIT"] call MISSION_fnc_spawn_vehicles;
["INIT"] call MISSION_fnc_spawn_arsenal;

// Les fonctions de la tache 1

