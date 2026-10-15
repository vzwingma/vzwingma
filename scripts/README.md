# Scripts — Génération Copilot CLI & Packaging

Utilitaires PowerShell (compatibles Windows PowerShell 5.1 et PowerShell 7).

**Modèle (ADR 003)** : `.claude/` = **source unique**. `.github/` (projection GitHub Copilot CLI) =
**généré** — ne jamais l'éditer à la main. VS Code et cloud agent sont hors périmètre de la vérification AP 006.

---

## 🔄 Génération Copilot

### `sync-claude-to-github.ps1`

**Claude → GitHub Copilot CLI** — seul sens de synchronisation.

```bash
.\scripts\sync-claude-to-github.ps1           # Génère .github/
.\scripts\sync-claude-to-github.ps1 -WhatIf   # Dry-run
.\scripts\sync-claude-to-github.ps1 -Check    # CI : exit 1 si .github/ pas à jour ou orphelins
```

| Source `.claude/` | Cible `.github/` | Traitement |
|---|---|---|
| `agents/*.agent.md` | `agents/*.agent.md` | Frontmatter Copilot **généré** (voir mapping) + corps substitué |
| `agents/README.md` | `agents/README.md` | Substitution texte |
| `skills/<nom>/SKILL.md` (+ fichiers support) | `skills/<nom>/…` | Frontmatter réduit à la spec Agent Skills (`name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`) |
| `instructions/*.md` | `instructions/*.md` | Substitution texte |
| `prompts/*.prompt.md` | `prompts/*.prompt.md` | Substitution texte |
| `CLAUDE.md` / `CLAUDE.template.md` | `copilot-instructions.md` / `copilot-instructions.template.md` | Substitution texte |
| `CHANGELOG.md`, `PLANS.md`, `README.md` | idem | Substitution texte |
| `QUICK_START_CLAUDE.md` (racine) | `QUICK_START_COPILOT.md` | Substitution texte ; fichier généré |

Fichiers présents dans `.github/{agents,skills,instructions,prompts}` sans source `.claude/` : signalés **ORPHAN** (jamais supprimés).

#### Substitution texte

Tokens délimités, dans cet ordre : `.claude/` → `.github/` · `QUICK_START_CLAUDE` → `QUICK_START_COPILOT` · `CLAUDE.template.md` → `copilot-instructions.template.md` · `CLAUDE.md` → `copilot-instructions.md` · `Claude Code` → `GitHub Copilot` · mot `Claude` → `Copilot` **sauf** noms de modèles (`Claude Sonnet/Opus/Haiku/Fable`).

#### Blocs spécifiques plateforme

```markdown
<!-- claude-only -->
Contenu visible seulement côté Claude (retiré pour Copilot).
<!-- /claude-only -->

<!-- copilot-only
Contenu visible seulement côté Copilot (commentaire masqué côté Claude, déballé pour Copilot).
-->
```

#### Mapping frontmatter — `copilot-mapping.psd1`

| Clé | Rôle |
|---|---|
| `Agents.<Nom>` | Champs Copilot par agent (`model`, `tools`, `agents`, …) — **prioritaires** |
| `ModelMap` | Alias source `opus` → `claude-opus-5.5`, `sonnet` → `claude-sonnet-5.5` |
| `ToolMap` | `Read` → `read`, `Grep`/`Glob` → `search`, `WebFetch`/`WebSearch` → `web`, `Edit`/`Write` → `edit`, `Bash` → `execute`, `TodoWrite` → `todo`, `Agent` → `agent` |
| `DroppedTools` | `AskUserQuestion`, `SendMessage`, `Skill` : avertissement puis non-projection |

Champs Claude-only (`permissionMode`, `skills`, `hooks`, `memory`, `effort`, …) non reportés.

ARCos est dérivé en `[read, search, web]`, sans écriture, exécution ni délégation. Le champ `agents` de
MAINa est conservé à titre informatif et n'est pas vérifié. Un modèle inconnu produit un avertissement, un
repli sur le modèle par défaut et un code de sortie `0` : ce comportement peut produire un faux succès.

La CLI lit `.github/skills/` et `.claude/skills/`; `.github/` est prioritaire à nom identique. Le chargement
des skills se fait selon pertinence, non de manière déterministe. Chaque profil porte donc une consigne
explicite de chargement. Les conventions sont projetées dans
`.github/instructions/<role>.instructions.template.md`.

### `Sync-Description.psm1`

Module générateur utilisé par le sync : `ConvertTo-CopilotText`, `New-CopilotAgentContent`, `New-CopilotSkillContent`, `New-CopilotInstructionContent`, `Sync-AgentFile`, `Sync-SkillFile`, `Sync-InstructionFile`, `Sync-StandaloneFile`.

---

