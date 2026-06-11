---
description: Project-specific details for [PROJECT_NAME] for the 🟣 DOCly (doc) agent
applyTo: "**"
---

# Project-specific details — [PROJECT_NAME] (Doc)

> File automatically read by 🟣 DOCly at start-up.
> Contains project-specific details for `[PROJECT_NAME]` (`[SHORT_PROJECT_DESCRIPTION]`, for example: React/TypeScript frontend).

## Workflow

1. Check `*-doc` todos whose dependencies are `done`.
2. Move the todo to `in_progress`.
3. Identify impacted documentation files.
4. Make precise updates (not a full rewrite unless necessary).
5. Move to `done`.

## Files under your responsibility

### In the project root
- `README.md` – general description, prerequisites, quick start
- `.github/copilot-instructions.md` – context for future Copilot sessions

### In `docs/` (versioned documentation)
- `docs/ARCHITECTURE.md` (**mandatory**) – project architecture (stack, structure, layers, data flow)
- `docs/adr/` – Architecture Decision Records produced by ARCos (for example: `docs/adr/001-choix-framework.md`)
- `[HISTORY_FILE].md` – new versions to document
- `[DEPLOYMENT_FILE].md` – deployment procedures for [DEPLOYMENT_PLATFORM]
- `schemas/*.puml` – C2/C3 PlantUML diagrams (framework versions to maintain)

### In `.github/skills/` (shared procedures)
- `plan-phase-execution/SKILL.md` – AP phase execution procedure
- `plan-creation/SKILL.md` – plan creation procedure
- `fleet-guide/SKILL.md` – `/fleet` guide

> Update these files if AP procedures or `/fleet` change (consistency with `.github/PLANS.md`).

## Documentation conventions

- **Language**: French for content, English for code blocks.
- **`docs/ARCHITECTURE.md` is mandatory**: every project must have a file describing its architecture.
- **ADRs**: every major architectural decision produces a `docs/adr/NNN-titre.md` file.
- **Versions to keep up to date** in `.puml`: [FRONTEND_FRAMEWORK] (currently **[VERSION_FRONTEND]**), [BACKEND_FRAMEWORK] (currently **[VERSION_BACKEND]**).
- **Never** mention the old repo name `[OLD_REPO_NAME]` – now `[CURRENT_REPO_NAME]`.
- When a new version is released, add an entry to `[HISTORY_FILE].md` **at the top** of the file.
- Index `.github/plans/README.md` must remain a summary: **plans + overall status only** (without phases).

## What you do NOT do

- Do not modify source code (`*.[tsx|ts|js|py|...]`).
- Do not create new tests (🟢 QUALvin's role).
- Do not make architectural decisions (🟠 ARCos's role).
