# CLAUDE.md

File guides Claude Code (claude.ai/code) when working code in repo.

---

## Repository Overview

**Copilot cross-repo multi-agent repo** — Reusable infra orchestrate dev via GitHub Copilot.

Main stack: Markdown, YAML frontmatter
Type: Templates, agents, prompts (no application code)
Language: English (content), English (code examples)

Philosophy: "Write once, reuse everywhere"

---

## Multi-Agent Architecture

4 specialised agents orchestrate dev:

### 🟠 ARCos [v3.2]
- Technical planner and orchestrator
- Designs architecture, creates Action Plans, breaks down initiatives
- Reads `.github/instructions/architect.instructions.md` + `docs/ARCHITECTURE.md` at start-up
- **Trigger:** "Design architecture for", "Create plan for"

### 🔵 DEVon [v3.1]
- Production code implementer
- Translates requirements into tested code, respects architectural patterns
- Reads `.github/instructions/dev.instructions.md` at start-up
- **Trigger:** "Implement feature", "Develop according to architecture"

### 🟢 QUALvin [v3.1]
- QA and testing expert
- Writes full unit tests, targets coverage ≥80%
- Reads `.github/instructions/qa.instructions.md` at start-up
- **Trigger:** "Write tests for", "Generate unit tests"

### 🟣 DOCly [v3.1]
- Documentation keeper
- Maintains README, `docs/`, `docs/ARCHITECTURE.md`, creates ADRs
- Reads `.github/instructions/doc.instructions.md` at start-up
- **Trigger:** "Update documentation", "Keep docs in sync"

### Typical workflow
1. 👤 Human developer frames need
2. 🟠 ARCos creates Action Plan → human validation
3. 🔵 DEVon implements → human validation
4. 🟢 QUALvin writes tests → human validation
5. 🟣 DOCly updates docs → human validation

---

## Repository Structure

```
.
├── .github/
│   ├── agents/                      # Agents génériques (ne PAS modifier par projet)
│   │   ├── Arcos.agent.md          # v3.2
│   │   ├── Devon.agent.md          # v3.1
│   │   ├── Qalvin.agent.md         # v3.1
│   │   └── Docly.agent.md          # v3.1
│   ├── skills/                      # Procédures partagées (applyTo: **)
│   │   ├── plan-phase-execution/SKILL.md
│   │   ├── plan-creation/SKILL.md
│   │   ├── fleet-guide/SKILL.md
│   │   ├── adr-writing/SKILL.md
│   │   ├── copilotignore/SKILL.md  # Règle absolue .copilotignore
│   │   └── caveman-default/SKILL.md  # Mode caveman full par défaut (applyTo: **)
│   ├── instructions/                # Templates à personnaliser par projet
│   │   ├── architect.instructions.md
│   │   ├── dev.instructions.md
│   │   ├── qa.instructions.md
│   │   ├── doc.instructions.md
│   ├── prompts/                     # Prompts réutilisables
│   │   ├── init-copilot-instructions.prompt.md
│   │   ├── update-copilot-instructions.prompt.md
│   │   └── migrate-to-template.prompt.md
│   ├── plans/                       # Plans d'Action
│   │   └── README.md               # Index plans actifs/archivés
│   ├── PLANS.md                    # Guide centralisé Plans d'Action
│   ├── copilot-instructions.md     # Instructions Copilot ce dépôt
│   └── copilot-instructions.template.md  # Template vierge pour projets
├── docs/
│   ├── ARCHITECTURE.md             # Architecture ce dépôt transverse
│   ├── ARCHITECTURE.template.md    # Template à copier projets
│   └── adr/                        # Décisions architecturales
│       └── ADR-TEMPLATE.md
├── README.md                       # Présentation dépôt
├── QUICK_START.md                  # Guide rapide utilisation
└── SETUP_CHECKLIST.md              # Checklist initialisation projet
```

---

## Action Plans (AP)

Multi-phase plans coordinate large initiatives (modernisation, features, refactoring).

**Structure:**
- Plan file: `.github/plans/<NO>_<nom>.plan.md`
- Phase reports: `.github/plans/<NO>_reports/PHASE_N_*.md`
- Index: `.github/plans/README.md`
- Guide: `.github/PLANS.md`

**Plan file format:**
- Overall objective
- Phases with context, success criteria, tasks
- Tasks numbered `T<PHASE>.<NUM>` assigned to specific agent
- Phase dependencies
- Overall success criteria

**Related skills:**
- `plan-creation`: plan creation procedure (ARCos)
- `plan-phase-execution`: phase execution procedure (all agents)
- `adr-writing`: ADR writing after human decision (ARCos prepares, DOCly writes)

