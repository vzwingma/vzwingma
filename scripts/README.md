# Scripts — Synchro Agents & Packaging

Utilitaires PowerShell pour synchroniser agents + skills entre `.github/`, `.opencode/`, `.claude/` et générer packages distribués.

---

## 🔄 Synchronisation (Sync Scripts)

### `sync-github-to-opencode.ps1`

**Copilot → OpenCode**

Sync agents, skills, instructions, CHANGELOG, PLANS, README depuis `.github/` vers `.opencode/`.

```bash
.\scripts\sync-github-to-opencode.ps1      # Execute
.\scripts\sync-github-to-opencode.ps1 -WhatIf  # Dry-run
```

Couvre :
- Agents : `.github/agents/*.agent.md` → `.opencode/agents/`
- Skills : `.github/skills/*/SKILL.md` → `.opencode/skills/`
- Instructions : `.github/instructions/*.md` → `.opencode/instructions/`
- Standalone : CHANGELOG.md, PLANS.md, README.md
- Templates : Copiés dans `.opencode/instructions/templates/`

---

### `sync-github-to-claude.ps1`

**Copilot → Claude**

Sync agents, skills, instructions depuis `.github/` vers `.claude/`.

```bash
.\scripts\sync-github-to-claude.ps1        # Execute
.\scripts\sync-github-to-claude.ps1 -WhatIf   # Dry-run
```

Couvre :
- Agents : `.github/agents/*.agent.md` → `.claude/agents/`
- Skills : `.github/skills/*/SKILL.md` → `.claude/skills/`
- Instructions : `.github/instructions/*.md` → `.claude/instructions/`
- Standalone : CHANGELOG.md, PLANS.md, README.md
- Templates : Copiés dans `.claude/instructions/`

---

### `sync-opencode-to-claude.ps1`

**OpenCode → Claude**

Sync agents, skills, instructions depuis `.opencode/` vers `.claude/`.

```bash
.\scripts\sync-opencode-to-claude.ps1      # Execute
.\scripts\sync-opencode-to-claude.ps1 -WhatIf  # Dry-run
```

Couvre :
- Agents : `.opencode/agents/*.agent.md` → `.claude/agents/`
- Skills : `.opencode/skills/*/SKILL.md` → `.claude/skills/`
- Instructions : `.opencode/instructions/*.md` → `.claude/instructions/`
- Standalone : CHANGELOG.md, PLANS.md, README.md
- Templates : Copiés dans `.claude/instructions/`

---

### `sync-opencode-to-github.ps1`

**OpenCode ← Copilot** (reverse sync)

Sync agents, skills, instructions depuis `.opencode/` vers `.github/`.

```bash
.\scripts\sync-opencode-to-github.ps1      # Execute
.\scripts\sync-opencode-to-github.ps1 -WhatIf  # Dry-run
```

---

## 📦 Packaging (Package Scripts)

### `package-github.ps1`

**Package agents Copilot**

Génère ZIP distributable avec agents, skills, instructions, templates, docs.

```bash
.\scripts\package-github.ps1
.\scripts\package-github.ps1 -OutputDir C:\release -FileName copilot-v1.0
```

Inclus :
- `.github/agents/`
- `.github/instructions/`
- `.github/prompts/`
- `.github/skills/`
- `.github/CHANGELOG.md`, `PLANS.md`
- `docs/` (sans ARCHITECTURE.md)
- `QUICK_START.md`, `SETUP_CHECKLIST.md`

Exclu : `.opencode/`, `.claude/`, scripts/, plans/, `.git/`, dist/

Output : `dist/copilot-templates-<yyyyMMdd>.zip`

---

### `package-claude.ps1`

**Package agents Claude**

Génère ZIP distributable avec agents Claude, skills, instructions, templates, docs.

```bash
.\scripts\package-claude.ps1
.\scripts\package-claude.ps1 -OutputDir C:\release -FileName claude-v1.0
```

Inclus :
- `.claude/agents/`
- `.claude/instructions/`
- `.claude/prompts/`
- `.claude/skills/`
- `.claude/CHANGELOG.md`, `PLANS.md`, `CLAUDE.md`
- `docs/` (sans ARCHITECTURE.md)
- `QUICK_START.md`, `SETUP_CHECKLIST.md`

Exclu : `.github/`, `.opencode/`, scripts/, plans/, `.git/`, dist/

Output : `dist/claude-templates-<yyyyMMdd>.zip`

---

### `package-opencode.ps1`

**Package agents OpenCode**

Génère ZIP distributable avec agents OpenCode, skills, instructions, templates, docs.

```bash
.\scripts\package-opencode.ps1
.\scripts\package-opencode.ps1 -OutputDir C:\release -FileName opencode-v1.0
```

Inclus :
- `.opencode/agents/`
- `.opencode/instructions/`
- `.opencode/prompts/`
- `.opencode/skills/`
- `.opencode/CHANGELOG.md`, `PLANS.md`, `README.md`
- `docs/` (sans ARCHITECTURE.md)
- `QUICK_START.md`, `SETUP_CHECKLIST.md`

Exclu : `.github/`, `.claude/`, scripts/, plans/, `.git/`, dist/

Output : `dist/opencode-templates-<yyyyMMdd>.zip`

---

## 🔧 Modules Partagés

### `Sync-Description.psm1`

Utilitaire PowerShell partagé pour synchronisation fichiers structurés.

**Fonctions principales** :
- `Sync-AgentFiles` : Sync agents/skills avec préservation frontmatter spécifiques plateformes
- `Sync-StandaloneFiles` : Sync fichiers .md standalone avec substitution chemins

**Utilisé par** : Tous scripts sync

---

## 📋 Workflow Recommandé

Après modifications agents Copilot (`.github/`) :

```bash
# 1. Sync GitHub → OpenCode
.\scripts\sync-github-to-opencode.ps1

# 2. Sync GitHub → Claude
.\scripts\sync-github-to-claude.ps1

# 3. (Optionnel) Générer packages distribués
.\scripts\package-github.ps1
.\scripts\package-claude.ps1
.\scripts\package-opencode.ps1
```

Après modifications agents OpenCode (`.opencode/`) :

```bash
# 1. Sync OpenCode → Claude
.\scripts\sync-opencode-to-claude.ps1

# 2. (Optionnel) Sync OpenCode → GitHub (pour mettre à jour source)
.\scripts\sync-opencode-to-github.ps1
```

---

## 🎯 Cas d'Utilisation

| Action | Script | Notes |
|--------|--------|-------|
| Modifier agent Copilot | Modifier `.github/agents/*.agent.md` | → sync-github-to-* |
| Modifier skill Copilot | Modifier `.github/skills/*/SKILL.md` | → sync-github-to-* |
| Créer package Copilot distribué | `package-github.ps1` | ZIP avec agents Copilot |
| Créer package Claude distribué | `package-claude.ps1` | ZIP avec agents Claude |
| Créer package OpenCode distribué | `package-opencode.ps1` | ZIP avec agents OpenCode |
| Mettre à jour Claude depuis GitHub | `sync-github-to-claude.ps1` | Force cohérence plateformes |

---

**Dernière mise à jour** : 2026-06-25