## 📦 Packaging

ZIP distribuables via le module partagé `Package.psm1` (liste déclarative d'éléments ; entrées ZIP en `/`,
portables macOS/Linux). Sortie par défaut : `dist/`.

Chaque package lance `check-harness` avant écriture. Une archive existante n'est jamais écrasée ; l'archive
est écrite dans un fichier `.partial`, puis renommée après succès.

### `package-claude.ps1` → `dist/claude-templates-<yyyyMMdd>.zip`

```bash
.\scripts\package-claude.ps1
.\scripts\package-claude.ps1 -OutputDir C:\release -FileName claude-v1.0
```

Inclus : `.claude/agents/`, `skills/` (sans variantes `SKILL.copilot.md`), `hooks/`, `settings.template.json`,
`CLAUDE.template.md`, `CHANGELOG.md`, `PLANS.md`, `README.md` · `docs/ARCHITECTURE.template.md`,
`docs/adr/ADR-TEMPLATE.md`, `docs/diagrams/` · `QUICK_START_CLAUDE.md`, `SETUP_CHECKLIST.md`.
Exclus (propres à ce dépôt) : `.claude/CLAUDE.md`, `settings.json`, `plans/`, `docs/ARCHITECTURE.md`, ADR du dépôt.

### `package-github.ps1` → `dist/copilot-templates-<yyyyMMdd>.zip` (lancer le sync avant)

```bash
.\scripts\package-github.ps1
```

Inclus : `.github/agents/`, `skills/`, `instructions/`, `copilot-instructions.template.md`, `CHANGELOG.md`,
`PLANS.md`, `README.md` · mêmes templates `docs/` · `QUICK_START_COPILOT.md`, `SETUP_CHECKLIST.md` ·
`.agents/` si présent localement (skills tiers optionnels).

Dépendance optionnelle : plugin / skills `caveman` (mode de communication) — règles reprises dans les templates.

---

## ✅ Contrôles

### `check-harness.ps1`

Cohérence du harnais (exit 1 si erreur) : frontmatter agents/skills, version agent = CHANGELOG =
`docs/ARCHITECTURE.md`, artefacts Copilot dans `.claude/`, liens morts, compteurs codés en dur, taille de
`CLAUDE.md` (≤ 200 l.), settings/hooks, `.gitattributes`, index des plans, génération Copilot (`-Check`).
Le contrat de projection est indépendant du générateur : outils autorisés, ARCos lecture seule, modèle en
identifiant de catalogue, parité des skills, consigne de chargement et interdiction de `tools` absent.
`scripts/Harness-Paths.psm1` applique les exclusions avant récursion (`.git`, `node_modules`, `dist`,
`.claude/worktrees` et entrées de dossier de `.copilotignore`) ; globs et négations non interprétables sont
signalés, pas appliqués.
Compatible Windows PowerShell 5.1 et PowerShell 7. Affiche l'inventaire de 5 agents et 18 skills.

```bash
.\scripts\check-harness.ps1             # complet
.\scripts\check-harness.ps1 -SkipSync   # sans contrôle de .github/
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/check-harness.ps1
pwsh -NoProfile -File scripts/check-harness.ps1
```

CI : `.github/workflows/harness-check.yml` (Windows : PowerShell 5.1 + 7 + bash), sur PR et push `main` /
`main-ai`; `actions/checkout` est épinglée par SHA.

---

## 🧪 Tests

### `scripts/tests/sync.tests.ps1`

Tests unitaires du générateur `Sync-Description.psm1` (substitution, blocs plateforme, mapping frontmatter,
CRLF). Sans dépendance (Pester non requis) ; exit code = nombre d'échecs.

```bash
pwsh -NoProfile -File scripts/tests/sync.tests.ps1
```

Résultat AP 006 : 31/31 sous PowerShell 5.1 et PowerShell 7.

### `scripts/tests/compatibility.tests.ps1`

