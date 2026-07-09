---
description: Spécificités projet [NOM_DU_PROJET] pour l'agent ARCos (architect)
applyTo: "**"
---

# Spécificités projet — [NOM_DU_PROJET]

> Fichier auto-lu par agent 🟠 ARCos au démarrage.
> Contient spécificités projet `[NOM_DU_PROJET]` ([DESCRIPTION_COURTE_DU_PROJET], ex: frontend React/TypeScript).
>
> **Template** : copier en `architect.instructions.md` (retirer `.template`) et remplir les
> placeholders `[...]` pour activer cette couche. Non instancié → agent applique le générique.

## Lecture du document d'architecture

**Au démarrage**, lis `docs/ARCHITECTURE.md` si existe dans projet courant :
- Comprendre stack technique, couches applicatives, composants clés
- Assurer cohérence décisions planification avec architecture existante
- Si absent, suggérer à 🟣 DOCly création au terme initiative

## Conventions architecturales

- **Couches** : `[COUCHE_UI]/` (UI) → `[COUCHE_ETAT]/` (état global) → `[COUCHE_HTTP]/` (HTTP) → `[COUCHE_UTILS]/` (constantes, helpers).
- **État global** : uniquement via `[PROVIDER_ETAT_GLOBAL]`. Pas créer de nouveau conteneur d'état global (ex: React Context, store) sans validation.
- **HTTP** : toujours via `[SERVICE_HTTP]`. Pas utiliser `fetch` direct dans composant.
- **Routing** : `[STRATEGIE_ROUTING]`. Nouvelles routes s'ajoutent dans `[FICHIER_ROUTES]`.
- **Pas bibliothèque state management externe** sans décision architecturale explicite.
- **UI** : `[LIBRAIRIE_UI]` uniquement. Pas introduire autre bibliothèque UI.

## Documentation des décisions architecturales (ADR)

Chaque décision architecturale majeure doit produire fichier ADR dans `docs/adr/` :

- **Nommage** : `docs/adr/NNN-titre-court.md` (ex: `docs/adr/001-choix-framework-ui.md`)
- **Contenu minimal** : contexte, décision prise, alternatives considérées, conséquences
- **Quand créer ADR** : nouveau framework, changement pattern architectural, décision sécurité, choix structure majeur
- Déléguer création ADR à 🟣 DOCly après validation décision

## Handoff vers MAINa (pas de création de plan par ARCos)

ARCos **n'écrit pas** de tâches ni de base SQL. Livrer à MAINa :

- analyse comparative (≥ 2 options) + recommandation motivée ;
- découpage **candidat** (tâches logiques + dépendances + effort) comme **entrée** au Plan d'Action.

MAINa formalise le Plan d'Action (`.opencode/plans/`) et orchestre la délégation. ARCos exécute ensuite
les tâches `T*.*` qui lui sont assignées (skill `plan-phase-execution`).

## Interactions avec l'agent partenaire ([NOM_PROJET_PARTENAIRE])

- Contrats API (URL, paramètres, codes retour) définis en coordination avec Architecte [ROLE_PARTENAIRE, ex: backend].
- URLs µServices configurées dans `[FICHIER_CONSTANTES_TECHNIQUES]` et fichiers `.env.*`.
- Tout nouveau endpoint [PARTENAIRE] doit être reflété dans `[SERVICE_HTTP]` avant que agent Dev puisse utiliser.

## Agents du projet

| Icône | Nom      | Fichier agent          | Rôle                          |
|-------|----------|------------------------|-------------------------------|
| 🔵    | DEVon    | `Devon.agent.md`         | Implémentation [STACK_PRINCIPALE] |
| 🟢    | QALvin  | `Qalvin.agent.md`          | Tests unitaires ([FRAMEWORK_TEST]) |
| 🟣    | DOCly    | `Docly.agent.md`         | Documentation (README, /docs) |


## Règle d'index des plans (obligatoire)

- Fichier `.opencode/plans/README.md` est **index synthétique** : doit contenir uniquement liste plans et leur **statut global**.
- Pas afficher statuts phases.
- Toute création plan ou changement statut global doit inclure, dans même changement, mise à jour `.opencode/plans/README.md`.