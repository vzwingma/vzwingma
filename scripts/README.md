# Scripts — Génération Copilot & Packaging

Utilitaires PowerShell (compatibles Windows PowerShell 5.1 et PowerShell 7).

**Modèle (ADR 003)** : `.claude/` = **source unique**. `.github/` (Copilot) = **généré** — ne jamais l'éditer à la main.

---

## 🔄 Génération Copilot

### `sync-claude-to-github.ps1`

**Claude → Copilot** — seul sens de synchronisation.

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
| `QUICK_START_CLAUDE.md` (racine) | `QUICK_START_COPILOT.md` | Substitution texte |

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
| `ModelMap` | Alias modèle Claude (`opus`, `sonnet`, `haiku`) → modèle Copilot, si pas d'override |
| `ToolMap` | Outil Claude → outil Copilot, si pas d'override (Copilot accepte nativement `Read`, `Edit`, `Write`, `Bash`, `Grep`, `Glob`, `WebFetch`, `WebSearch`, `Task`, `TodoWrite`) |

Champs Claude-only (`permissionMode`, `skills`, `hooks`, `memory`, `effort`, …) non reportés.

### `Sync-Description.psm1`

Module générateur utilisé par le sync : `ConvertTo-CopilotText`, `New-CopilotAgentContent`, `New-CopilotSkillContent`, `Sync-AgentFile`, `Sync-SkillFile`, `Sync-StandaloneFile`.

---

## 📦 Packaging

### `package-claude.ps1`

ZIP distribuable des artefacts Claude → `dist/claude-templates-<yyyyMMdd>.zip`.

```bash
.\scripts\package-claude.ps1
.\scripts\package-claude.ps1 -OutputDir C:\release -FileName claude-v1.0
```

Inclus : `.claude/agents/`, `skills/`, `hooks/`, `settings.template.json`, `CHANGELOG.md`, `PLANS.md`, `CLAUDE.md`, `README.md` · `docs/` (sans `ARCHITECTURE.md`) · `QUICK_START_CLAUDE.md`, `SETUP_CHECKLIST.md`.

### `package-github.ps1`

ZIP distribuable des artefacts Copilot (générés) → `dist/copilot-templates-<yyyyMMdd>.zip`. **Lancer le sync avant.**

```bash
.\scripts\package-github.ps1
.\scripts\package-github.ps1 -OutputDir C:\release -FileName copilot-v1.0
```

Inclus : `.github/agents/`, `instructions/`, `skills/`, `CHANGELOG.md`, `PLANS.md`, `copilot-instructions.template.md` · `docs/` (sans `ARCHITECTURE.md`) · `QUICK_START_COPILOT.md`, `SETUP_CHECKLIST.md`.

---

## 🧪 Tests

### `tests/guard.tests.sh`

Tests du hook de garde `.claude/hooks/guard.sh` (commandes destructives, `.copilotignore`, frontières de rôle, chemins Windows) sur un projet fixture temporaire.

```bash
bash scripts/tests/guard.tests.sh   # exit code = nombre d'échecs
```

---

## 📋 Workflow

```bash
# 1. Modifier .claude/ (jamais .github/)
# 2. Générer Copilot
.\scripts\sync-claude-to-github.ps1
# 3. Vérifier (idempotence)
.\scripts\sync-claude-to-github.ps1 -Check
# 4. (Optionnel) Packages
.\scripts\package-claude.ps1
.\scripts\package-github.ps1
```

Tâches VS Code équivalentes : `Sync: Claude → GitHub`, `Sync: Check (Claude → GitHub)`, `Package (Claude)`, `Package (GitHub)`.