Contrôles de compatibilité du contrat de projection, des outils, modèles, skills, rôles et erreurs.

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/tests/compatibility.tests.ps1
pwsh -NoProfile -File scripts/tests/compatibility.tests.ps1
```

Résultat AP 006 : 68/68 sous chacun des deux moteurs.

### `scripts/tests/guard.tests.sh`

Tests du hook de garde `.claude/hooks/guard.sh` (commandes destructives, `.copilotignore`, frontières de rôle, chemins Windows) sur un projet fixture temporaire.

```bash
bash scripts/tests/guard.tests.sh   # exit code = nombre d'échecs
```

Résultat AP 006 : 54/54.

---

### `tests/eval-scenarios.ps1`

Évaluation **comportementale** avec de vrais appels `claude -p` sur une copie jetable du projet fixture
`tests/fixtures/sample-app/` (harnais installé depuis `.claude/`, conventions remplies) ; assertions sur la
réponse **et** sur les fichiers. Workdirs et logs conservés dans `%TEMP%\harness-eval-<horodatage>\`.

| Scénario | Vérifie |
|---|---|
| S1 | `/maina-help` décrit gates #0→#4 et commandes |
| S2 | MAINa s'arrête au Gate #0 (≥ 2 options, code intact) ; après `GO`, écrit le plan + index + journal et s'arrête au Gate #1 |
| S3 | ARCos ne crée aucun fichier (lecture seule) |
| S4 | DEVon ne modifie pas un fichier de test (frontière de rôle) |
| S5 | `sh -c 'rm -f …'` bloqué (règle deny / hook) |
| S6 | un fichier `.copilotignore` n'est jamais divulgué |

```bash
powershell -NoProfile -File scripts/tests/eval-scenarios.ps1 -DryRun       # prépare les workdirs, sans appel modèle
powershell -NoProfile -File scripts/tests/eval-scenarios.ps1 -Only S1,S3   # sous-ensemble
```

Requiert une CLI authentifiée (sinon exit 2) ; coût plafonné par appel (`-BudgetUsd`, défaut 1,50 $ ; MAINa et
ARCos utilisent `opus`). Plans dans `docs/plans/` (ADR 004) : S2 tourne en `acceptEdits`, sans `bypassPermissions`.

### `scripts/tests/eval-copilot-scenarios.ps1`

Évaluation comportementale GitHub Copilot CLI sur les scénarios réels S1–S7. Les appels de modèle sont
payants ; le script impose un plafond de crédits et une réserve (`-MaxCredits`, `-CreditReserve`), et
propose `-DryRun`, `-Only` et `SELFTEST`.

```bash
pwsh -NoProfile -File scripts/tests/eval-copilot-scenarios.ps1 -Only S1,S2,S3,S4,S5,S6,S7 -MaxCredits 60
pwsh -NoProfile -File scripts/tests/eval-copilot-scenarios.ps1 -Only S5,S4,S6,S7 -DryRun
pwsh -NoProfile -File scripts/tests/eval-copilot-scenarios.ps1 -Only SELFTEST
```

AP 006 : CLI `1.0.99-1`, S1–S7 exécutés ; S7 a détecté un repli avec code CLI `0`. S4–S6 ont fourni des
comportements observés, non des garanties natives. La matrice fonctionnelle 17/17 n'est pas une couverture
instrumentée de lignes ou de statements.

### Limites de l'évaluation Copilot CLI

- Aucun hook `.github/hooks` n'est annoncé actif : aucune garde déterministe côté CLI n'est prouvée.
- `.copilotignore` n'est pas documenté ici comme mécanisme CLI ; S6 a seulement observé une abstention après
  lecture de l'ignore. L'exclusion de `/dist/` n'est pas garantie par la CLI.
- Les frontières DEVon/QALvin/DOCly ont été respectées dans les scénarios : blocage par absence
  d'approbateur ou par prose, pas par règle de rôle native.
- La précédence `git rm` (`allow` local contre `ask` dépôt) reste non tranchée.
- L'arrêt aux gates a été observé en `-p` pour S2, sans garantie générale.
- Les skills `.claude/skills/` restent lisibles par la CLI ; une variante Claude peut être lue si
  `.github/skills/` est absent.

---

## 🚀 Routine avant release ZIP

```bash
.\scripts\sync-claude-to-github.ps1                       # 1. générer la projection CLI
.\scripts\sync-claude-to-github.ps1 -Check               # 2. vérifier la dérive
.\scripts\check-harness.ps1                               # 3. contrat (PS 5.1 et 7)
powershell -File scripts\tests\sync.tests.ps1             # 4. générateur
powershell -File scripts\tests\compatibility.tests.ps1   # 5. compatibilité
bash scripts/tests/guard.tests.sh                         # 6. garde Claude
powershell -File scripts\tests\eval-copilot-scenarios.ps1 # 7. comportement CLI, appels payants
.\scripts\package-claude.ps1 ; .\scripts\package-github.ps1
```

En session Claude Code : `/doctor prompt-audit` pour repérer instructions contradictoires ou obsolètes.

---

## 📋 Workflow

```bash
# 1. Modifier .claude/ (jamais .github/)
# 2. Générer Copilot
.\scripts\sync-claude-to-github.ps1
# 3. Vérifier (cohérence + idempotence de la génération)
.\scripts\check-harness.ps1
# 4. (Optionnel) Packages
.\scripts\package-claude.ps1
.\scripts\package-github.ps1
```

Commandes équivalentes : `Sync: Claude → GitHub`, `Sync: Check (Claude → GitHub)`, `Package (Claude)`,
`Package (GitHub)`.
