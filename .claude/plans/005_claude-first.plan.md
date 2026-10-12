# Plan d'Action 005 — Refonte « Claude-first » du harnais multi-agents

**Document :** `.claude/plans/005_claude-first.plan.md`
**Date de création :** 2026-10-12
**Statut :** 🔄 En cours — P0 ✅, P1 ✅, P2 ✅, P3 ✅, P4 ✅, P5 ✅, P6 🔄, P7 ⏳ Planifié
**Objectif Prioritaire :** HIGH
**ADR associé :** [`docs/adr/003-claude-first-copilot-genere.md`](../../docs/adr/003-claude-first-copilot-genere.md)

> Document **double** : (1) analyse critique de l'existant (revue 3 mois après AP 004),
> (2) plan d'amélioration en 7 phases. Gate humain 👤 obligatoire après chaque phase.

---

## 🎯 Objectif Global

AP 004 (2026-06-30) a corrigé la cohérence documentaire, mais **sans aligner le harnais sur les
mécanismes natifs de Claude Code**. Le harnais reste un portage de conventions Copilot (`applyTo`,
`agents:`, `/fleet`, `.prompt.md`, `.copilotignore`) dont une partie est **ignorée silencieusement**
par Claude Code. 3 mois après, la dérive documentaire est revenue.

Objectifs : agents et skills **natifs Claude Code**, garde-fous **déterministes** (settings + hooks),
gates humains **réellement exécutables**, **source unique** `.claude/` avec Copilot généré,
OpenCode retiré, **contrôle automatique anti-dérive**.

### Décisions 👤 de cadrage (Gate #0 — 2026-10-12)

