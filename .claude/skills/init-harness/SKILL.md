---
name: init-harness
description: "Initialise le harnais multi-agents dans un projet (nouveau ou existant) : analyse du code, CLAUDE.md depuis le template, conventions par rôle, docs/ARCHITECTURE.md. Usage : /init-harness [type de projet ou consignes]."
argument-hint: "[type de projet ou consignes]"
disable-model-invocation: true
---

# Initialisation du harnais multi-agents

Consignes de l'utilisateur (optionnel) : $ARGUMENTS

> **Prérequis** (copiés depuis le dépôt transverse) : `.claude/agents/` (5 agents), `.claude/skills/`,
> `.claude/PLANS.md`, `.claude/CLAUDE.template.md`, `docs/ARCHITECTURE.template.md`, `docs/adr/ADR-TEMPLATE.md`.
> Absents → lister les fichiers manquants et s'arrêter.

## 1. Détecter l'état du projet

- **Nouveau** : pas de `.claude/CLAUDE.md` → partir de `.claude/CLAUDE.template.md`.
- **Existant** : `.claude/CLAUDE.md` présent → **conserver** ses sections projet, ne remplacer que les
  sections génériques (agents, workflow, plans) par celles du template.
- **Ancien format** : fichiers `.claude/instructions/*.instructions.md` présents → reprendre leurs valeurs
  dans les conventions par rôle (étape 4), puis signaler à 👤 que ces fichiers peuvent être retirés.

## 2. Analyser le projet

Identifier, **depuis le code réel** (jamais d'hypothèse) :
- structure (dossiers principaux), langage(s), framework(s), type de projet, plateformes cibles ;
- gestion d'état, couches, patterns architecturaux ;
- conventions observées : nommage, imports, style, gestion d'erreurs, tests ;
- commandes : build, lint, tests (manifestes, Makefile, scripts CI).

Sources utiles : `README.md`, manifestes de dépendances, config lint/format, CI, `CONTRIBUTING.md`,
`docs/` existants.

## 3. Générer `.claude/CLAUDE.md`

1. Copier le template (ou fusionner, cas existant).
2. Remplacer chaque placeholder `[...]` par la valeur observée.
3. Supprimer les sections `[📌 SECTION À COMPLÉTER : …]` une fois remplies.
4. Conserver intactes les sections génériques (agents, workflow, plans d'action).

## 4. Remplir les conventions par rôle

<!-- claude-only -->
Remplir les placeholders des 5 skills de conventions, préchargés par chaque agent :

| Skill | Agent | Valeurs clés |
|---|---|---|
| `.claude/skills/conventions-orchestrator/SKILL.md` | ⚫ MAINa | commandes de vérification, règles d'orchestration propres au projet |
| `.claude/skills/conventions-architect/SKILL.md` | 🟠 ARCos | couches, état partagé, accès données, routage, bibliothèques autorisées |
| `.claude/skills/conventions-dev/SKILL.md` | 🔵 DEVon | stack + versions, commandes build/lint/test, nommage, patterns |
| `.claude/skills/conventions-qa/SKILL.md` | 🟢 QALvin | framework de test, commandes, mocks, seuil de couverture |
| `.claude/skills/conventions-doc/SKILL.md` | 🟣 DOCly | fichiers de doc, langue, changelog, diagrammes |

Remplacer aussi `[NOM_DU_PROJET]` dans le `description` du frontmatter. Retirer la mention « Template »
une fois tous les placeholders remplis.
<!-- /claude-only -->
<!-- copilot-only
Créer les fichiers d'instructions par rôle depuis les templates `.github/instructions/*.instructions.template.md` :
`orchestrator`, `architect`, `dev`, `qa`, `doc` → `.github/instructions/<rôle>.instructions.md` (sans `.template`),
puis remplir leurs placeholders avec les valeurs de l'étape 2.
-->

Valeur non déterminable depuis le code → conserver le placeholder et le signaler.

## 5. Documentation de base

- `docs/ARCHITECTURE.md` absent → le créer depuis `docs/ARCHITECTURE.template.md` et le remplir.
- `docs/adr/` absent → le créer avec `ADR-TEMPLATE.md`.
- `.claude/plans/README.md` absent → créer l'index des plans (vide).

## 6. Livrer

Résumer : fichiers créés/modifiés, valeurs détectées (avec leur source), **placeholders restants**,
points à valider par 👤.

## ✅ Checklist

- [ ] `.claude/CLAUDE.md` créé ou fusionné, sections génériques intactes
- [ ] Conventions des 5 rôles remplies (placeholders restants listés)
- [ ] Commandes build/lint/test réelles renseignées
- [ ] `docs/ARCHITECTURE.md` et `docs/adr/` présents
- [ ] Aucune référence à un fichier inexistant
- [ ] Langue française pour le texte narratif
