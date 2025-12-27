# 🛠️ Guide de Conception de Mission Arma 3 : Randomisation & Standards

Ce document détaille les instructions pour créer une mission immersive, rejouable et compatible à la fois en Singleplayer (SP) et en Coopératif (COOP).

---

### Types d’objectifs de mission

- Extraction de VIP : Escorter un officier, scientifique ou informateur jusqu’à la base alliée.

- Récupération de personnel isolé : Secourir un prisonnier de guerre derrière les lignes ennemies.
- Assassinat et récupération de documents : Éliminer un officier ennemi de haut rang. + récuperation de documents dans son inventaire.
- Chasse à l’homme (HVT) : Traquer un commandant ennemi mobile entre plusieurs bases ou convois.
- Suppression de défenses : Neutraliser un radar anti-aérien pour permettre un soutien aérien allié.
- Destruction de convoi : Détruire un convoi de ravitaillement ou des véhicules ennemis lourds.
- Reconquête : Reprendre une base alliée (QG ennemie) tombée aux mains de l’ennemi.
- Récupération de renseignements : Infiltrer un QG ennemi pour pirater un ordinateur.
- Enquête mystérieuse : Explorer un laboratoire secret pour comprendre une anomalie.
- defendre le QG allié : Si l'officier meurt, la partie est perdue.

**Options de mission**

- drone de reconnaissance (affiche les positions des unités ennemies)
- présence de tank ennemi 
- soutien aérien allié
- présence civile

**Besoins :** 
 - Officier allié
 - Officier ennemi avec documents
 - Officier ennemi mobile
 - QG ennemi (avec ordinateur à pirater)
 - QG allié
 - Radar anti-aérien
 - Convoie ennemie
 - laboratoire secret

## 2. Bonnes Pratiques de Codage (SP/COOP)

> **La Règle d'Or** : Codez toujours pour le **COOP**. Si cela fonctionne en multijoueur, cela fonctionnera automatiquement en solo.

### Gestion Serveur vs Client
En SP, votre machine est à la fois serveur et client. En COOP, ces rôles sont séparés.
*   `isServer` : Vrai sur la machine locale en SP, vrai uniquement sur le serveur dédié/hôte en MP.

### 🚫 Attention particulière
*   **NE JAMAIS UTILISER** : `player` dans des scripts globaux (car `player` est différent sur chaque machine ou inexistant sur un serveur dédié).
*   **UTILISER PLUTÔT** : 
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



---



---

## 5. Checklist de Compatibilité SP/COOP

Avant de publier, vérifiez que votre code respecte ces points :

- [ ] J'utilise `isServer` pour toute logique critique (Spawn, Création Tâches, Score).
- [ ] J'utilise `hasInterface` pour tout ce qui est visuel/sonore local.
- [ ] J'utilise `remoteExec` pour exécuter du code sur une autre machine si nécessaire.
- [ ] J'utilise `publicVariable` pour synchroniser des variables importantes entre serveur et clients.
- [ ] J'utilise `addEventHandler` pour les événements liés aux unités (compatible MP).
- [ ] Je privilégie les fonctions `BIS_fnc_*` qui sont généralement optimisées pour le réseau.
