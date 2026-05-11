---
description: Spécificités projet [NOM_DU_PROJET] pour l'agent 🟣 DOCly (doc)
applyTo: "**"
---

# Spécificités projet — [NOM_DU_PROJET] (Doc)

> Ce fichier est lu automatiquement par l'agent 🟣 DOCly au démarrage.
> Il contient uniquement les spécificités du projet `[NOM_DU_PROJET]` ([DESCRIPTION_COURTE_DU_PROJET], ex: frontend React/TypeScript).

## Workflow

1. Consulte les todos `*-doc` dont les dépendances sont `done`.
2. Passe le todo en `in_progress`.
3. Identifie les fichiers de documentation impactés.
4. Mets à jour avec précision (pas de réécriture complète sauf si nécessaire).
5. Passe en `done`.

## Fichiers sous ta responsabilité

### Dans la racine du projet
- `README.md` – description générale, prérequis, démarrage rapide
- `.github/copilot-instructions.md` – contexte pour les futures sessions Copilot

### Dans `docs/` (documentation versionnée)
- `docs/ARCHITECTURE.md` (**obligatoire**) – architecture du projet (stack, structure, couches, flux de données)
- `docs/adr/` – Architecture Decision Records produits par ARCos (ex: `docs/adr/001-choix-framework.md`)
- `[FICHIER_HISTORIQUE].md` – nouvelles versions à documenter ici
- `[FICHIER_DEPLOIEMENT].md` – procédures de déploiement [PLATEFORME_DEPLOIEMENT]
- `schemas/*.puml` – diagrammes PlantUML C2/C3 (versions des frameworks à maintenir à jour)

### Dans `.github/skills/` (procédures partagées)
- `plan-phase-execution.skill.md` – procédure d'exécution de phase AP
- `plan-creation.skill.md` – procédure de création de plan
- `fleet-guide.skill.md` – guide /fleet

> Mettre à jour ces fichiers si les procédures AP ou /fleet changent (cohérence avec `.github/PLANS.md`).

## Conventions de documentation

- **Langue** : français pour le contenu, anglais pour les blocs de code.
- **`docs/ARCHITECTURE.md` est obligatoire** : tout projet doit avoir ce fichier décrivant l'architecture.
- **ADRs** : chaque décision architecturale majeure produit un fichier `docs/adr/NNN-titre.md`.
- **Versions à maintenir à jour** dans les `.puml` : [FRAMEWORK_FRONTEND] (actuellement **[VERSION_FRONTEND]**), [FRAMEWORK_BACKEND] (actuellement **[VERSION_BACKEND]**).
- **Ne jamais** mentionner l'ancien nom de repo `[ANCIEN_NOM_REPO]` – c'est désormais `[NOM_REPO_ACTUEL]`.
- Quand une nouvelle version de l'application est livrée, ajouter une entrée dans `[FICHIER_HISTORIQUE].md` **en tête** de fichier.
- L'index `.github/plans/README.md` doit rester synthétique : **plans + statut global uniquement** (sans phases).

## Ce que tu ne fais PAS

- Ne modifie pas le code source (`*.[tsx|ts|js|py|...]`).
- Ne crée pas de nouveaux tests (rôle de 🟢 QUALvin).
- Ne prends pas de décisions architecturales (rôle de 🟠 ARCos).

