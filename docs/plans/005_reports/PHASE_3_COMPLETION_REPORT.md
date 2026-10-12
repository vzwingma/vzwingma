# Phase 3 : Skills & instructions natifs

**Plan :** `.claude/plans/005_claude-first.plan.md`
**Responsable Agent :** 🔵 DEVon
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — validation 👤 en attente

---

## 📝 Tâches

### T3.1 - Skills d'activation

**Statut :** ✅ DONE

| Skill | Mode | Exécution |
|---|---|---|
| `/arcos`, `/devon`, `/qalvin`, `/docly` | `disable-model-invocation: true` | `context: fork` + `agent: <X>` + `background: false` ; corps = `$ARGUMENTS` + consignes (demande vide, `❓ Questions pour 👤`) |
| `/maina` | `disable-model-invocation: true` | **inline** : la session courante adopte le protocole MAINa (gates via `AskUserQuestion`) — corrige C2 sans remplacer le prompt système |
| `/maina-help` | `disable-model-invocation: true` | Aide réécrite : lancement MAINa, 5 agents, gates #0→#4, commandes |

- Variante Copilot dans `SKILL.copilot.md` (prose d'activation) → le prompt forké côté Claude reste pur.
- Effet contexte : ces 6 skills ne chargent plus leur description à chaque tour (déclenchement utilisateur uniquement).

### T3.2 - Skills procéduraux

**Statut :** ✅ DONE
- `plan-creation`, `plan-phase-execution`, `adr-writing` : `user-invocable: false`, `applyTo` retiré, descriptions honnêtes (« préchargé par … » au lieu de « appliqué automatiquement »).
- Modèles en fichiers support : `plan-creation/templates/plan.template.md` (avec **journal des gates**), `plan-phase-execution/templates/phase-report.template.md` (preuves, `❓ Questions pour 👤`).
- `plan-creation` : Gate #0 prérequis, Gate #1 formalisé, prompt de lancement avec section questions. `plan-phase-execution` : vérif gate précédent `GO`, preuves obligatoires, cas agent lecture seule (ARCos).
- `.claude/PLANS.md` réécrit (497 → ~140 lignes) : formats renvoyés vers les modèles, cycle de vie avec gates, exemple fictif « AP-001 Modernisation 🔄 » (M1) remplacé par les plans réels 004 / 005.

### T3.3 - Skills transverses

**Statut :** ✅ DONE (avec écart)
- `fleet-guide` → **`parallel-guide`** (`git mv`, Claude + Copilot) : appels `Agent` parallèles dans un même message, `isolation: worktree`, arrière-plan ; jamais à travers un gate ; `/fleet` uniquement en bloc `copilot-only`.
- **Supprimés** (`git rm`, prévus au plan) : `caveman-default` (doublon du plugin caveman + section CLAUDE.md), `compact-context` (→ section « 🗜️ Compact instructions » de `CLAUDE.md`). Miroirs `.github/` retirés en même temps.
- **Écart** : `safety-rules` et `copilotignore` **conservés** jusqu'à P4 (garde-fous déterministes) pour ne pas créer de trou de sécurité ; frontmatter corrigé (`applyTo` retiré, `user-invocable: false`, description renvoyant à `CLAUDE.md` § Règles absolues).

### T3.4 - Conventions projet → skills `conventions-<rôle>`

**Statut :** ✅ DONE
- `.claude/instructions/*.instructions.template.md` → `.claude/skills/conventions-{orchestrator,architect,dev,qa,doc}/SKILL.md` (`git mv`, historique conservé), `user-invocable: false`.
- **Préchargés** par chaque agent (`skills:` — T2.2 complété). Sections « Spécificités projet » des agents : bloc `claude-only` (skill préchargé) + `copilot-only` (lecture du fichier d'instructions).
- **Fuites projet neutralisées (M5)** : Expo/React Native, « TypeScript strict », `call('GET', …'{{}}')`, `useContext`, `schemas/*.puml`, `[ANCIEN_NOM_REPO]`, « agent partenaire backend », table d'agents incomplète → placeholders génériques ; exemples React conservés uniquement en **commentaire illustratif**. Ajout des commandes de vérification (`[COMMANDE_BUILD]`, `[COMMANDE_LINT]`, `[COMMANDE_TEST]`) et du seuil de couverture.
- Copilot : générés vers `.github/instructions/<rôle>.instructions.template.md` (frontmatter `applyTo: "**"`, format natif Copilot).

### T3.5 - Prompts → skills

**Statut :** ✅ DONE
- `init-copilot-instructions.prompt.md` → skill **`init-harness`** ; `update-copilot-instructions.prompt.md` → skill **`update-harness`** (`git mv`, Claude + Copilot ; `disable-model-invocation: true`, `argument-hint`, `$ARGUMENTS`).
- `init-harness` absorbe le cas « projet existant / ancien format » (`migrate-to-template`, jamais créé) : fusion de `CLAUDE.md`, reprise des anciens `.claude/instructions/*.instructions.md`.
- Toutes les références `migrate-to-template` et `init/update-copilot-instructions` retirées (hors historique).

### Correctifs associés (hors tâches)

- **Générateur** (`scripts/Sync-Description.psm1`, `sync-claude-to-github.ps1`) : `SKILL.copilot.md` prioritaire pour Copilot ; `conventions-*` → `.github/instructions/` (`New-CopilotInstructionContent`, `Sync-InstructionFile`).
- **Packaging** : `package-claude.ps1` / `package-github.ps1` ne copient plus `instructions/` ni `prompts/` (dossiers disparus → échec) ; `package-github.ps1` : garde `Test-Path` sur `.agents/` (bug préexistant : échec dans un clone propre).
- **Docs alignées** : `.claude/CLAUDE.md` (conventions, table skills, commandes, compact instructions), `CLAUDE.template.md` (idem + lien diagramme cassé corrigé, m5), `.claude/README.md`, `QUICK_START_CLAUDE.md` (copie, `/init-harness`, FAQ, checklist), `docs/ARCHITECTURE.md` **réécrit** (Claude-first, agents/modèles, catégories de skills, templates, invariants plateforme, historique v5.0) — T6.2 anticipé pour ce fichier.
- **CHANGELOG** : entrées AP 005 complétées (P2-P3), versions d'agents inchangées (initiative non livrée).

---

## 📊 Synthèse de Phase

**Tâches complétées :** 5/5
**Critères de réussite :**
- ✅ 0 `applyTo` dans `.claude/skills/`
- ✅ 0 `/fleet` dans `.claude/` hors bloc `copilot-only`
- ✅ 0 fuite projet dans les templates

**Preuves :**
- Validation frontmatter (script PowerShell) : 19 skills — champs ⊂ champs documentés, `name` = dossier, `agent:` des forks existant ; 5 agents — skills préchargés tous présents.
- `sync-claude-to-github.ps1 -Check` : exit 0, 0 orphelin ; `.github/` sans `claude-only`/`copilot-only`/`$ARGUMENTS`/`context: fork`/`claude --agent`.
- `package-claude.ps1` et `package-github.ps1` : ZIP générés sans erreur (68,6 KB / 61,7 KB, sortie dans `%TEMP%`).
- ⚠️ **Non testé en runtime** (CLI headless non authentifiée) : à vérifier par 👤 — `/devon test` lance bien DEVon forké, `/maina` bascule la session, `/agents` affiche les skills préchargés.

**Bloqueurs :** Aucun

**Points d'attention :**
- Dossiers vides non suivis laissés sur disque : `.claude/instructions/`, `.claude/prompts/`, `.github/prompts/`, `.github/plans/`.
- `copilot-instructions.md` (généré depuis `CLAUDE.md`) mentionne encore `conventions-<rôle>` dans le tableau des skills → à traiter lors de l'allègement de `CLAUDE.md` (T6.2).
- `CLAUDE.md` passe à ~290 lignes → allègement ≤ 200 l. en P6.
- `SETUP_CHECKLIST.md` (orienté `.github/`, références aux prompts) et diagrammes (`/fleet`) → P6.

**❓ Questions pour 👤 :** aucune.
**Prochaine phase :** P4 (garde-fous déterministes : settings + hooks) — après validation 👤.