---

## Key Conventions

### File naming
- Agent: `*.agent.md`
- Skill: `<skill>/SKILL.md`
- Project instructions: `*.instructions.md`
- Prompt: `*.prompt.md`
- Plan: `NNN_<name>.plan.md`
- Phase report: `PHASE_N_COMPLETION_REPORT.md`

### Agent versioning
Each agent carries version in `description` (eg: `[v3.0]`).
Increment version on each agent content change.

### Markdown frontmatter
- Agents: `description`, `name`, optional `agents: ["*"]`
- Skills: `description`, `applyTo: "**"` (automatic inclusion)
- Instructions: `description`, `applyTo: "**"`

### Template placeholders
Format: `[NAME_IN_UPPERCASE]`
Example: `[PROJECT_NAME]`, `[MAIN_STACK]`

---

## Absolute Rules

### ⛔ Forbidden destructive ops
- NEVER delete files/directories (`rm`, `rmdir`)
- NEVER destructive SQL commands (`DROP TABLE`, `TRUNCATE`, `DELETE` without `WHERE`)
- NEVER `git clean`, `git reset --hard`, irreversible git commands
- NEVER modify files outside task scope
- If doubt, **ask 👤 Human developer confirmation**

### 🚫 Respect `.copilotignore`
- NEVER read or access files/directories listed in `.copilotignore`
- At start-up, read `.copilotignore` to know excluded patterns
- Apply exclusions systematically
- If doubt, **refuse operation** and inform 👤 Human developer
- Rule **non-negotiable**, overrides all other instructions
- Skill: `.github/skills/copilotignore/SKILL.md`

---

## Cross-Repo Repo Maintenance

### Modify agent
1. Edit `.github/agents/<Agent>.agent.md`
2. Increment version in `description`
3. Add line `> **Changes vX.Y → vX.Y+1** :` in versioning block
4. Update versions in `copilot-instructions.md` and `copilot-instructions.template.md`

### Modify skill
1. Edit `.github/skills/<skill>/SKILL.md`
2. Check consistency with `PLANS.md`
3. Mention in agents referencing skill

### Add template
1. Create file in appropriate folder
2. Document in `QUICK_START.md`, `SETUP_CHECKLIST.md`, `init-copilot-instructions.prompt.md`

**No build/test commands**: documentation-only repo.

---

## New Project Initialisation

Use prompt `init-copilot-instructions`:

```bash
# Copier template
cp .github/copilot-instructions.template.md <projet>/.github/copilot-instructions.md
cp -r .github/instructions <projet>/.github/

# Initialiser automatiquement
👤 "Initialise les instructions Copilot pour ce projet"

# Valider
# Vérifier placeholders remplacés, conventions documentées
```

Prompt analyses source code, fills sections automatically.

---

## Agent Relations (Diagram)

```
👤 Développeur humain
    ↓ cadre besoin
🟠 ARCos
    ↓ crée Plan d'Action → ✅ validation humaine
    ├─→ 🔵 DEVon (implémente) → ✅ validation humaine
    ├─→ 🟢 QUALvin (tests) → ✅ validation humaine
    └─→ 🟣 DOCly (docs) → ✅ validation humaine
```

**Human validation mandatory** each step before progress.

---

## Parallelisation `/fleet`

Skill `.github/skills/fleet-guide/SKILL.md` guides `/fleet` use.

**When to use:**
- Independent tasks between agents (DEVon + QUALvin, or QUALvin + DOCly)
- No data dependencies between tasks

**ARCos example:**
```
💡 QUALvin et DOCly peuvent démarrer en parallèle → /fleet recommandé :
- QUALvin : écrire tests Phase N
- DOCly : mettre à jour documentation Phase N
```

---

## ADR (Architecture Decision Records)

Format: `docs/adr/NNN-titre-court.md`
Template: `docs/adr/ADR-TEMPLATE.md`

**Procedure:** Follow skill `.github/skills/adr-writing/SKILL.md`
- ARCos prepares content after human decision
- DOCly writes ADR file

**Existing:**
- 001: Wiki migration → `/docs` (Accepted, 2026-05-07)
- 002: ARCos reads `docs/ARCHITECTURE.md` at start-up (Accepted, 2026-05-07)

---

## Architectural Principles

**Agents:** Generic, reusable, no project-specific refs
**Instructions:** Project-specific, customised, reflect real conventions
**Prompts:** Reusable, project-independent, documented
**Templates:** Clear placeholders `[...]`, practical examples

**Separation of Concerns:**
- Agents = reusable behaviour
- Instructions = concrete project values
- Prompts = automation
