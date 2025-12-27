//-------------------------------------------
// Les éléments de préparation de mission :
//-------------------------------------------

// marker_de_zone_1 est un marker qui affiche la "zone du choix des armes"
// marker_de_zone_2 est un marker qui affiche la "zone du choix de mission"
// marker_de_zone_3 est un marker qui affiche la "zone du choix de l'équipe"
// marker_de_zone_4 est un marker qui affiche la "zone du choix du véhicule"
// marker_de_zone_5 est un marker qui affiche la "zone du choix du temps"

// brothers_in_arms_request est un trigger (lorsqu'on y entre on peut choisir l'équipe)
// brothers_in_arms_spawner est un héliport invisible (lieu d'apparition des membres de l'équipe)

// vehicles_request est un trigger (lorsqu'on y entre on peut choisir le véhicule)
// vehicles_spawner est un héliport invisible (lieu d'apparition du véhicule)
// arsenal_request est un trigger (lorsqu'on y entre on peut choisir l'arsenal)

// missions_request est un trigger (lorsqu'on y entre on peut choisir la mission et ses paramètres)
// weather_and_time_request est un trigger (lorsqu'on y entre on peut choisir l'heure et le temps)

//-------------------------------------------
// Les fonctions de préparation de mission :
//-------------------------------------------

[] call MISSION_fnc_lang_marker_name;
["INIT"] call MISSION_fnc_spawn_brothers_in_arms;
["INIT"] call MISSION_fnc_spawn_vehicles;
["INIT"] call MISSION_fnc_spawn_weather_and_time;
["INIT"] call MISSION_fnc_spawn_arsenal;



//-------------------------------------------
// Les éléments de la tache 1 :
//-------------------------------------------

// task_x_officer_1 à task_x_officer_3 sont les officiers ennemis
// task_x_enemy_00 à task_x_enemy_04 sont des unités ennemies
// task_x_vehicle_00 à task_x_vehicle_03 sont des véhicules ennemis
// task_1_spawn_01 à task_1_spawn_06 sont des héliports qui servent de lieux de spawn ennemi pour la tache 1

//-------------------------------------------
// Les fonctions de taches :
//-------------------------------------------