| Sujet | Décision |
|---|---|
| Multi-plateforme | **Claude-first** : `.claude/` = source unique. `.github/` (Copilot) **généré depuis Claude**. **OpenCode décommissionné → supprimé** |
| Distribution | **ZIP + copie manuelle** conservés (contenu à corriger) |
| Rigueur workflow | **Gates stricts partout** (Gate #0→#4), mécanique fiabilisée |

---

## 🔍 Analyse critique

### ✅ Points forts (à conserver)
- Format Plan d'Action (phases, `T<N>.<M>`, critères mesurables, rapports) solide.
- Séparation agents génériques / instructions projet / templates.
- Discipline ADR (template, skill `adr-writing`) ; rigueur AP 004.
- Module `scripts/Sync-Description.psm1` propre (dry-run, UTF-8 sans BOM, préservation frontmatter).

### 🔴 Critiques

| ID | Constat | Preuve |
|---|---|---|
| C1 | **Frontmatter agents inopérant** : `applyTo`, `agents` = champs Copilot ignorés par Claude Code. Aucun `tools`/`model` → zéro cloisonnement (ARCos peut éditer du code, DOCly lancer Bash), modèle hérité. Régression vs CHANGELOG « frontmatter Claude conservé (model, tools) ». | `.claude/agents/*.agent.md:1-6`, `.claude/CHANGELOG.md:32` |
| C2 | **Gates humains infaisables via `/maina`** : le skill lance MAINa en subagent ; Claude Code retire `AskUserQuestion` de tout subagent → MAINa ne peut pas tenir un gate. | `.claude/skills/maina/SKILL.md:13` |
| C3 | **Garde-fous « absolus » purement déclaratifs** : `safety-rules` / `copilotignore` reposent sur `applyTo: **` (inexistant côté Claude → chargés seulement si le modèle le décide). Aucun `.claude/settings.json` (deny), aucun hook PreToolUse. `.copilotignore` inconnu de Claude Code. | `.claude/skills/safety-rules/`, `.claude/skills/copilotignore/` |
| C4 | **Source de vérité contradictoire** : ADR 002 = `.github/` source unique, mais 5 scripts de sync bidirectionnels + commits récents « sync claude to github ». Bootstrap `Sync-StructuredFile` recopie le frontmatter Copilot dans la cible. Substitution naïve `Claude→Copilot`. | `docs/adr/002-…md`, `scripts/Sync-Description.psm1` |

### 🟠 Majeurs

| ID | Constat | Preuve |
|---|---|---|
| M1 | **Dérive récidivante** : ARCHITECTURE MAINa v1.3 (réel v1.4) ; « 9 skills » (réel 14) ; « 4 fichiers instructions » (réel 5) ; init prompt « 4 skills » ; `migrate-to-template` référencé ×4 mais inexistant ; exemple PLANS.md « AP-001 Modernisation 🔄 » faux ; F-m2 et F-m4 (AP 004) jamais corrigés. Cause : compteurs/versions dupliqués à la main, aucun contrôle auto. | `docs/ARCHITECTURE.md`, `QUICK_START_CLAUDE.md`, `Devon.agent.md:25`, `Qalvin.agent.md:168` |
| M2 | **Artefacts Copilot dans l'arbre Claude** : `/fleet` (~15 fichiers) ; prompts `.prompt.md` (`agent: agent`, tools `read_file`…) non exécutables ; QUICK_START `/agent MAINa`. | `fleet-guide/`, `.claude/prompts/`, `QUICK_START_CLAUDE.md` |
| M3 | **Skills mal paramétrés** : 6 skills d'activation/aide auto-invocables ; activation en prose au lieu de `context: fork` + `agent:` + `$ARGUMENTS` ; procédures non préchargées (`skills:`) ; descriptions « Appliqué automatiquement » fausses. | `.claude/skills/{maina,arcos,devon,qalvin,docly,maina-help}/` |
| M4 | **Instructions projet chargées par « lis au démarrage »** (non déterministe). Natifs : `skills:` preload, `.claude/rules/` + `paths`, `@import`. | §« Spécificités projet » des 5 agents |
| M5 | **Templates fuitent un projet réel** : Expo/React Native, TypeScript strict, `call('GET', …'{{}}')`, `schemas/*.puml`, `[ANCIEN_NOM_REPO]`, agent partenaire backend. | `.claude/instructions/*.template.md` |
| M6 | **Package Claude incohérent** : livre `CLAUDE.md` du dépôt mais pas `CLAUDE.template.md` ; `docs/adr/ADR-TEMPLATE.md` exclu (copie non récursive) ; `SETUP_CHECKLIST.md` = version Copilot ; dépendance caveman non déclarée. | `scripts/package-claude.ps1` |
| M7 | **Plans éclatés** : `.github/plans` (001-003), `.claude/plans` (004), `.opencode/plans` (001, collision). | `.claude/plans/README.md` |
| M8 | **Qualité/rôles non outillés** : pas de revue code/sécurité avant Gate #2 ; DEVon sans preuve exigée ; frontières de rôle déclaratives ; `adr-writing` impose « Acceptée » avant le gate. | `Devon.agent.md`, `adr-writing/SKILL.md` |
| M9 | **Handoff libre** : pas de schéma (phase, fichiers, preuves, risques, décision) ; pas de journal des gates. | `Maina.agent.md`, `Devon.agent.md` |
| M10 | **Gates stricts vs parallélisme** : QALvin ∥ DOCly autorisé après Gate #2 alors que DOCly doit attendre Gate #3. | `CLAUDE.md`, `fleet-guide/SKILL.md`, `Devon.agent.md:30` |
| M11 | **Tooling non testé, pas de CI.** | `scripts/` |
| M12 | **Budget contexte** : `CLAUDE.md` > 200 l. (cible doc), fiches agents répétées, versions dupliquées ×4, `[vX.Y]` dans descriptions. | `CLAUDE.md`, `CLAUDE.template.md` |

### 🟡 Mineurs
- **m1** Accents absents (descriptions, corps MAINa) ; nommage mixte DEVon/Devon/DEV/QUAL.
- **m2** `compact-context` : refs `sdlc-*`, `usage_input_tokens` inexact → section « Compact instructions » CLAUDE.md.
- **m3** `caveman-default` doublonne plugin caveman + section CLAUDE.md.
- **m4** Modèles figés/obsolètes (Sonnet 4.6, Haiku 4.5, GPT-5.3-Codex, GPT-5 mini) ; tools `vscjava` dans DEVon Copilot.
- **m5** `CLAUDE.template.md` lien `../README.md#-workflow-typique` cassé après copie ; `docs/diagrams/` non référencés.
- **m6** `.vscode/tasks.json` tâches OpenCode ; README racine = profil GitHub.

---

## 🛠️ Phases

### Phase 0 — Formalisation — ✅ TERMINÉE (2026-10-12)
**Contexte :** règle MAINa (plan + ADR + index dans le même lot).
**Critères :** ✅ AP 005 persisté ✅ ADR 003 créé ✅ ADR 002 « Remplacée par 003 » ✅ index MAJ.

#### T0.1 - Créer le Plan d'Action 005
- **Agent :** ⚫ MAINa
- **Fichier(s) :** `.claude/plans/005_claude-first.plan.md`, `.claude/plans/005_reports/`, `.claude/plans/README.md`
- **Acceptation :** fichiers présents, 005 listé « 🔄 En cours »

#### T0.2 - Rédiger ADR 003
- **Agent :** 🟣 DOCly (contenu 🟠 ARCos)
- **Fichier(s) :** `docs/adr/003-claude-first-copilot-genere.md`, `docs/adr/002-claude-miroir-genere.md` (statut)
- **Acceptation :** ADR 003 « Proposée » jusqu'au Gate P0 ; ADR 002 pointe vers 003

---

### Phase 1 — Source unique Claude + décommission OpenCode — ✅ TERMINÉE (2026-10-12)
**Contexte :** C4, M7. Prérequis de toutes les autres phases.
**Critères :** ✅ 1 seul script de sync (`claude→github`) ✅ `-Check` idempotent (exit 0, 0 changement) ✅ 0 réf OpenCode hors archive/ADR/historique.
**Rapport :** [`005_reports/PHASE_1_COMPLETION_REPORT.md`](005_reports/PHASE_1_COMPLETION_REPORT.md)

#### T1.1 - Retirer OpenCode et scripts obsolètes
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `.opencode/`, `QUICK_START_OPENCODE.md`, `scripts/package-opencode.ps1`, `scripts/sync-*opencode*.ps1`, `scripts/sync-github-to-claude.ps1`, `.vscode/tasks.json`
- **Implémenter :** `git rm` **uniquement après go explicite 👤 au gate** (exception assumée à la règle « jamais supprimer » ; réversible via historique git)
- **Acceptation :** fichiers retirés de l'index git, tâches VS Code nettoyées

#### T1.2 - Consolider les plans
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `.github/plans/001-003*`, `.opencode/plans/001_reports/` → `.claude/plans/archive/` (OpenCode 001 → `OC-001`)
- **Acceptation :** index unique `.claude/plans/README.md`, 0 lien hors arbre

#### T1.3 - Réécrire le sync `claude → github`
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `scripts/Sync-Description.psm1`, `scripts/sync-claude-to-github.ps1`
- **Implémenter :** direction unique ; table de mapping frontmatter (Claude `tools`/`model`/`skills` → Copilot `tools`/`model`/instructions ; retrait champs Claude-only) ; substitution par tokens délimités (`.claude/`, `CLAUDE.md`, `Claude Code`) ; bootstrap générant un frontmatter Copilot ; parallélisation → `/fleet` côté Copilot
- **Acceptation :** 2ᵉ exécution = 0 changement ; « Claude Sonnet » non altéré

#### T1.4 - Spike skills partagés Copilot
- **Agent :** 🟠 ARCos
- **Implémenter :** vérifier que Copilot (CLI + VS Code) charge `.claude/skills/` en tolérant les champs Claude-only
- **Acceptation :** décision documentée : supprimer `.github/skills/` généré **ou** le générer avec frontmatter épuré

---

### Phase 2 — Agents natifs Claude Code — ✅ TERMINÉE (2026-10-12)
**Contexte :** C1, C2, M10, m1. Dépend de P1.
**Critères :** ✅ 0 `applyTo`/`agents:` dans `.claude/agents/` ✅ chaque agent a `tools` + `model` ✅ MAINa conçu pour le thread principal (`claude --agent MAINa`).
**Rapport :** [`005_reports/PHASE_2_COMPLETION_REPORT.md`](005_reports/PHASE_2_COMPLETION_REPORT.md) — écarts : ARCos sans `memory` (activerait Write/Edit) ; MAINa garde `Bash` (preuves de gate, T5.3) ; hooks de rôle reportés en T4.3 ; préchargement `conventions-<rôle>` reporté en T3.4.

#### T2.1 - Frontmatter natif par agent
- **Agent :** 🟠 ARCos (conception) → 🔵 DEVon
- **Fichier(s) :** `.claude/agents/*.agent.md`
- **Implémenter :** version sortie de la description (corps + CHANGELOG) ; descriptions accentuées orientées routage

  | Agent | model | tools | Extras |
  |---|---|---|---|
  | ⚫ MAINa | `opus` | Agent, Read, Grep, Glob, Edit/Write (plans), Task* | **thread principal** (`claude --agent MAINa` ou `"agent": "MAINa"`) → garde `AskUserQuestion` pour les gates |
  | 🟠 ARCos | `opus`, `effort: high` | Read, Grep, Glob, WebFetch, WebSearch | lecture seule ; `memory: project` ; sortie persistée par MAINa/DOCly |
  | 🔵 DEVon | `sonnet` | Read, Edit, Write, Bash, Grep, Glob | hook : bloque édition `*.test.*`, `docs/**` |
  | 🟢 QALvin | `sonnet` | Read, Edit, Write, Bash, Grep, Glob | hook : édition limitée aux fichiers de test |
  | 🟣 DOCly | `sonnet` | Read, Edit, Write, Grep, Glob | hook : édition limitée `*.md`, `docs/**` |
- **Acceptation :** `/agents` liste 5 agents avec outils/modèle attendus

#### T2.2 - Préchargement des procédures
- **Agent :** 🔵 DEVon
- **Implémenter :** `skills:` par agent (ex. DEVon : `plan-phase-execution`, `conventions-dev`)

#### T2.3 - Nettoyage des corps
- **Agent :** 🔵 DEVon
- **Implémenter :** DEVon « tâches du Plan d'Action (MAINa) » ; retrait parallélisme QALvin ∥ DOCly ; retrait `-- ` QALvin ; nommage unique `⚫ MAINa / 🟠 ARCos / 🔵 DEVon / 🟢 QALvin / 🟣 DOCly`

---

### Phase 3 — Skills & instructions natifs — ✅ TERMINÉE (2026-10-12)
**Contexte :** M2, M3, M4, M5, m2, m3. Parallélisable avec P2.
**Critères :** ✅ 0 `applyTo` dans `.claude/skills/` ✅ 0 `/fleet` dans `.claude/` hors bloc `copilot-only` ✅ 0 fuite projet dans les templates.
**Rapport :** [`005_reports/PHASE_3_COMPLETION_REPORT.md`](005_reports/PHASE_3_COMPLETION_REPORT.md) — `safety-rules`/`copilotignore` conservés jusqu'à P4 (pas de trou de sécurité) ; `docs/ARCHITECTURE.md` réécrit (T6.2 anticipé pour ce fichier) ; packaging réparé.

#### T3.1 - Skills d'activation
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `.claude/skills/{arcos,devon,qalvin,docly,maina,maina-help}/SKILL.md`
- **Implémenter :** `/arcos /devon /qalvin /docly` → `context: fork`, `agent: <X>`, `disable-model-invocation: true`, corps `$ARGUMENTS`. `/maina` → **inline** (protocole MAINa dans le thread principal). `maina-help` → `disable-model-invocation: true`

#### T3.2 - Skills procéduraux
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `plan-phase-execution`, `plan-creation`, `adr-writing`
- **Implémenter :** `user-invocable: false` ; descriptions honnêtes ; templates (plan, rapport, handoff) en fichiers support du skill

#### T3.3 - Rationaliser les skills transverses
- **Agent :** 🔵 DEVon
- **Implémenter :** `fleet-guide` → `parallel-guide` (Agent parallèles, `isolation: worktree`, background) ; retirer `caveman-default` (dépendance plugin déclarée) ; `compact-context` → section « Compact instructions » CLAUDE.md ; `safety-rules`/`copilotignore` → remplacés par P4

#### T3.4 - Instructions projet → skills `conventions-<rôle>`
- **Agent :** 🔵 DEVon
- **Implémenter :** templates `*.instructions.template.md` → skills `conventions-<rôle>` (`user-invocable: false`, préchargés) ; fuites projet → placeholders ; orchestrator inclus partout

#### T3.5 - Prompts → skills
- **Agent :** 🔵 DEVon
- **Implémenter :** `init-harness`, `update-harness` (Copilot : `.prompt.md` généré) ; retirer réfs `migrate-to-template`

---

### Phase 4 — Garde-fous déterministes — ✅ TERMINÉE (2026-10-12)
**Contexte :** C3. Dépend de P2/P3.
**Critères :** ✅ blocages vérifiés par 54 cas de test du hook ⚠️ vérification « en session réelle » à faire par 👤 après redémarrage (settings chargés au démarrage).
**Rapport :** [`005_reports/PHASE_4_COMPLETION_REPORT.md`](005_reports/PHASE_4_COMPLETION_REPORT.md) — écarts : hook unique global (bash) au lieu de `.ps1`+`.sh` agent-scoped ; SQL destructif `deny` (pas `ask`) ; `.copilotignore` en lecture via règles `Read()` statiques (latence).

#### T4.1 - Settings
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `.claude/settings.json`, `.claude/settings.template.json`
- **Implémenter :** `permissions.deny` (`Bash(rm -rf:*)`, `Bash(git reset --hard:*)`, `Bash(git clean:*)`, `Bash(git push --force:*)`, `Read(./.env*)`, `Read(./dist/**)`)

#### T4.2 - Hook PreToolUse de garde
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `.claude/hooks/guard.ps1` (+ `.sh`)
- **Implémenter :** blocage commandes destructives (dont SQL) + motifs `.copilotignore` (conservé = source unique des exclusions, lu aussi par Copilot)

#### T4.3 - Hooks de frontière de rôle
- **Agent :** 🔵 DEVon
- **Implémenter :** hooks agent-scoped définis en T2.1

---

### Phase 5 — Workflow strict fiabilisé — ✅ TERMINÉE (2026-10-12)
**Contexte :** C2, M8, M9. Dépend de P2/P3.
**Critères :** ✅ protocole de gate imposant l'entrée « Journal des gates » (skill `gate-protocol`) ✅ handoff YAML exigé des 4 agents exécutants (MAINa le consomme).
**Rapport :** [`005_reports/PHASE_5_COMPLETION_REPORT.md`](005_reports/PHASE_5_COMPLETION_REPORT.md) — T5.1 déjà couvert par P2/P3 (vérifié) ; ADR : `Proposée` avant Gate #1, `Acceptée` au GO (DOCly autorisé à rédiger l'ADR avant Gate #3).

- **T5.1** (🟠 ARCos → 🔵 DEVon) MAINa thread principal ; `/maina` et docs alignés.
- **T5.2** (🔵 DEVon) Protocole de gate : livrable + preuves (tests/lint, diff résumé, rapport revue) + décision `GO / AJUSTER / STOP` dans « Journal des gates ».
- **T5.3** (🔵 DEVon) Pré-Gate #2 : `/code-review` + `/security-review` sur le diff, rapport joint.
- **T5.4** (🔵 DEVon) DEVon : preuve avant handoff (build + lint + tests existants verts). QALvin : seuil couverture depuis `conventions-qa`, preuve de régression.
- **T5.5** (🔵 DEVon) Contrat de handoff YAML (plan, phase, tâches, fichiers, critères, preuves, risques, suite).
- **T5.6** (🔵 DEVon) ADR : `Proposée` → `Acceptée` après gate (`adr-writing`).

---

### Phase 6 — Copilot généré + docs + anti-dérive — ⏳ Planifié
**Contexte :** M1, M6, M11, M12, m4-m6. Dépend de P1-P5.
**Critères :** `check-harness` 0 erreur ; CI verte ; `CLAUDE.md` ≤ 200 l. ; ZIP complet.

- **T6.1** (🔵 DEVon) Régénérer `.github/` ; vérifier chargement agents/skills dans VS Code Copilot.
- **T6.2** (🟣 DOCly) `CLAUDE.md` ≤ 200 l. ; `CLAUDE.template.md` épuré + `@imports` ; READMEs, `QUICK_START_CLAUDE.md` (`claude --agent MAINa`, Shift+Tab, `/agents`), `SETUP_CHECKLIST.md` neutre ; `docs/ARCHITECTURE.md` réécrit sans compteurs codés en dur.
- **T6.3** (🔵 DEVon) `scripts/check-harness.ps1` (champs frontmatter autorisés, 0 `applyTo`/`.github/`/`Copilot`/`/fleet` dans `.claude/`, liens morts, versions cohérentes, inventaire généré) + tests Pester du module sync.
- **T6.4** (🔵 DEVon) GitHub Action : `check-harness` + `sync -WhatIf` sans diff sur PR.
- **T6.5** (🔵 DEVon) `package-claude.ps1` : `CLAUDE.template.md`, `settings.template.json`, `hooks/`, `docs/adr/ADR-TEMPLATE.md`, checklist Claude ; ne plus livrer `CLAUDE.md` du dépôt ; note dépendance caveman. `package-github.ps1` idem.

---

### Phase 7 — Évaluation du harnais — ⏳ Planifié
**Contexte :** absence de tests du comportement des agents. Dépend de P6.
**Critères :** scénarios headless verts.

- **T7.1** (🟢 QALvin) Projet fixture minimal `tests/fixtures/sample-app/`.
- **T7.2** (🟢 QALvin) Scénarios `claude -p --agent MAINa` + assertions : `/maina-help` ; feature → plan créé + index MAJ + Gate #0 posé ; ARCos ≥ 2 options ; DEVon bloqué sur `*.test.*` ; `rm -rf` bloqué.
- **T7.3** (🟣 DOCly) Routine de maintenance : `/doctor prompt-audit` + `check-harness` avant chaque release ZIP.

---

## 📍 Dépendances entre Phases

```
Phase 0 (formalisation) ✅
    ↓
Phase 1 (source unique + retrait OpenCode)  ← prérequis
    ↓
Phase 2 (agents) ←┬→ Phase 3 (skills/instructions)   [parallélisables]
    ↓             ↓
Phase 4 (garde-fous)   Phase 5 (workflow)            [après P2+P3]
    ↓                  ↓
Phase 6 (Copilot généré + docs + CI) ← P1-P5
    ↓
Phase 7 (évaluation)
```

---

## ✅ Critères de Succès Globaux

1. **Source unique** `.claude/` ; `.github/` régénérable, sync idempotent ; OpenCode retiré.
2. **0 champ Copilot** (`applyTo`, `agents:`) ni `/fleet` dans `.claude/`.
3. Chaque agent a **`tools` + `model`** ; frontières de rôle **bloquées par hooks**.
4. Gates exécutés par **MAINa en thread principal**, tracés dans le **Journal des gates**.
5. Opérations destructives et fichiers ignorés **refusés de façon déterministe**.
6. `check-harness` + CI : **0 dérive** de compteurs, versions, liens.
7. ZIP Claude **complet** et installable ; scénarios d'évaluation **verts**.

---

## 🚦 Journal des gates

| Gate | Date | Objet | Décision 👤 | Notes |
|---|---|---|---|---|
| #0 | 2026-10-12 | Analyse critique + choix stratégiques | ✅ GO | Claude-first, OpenCode supprimé, ZIP conservé, gates stricts |
| #1 | 2026-10-12 | Plan d'amélioration (7 phases) | ✅ GO | Plan validé |
| P0 | 2026-10-12 | AP 005 + ADR 003 | ✅ GO | ADR 003 → Acceptée |
| P1 | 2026-10-12 | Suppressions OpenCode (autorisées) + sync `claude→github` | ✅ GO (suppressions) | Livrable P1 : validation 👤 en attente |
| P1-fin | 2026-10-12 | Revue livrables P1 | ✅ GO | Commit `6485f79` + push demandés |
| P2-fin | 2026-10-12 | Revue livrables P2 (agents natifs) | ✅ GO | Commit + push demandés ; smoke test runtime à faire par 👤 |
| P3 | 2026-10-12 | Lancement P3 (incl. suppressions `caveman-default`, `compact-context` prévues en T3.3) | ✅ GO | — |
| P3-fin | 2026-10-12 | Revue livrables P3 (skills & instructions) | ✅ GO | Commit + push demandés ; tests runtime des commandes à faire par 👤 |
| P4 | 2026-10-12 | Lancement P4 | ✅ GO | — |
| P4-fin | 2026-10-12 | Revue livrables P4 (garde-fous) | ✅ GO | Commit + push demandés ; test en session réelle après redémarrage à faire par 👤 |
| P5 | 2026-10-12 | Lancement P5 | ✅ GO | — |
| P5-fin | 2026-10-12 | Revue livrables P5 (workflow fiabilisé) | ✅ GO | Commit + push demandés |
| P6 | 2026-10-12 | Lancement P6 | ✅ GO | — |
| P6-fin | — | Revue livrables P6 (Copilot, docs, anti-dérive) | ⏳ En attente | — |

---

## 📚 Références

- Plan précédent : [`004_analyse-critique-infra-agents.plan.md`](004_analyse-critique-infra-agents.plan.md)
- ADR : [`002`](../../docs/adr/002-claude-miroir-genere.md) (remplacée), [`003`](../../docs/adr/003-claude-first-copilot-genere.md)
- Doc Claude Code : [Subagents](https://code.claude.com/docs/en/sub-agents) · [Skills](https://code.claude.com/docs/en/skills) · [Memory](https://code.claude.com/docs/en/memory) · [Settings](https://code.claude.com/docs/en/settings) · [Plugins](https://code.claude.com/docs/en/plugins)
- Doc Copilot skills : [Create skills](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-skills)
