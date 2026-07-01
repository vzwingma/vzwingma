---
description: Spécificités projet [NOM_DU_PROJET] pour l'agent 🟣 DOCly (doc)
applyTo: "**"
---

# Spécificités projet — [NOM_DU_PROJET] (Doc)

> Fichier lu automatiquement par agent 🟣 DOCly au démarrage.
> Contient spécificités projet `[NOM_DU_PROJET]` ([DESCRIPTION_COURTE_DU_PROJET], ex: frontend React/TypeScript).
>
> **Template** : copier en `doc.instructions.md` (retirer `.template`) et remplir les placeholders
> `[...]` pour activer cette couche. Non instancié → agent applique le générique.

## Workflow

1. Récupère tes tâches (`🟣 DOCly` / `Agent: DOCly`) dans le **Plan d'Action** actif, après code + tests validés.
2. Identifie fichiers doc impactés (lire rapports DEVon + QALvin).
3. Update précis (pas réécriture complète sauf si nécessaire).
4. Signale la complétion (rapport `PHASE_N_*.md`).

Procédure détaillée : skill `plan-phase-execution`.

## Fichiers sous ta responsabilité

### Dans la racine du projet
- `README.md` – description générale, prérequis, démarrage rapide
- `.opencode/instructions/*.instructions.md` – contexte futures sessions OpenCode

### Dans `docs/` (documentation versionnée)
- `docs/ARCHITECTURE.md` (**obligatoire**) – architecture projet (stack, structure, couches, flux données)
- `docs/adr/` – Architecture Decision Records produits par ARCos (ex: `docs/adr/001-choix-framework.md`)
- `[FICHIER_HISTORIQUE].md` – nouvelles versions à documenter
- `[FICHIER_DEPLOIEMENT].md` – procédures déploiement [PLATEFORME_DEPLOIEMENT]
- `schemas/*.puml` – diagrammes PlantUML C2/C3 (versions frameworks à maintenir)

### Dans `.opencode/skills/` (procédures partagées)
- `plan-phase-execution/SKILL.md` – procédure d'exécution de phase AP
- `plan-creation/SKILL.md` – procédure de création de plan
- `fleet-guide/SKILL.md` – guide /fleet

> Update fichiers si procédures AP ou /fleet changent (cohérence avec `.opencode/PLANS.md`).

## Conventions de documentation

- **Langue** : français pour contenu, anglais pour blocs code.
- **`docs/ARCHITECTURE.md` est obligatoire** : tout projet doit avoir fichier décrivant architecture.
- **ADRs** : chaque décision architecturale majeure produit fichier `docs/adr/NNN-titre.md`.
- **Versions à maintenir à jour** dans `.puml` : [FRAMEWORK_FRONTEND] (actuellement **[VERSION_FRONTEND]**), [FRAMEWORK_BACKEND] (actuellement **[VERSION_BACKEND]**).
- **Ne jamais** mentionner ancien nom repo `[ANCIEN_NOM_REPO]` – désormais `[NOM_REPO_ACTUEL]`.
- Nouvelle version livrée, ajouter entrée dans `[FICHIER_HISTORIQUE].md` **en tête** fichier.
- Index `.opencode/plans/README.md` doit rester synthétique : **plans + statut global uniquement** (sans phases).

## Ce que tu ne fais PAS

- Pas modifier code source (`*.[tsx|ts|js|py|...]`).
- Pas créer nouveaux tests (rôle 🟢 QALvin).
- Pas prendre décisions architecturales (rôle 🟠 ARCos).