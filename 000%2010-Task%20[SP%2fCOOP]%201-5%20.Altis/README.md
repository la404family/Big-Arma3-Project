# 🛠️ Guide de Conception de Mission Arma 3 : Randomisation & Standards

Ce document détaille les instructions pour créer une mission immersive, rejouable et compatible à la fois en Singleplayer (SP) et en Coopératif (COOP).

---

## 1. Conception de Mission : Randomisation & Dynamisme

Pour maximiser la rejouabilité, il est crucial d'intégrer des éléments aléatoires et une vie autonome dans la mission.

### 🎲 Probabilité et Placement des Ennemis
*   **Probabilité de présence** : Fixez à **20 %** la chance d'apparition pour les éléments aléatoires.
*   **Groupes d'ennemis** : Placez environ **de nombreux groupes potentiels**, mais leurs apparitions seront régies par la probabilité définie.
*   **Marqueurs d'objectifs** : Privilégiez des **zones de recherche** (ex: 1 km de diamètre) plutôt que des points précis, forçant le joueur à explorer.

### 🎯 Objectifs et Patrouilles Dynamiques
*   **Objectifs multiples** : Créez un pool d'objectifs variés (détruire, capturer, secourir), mais n'en activez qu'une sélection aléatoire à chaque lancement.
*   **Positions variables** : Tirez au sort l'emplacement des objectifs parmi **5 à 10 positions prédéfinies**.
*   **Patrouilles aléatoires** : Définissez des itinéraires non-linéaires et choisis au hasard pour les IA.

### 🌍 Dynamisme Général
*   **Monde vivant** : Intégrez des événements indépendants des actions du joueur (ex: convois, combats entre IA, trafic civil).
*   **Tâches variées** : Mélangez les types de missions (Sauvetage, Destruction, Capture, Reconnaissance).

### 🌳 Structure de la Mission (Exemple d'Arborescence)

```mermaid
graph TD
    Start[Mission Start] --> RandomTime[Random: Time/Weather]
    RandomTime --> RandomLoc[Random: Starting Location]
    RandomLoc --> RandomObj[Random: Primary Objective]
    RandomObj --> RandomEnemy[Random: Enemy Forces]
    RandomEnemy --> DynamicEvent{Dynamic: Secondary Events <br/>(40% Chance)}
    DynamicEvent -->|Yes| SecEvent[Secondary Event Triggered]
    DynamicEvent -->|No| Extraction
    SecEvent --> Extraction[Random: Extraction Method]
```

---

## 2. Bonnes Pratiques de Codage (SP/COOP)

> **La Règle d'Or** : Codez toujours pour le **COOP**. Si cela fonctionne en multijoueur, cela fonctionnera automatiquement en solo.

### Gestion Serveur vs Client
En SP, votre machine est à la fois serveur et client. En COOP, ces rôles sont séparés.
*   `isServer` : Vrai sur la machine locale en SP, vrai uniquement sur le serveur dédié/hôte en MP.

#### Exemple de structure (init.sqf ou Triggers)

```sqf
// --- CÔTÉ SERVEUR UNIQUEMENT ---
// Gestion du spawn des IA, des objectifs et de la fin de mission
if (isServer) then {
    // Code pour spawner les ennemis aléatoires
    [] execVM "scripts/spawn_ennemis.sqf";
    
    // Gestion de la logique de fin
    [] execVM "scripts/fin_mission.sqf";
};

// --- CÔTÉ CLIENT (Joueurs) ---
// Gestion des effets visuels, briefing, musique, intros
if (hasInterface) then {
    // Titre d'intro
    ["Titre de la Mission", "Sous-titre", "Date"] spawn BIS_fnc_infoText;
    
    // Initialisation du briefing
    [] execVM "scripts/briefing.sqf";
};
```

### 🚫 Erreurs Courantes
*   **NE JAMAIS UTILISER** : `player` dans des scripts globaux (car `player` est différent sur chaque machine ou inexistant sur un serveur dédié).
*   **UTILISER PLUTÔT** : 
    *   `allPlayers` : Retourne tous les joueurs humains.
    *   `playableUnits` : Retourne toutes les unités jouables (y compris IA si slots non utilisés).

### Création de Tâches (Task Framework)
Utilisez toujours les fonctions BIS pour créer des tâches côté serveur. Elles gèrent automatiquement la synchronisation.

```sqf
[
    west,                   // Équipe concernée
    "task_obj1",            // ID de la tâche
    ["STR_TASK_DESC", "STR_TASK_TITLE", ""], // Textes (clés stringtable)
    getMarkerPos "obj_1",   // Position
    "ASSIGNED",             // État initial
    1,                      // Priorité
    true                    // Notification à l'écran
] call BIS_fnc_taskCreate;
```

---

## 3. Support Multilingue (Internationalisation)

> **Règle Principale** : **ZÉRO texte en dur** dans les scripts (.sqf). Utilisez obligatoirement `stringtable.xml`.

Cela permet une traduction automatique selon la langue du jeu du client.

### Structure `stringtable.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project name="MyMission">
    <Package name="General">
        <Key ID="STR_MISSION_NAME">
            <English>Silent Dawn</English>
            <French>Aube Silencieuse</French>
            <Turkish>Sessiz Şafak</Turkish>
        </Key>
        <Key ID="STR_TASK_TITLE">
            <English>Secure the area</English>
            <French>Sécuriser la zone</French>
            <Turkish>Bölgeyi güvene alın</Turkish>
        </Key>
        <Key ID="STR_TASK_DESC">
            <English>Eliminate enemy presence.</English>
            <French>Éliminez toute présence ennemie.</French>
            <Turkish>Düşman varlığını yok edin.</Turkish>
        </Key>
    </Package>
</Project>
```

---

## 4. Structure des Fichiers

Une organisation rigoureuse est essentielle pour la maintenance.

```text
maMission.Altis/
├── mission.sqm          # Fichier éditeur principal (placement objets/unités)
├── description.ext      # Configuration générale (Respawn, Paramètres, Sounds)
├── stringtable.xml      # Base de données des traductions
├── init.sqf             # Script d'initialisation global (exécuté partout)
├── initPlayerLocal.sqf  # Script exécuté uniquement chez le joueur (JIP compatible)
├── initServer.sqf       # Script exécuté uniquement sur le serveur
└── scripts/             # Dossier stockage des scripts
    ├── objectifs.sqf    # Logique de création/gestion des objectifs
    ├── spawn_ennemis.sqf# Scripts de spawn dynamique d'IA
    └── fin_mission.sqf  # Conditions de victoire/défaite
```

---

## 5. Checklist de Compatibilité SP/COOP

Avant de publier, vérifiez que votre code respecte ces points :

- [ ] J'utilise `isServer` pour toute logique critique (Spawn, Création Tâches, Score).
- [ ] J'utilise `hasInterface` pour tout ce qui est visuel/sonore local.
- [ ] J'utilise `remoteExec` pour exécuter du code sur une autre machine si nécessaire.
- [ ] J'utilise `publicVariable` pour synchroniser des variables importantes entre serveur et clients.
- [ ] J'utilise `addEventHandler` pour les événements liés aux unités (compatible MP).
- [ ] Je privilégie les fonctions `BIS_fnc_*` qui sont généralement optimisées pour le réseau.
