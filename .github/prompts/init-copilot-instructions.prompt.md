---
name: init-copilot-instructions
description: >
  Initialises Copilot instructions for a new project. Use for:
  "initialise Copilot instructions", "generate instructions for this project",
  "create a copilot-instructions.md", "configure Copilot for this project".
  Takes the project type as a parameter and extracts information from the source code.
agent: agent
---

# Initialising Copilot Instructions

> **Prerequisites**: Before running the prompt, the following files must exist in the target project (copied from the transverse repository):
> - `.github/agents/` — 4 generic agents (`Arcos.agent.md`, `Devon.agent.md`, `Qalvin.agent.md`, `Docly.agent.md`)
> - `.github/prompts/` — reusable prompts
> - `.github/PLANS.md` — Action Plan guide
>
> The prompt initialises only **project-specific** files: `copilot-instructions.md` and the 4 `instructions/` files.
> To copy prerequisites, first use the `migrate-to-template` prompt.

Mission: **generate and initialise** the `.github/copilot-instructions.md` file for a new project, based on:

1. **Generic template** (`.github/copilot-instructions.template.md`) present in the transverse repository
2. **Target project source code analysis**
3. **Real conventions** applied in the code

## 📋 Steps

### 1. Read the generic template

Read `.github/copilot-instructions.template.md` in full to understand the base structure.

### 2. Analyse the target project

Browse the repository and identify:

- **Project structure**: Explore the main folders (src/, app/, lib/, etc.)
- **Technology stack**: Identify the language (TypeScript, Python, Go, etc.), main framework (React, Vue, Django, Spring, etc.)
- **Project type**: Categorise (frontend, backend, full-stack, mobile, CLI, library, etc.)
- **Platform**: Web, mobile (iOS/Android), desktop, CLI, API, etc.
- **State management**: Context API, Redux, Zustand, MobX, etc. (if relevant)
- **Architectural patterns**: Layers (components, services, models), DDD, MVVM, etc.
- **Existing conventions**: File naming, imports, styling, testing patterns, etc.

### 3. Fill in the template sections

For each `[...]` placeholder in the template, provide a suitable value:

| Placeholder | Source of information | Example |
|---|---|---|
| `[NOM_DU_PROJET]` | Repo name or package.json name | "Domoticz Mobile", "API-Gateway", "Design System" |
| **Project Overview** | README, description, package.json, main.swift, etc. | Tech stack, business domain, platforms |
| **Commands** | package.json scripts, Makefile, build scripts, etc. | `npm start`, `npm test`, `go build`, etc. |
| **Architecture** | Folder structure + observed patterns | ASCII diagram or hierarchical description |
| **Key Conventions** | Existing files in the codebase | Naming, TypeScript config, ESLint, Prettier, etc. |
| **Project State** | Code analysis + notes | Maintenance state, error patterns, key dependencies |

> 💡 **Possible parallelisation**: Steps 4 and 5 (generating `copilot-instructions.md` and the 4 `instructions/` files) can be executed in parallel with `/fleet` if the analysis information (step 2) is available.

### 4. Generate the file

Create `.github/copilot-instructions.md` by:
1. Copying the template
2. Replacing all placeholders with project values
3. Removing `[📌 À COMPLÉTER : ...]` sections if filled in
4. Keeping generic sections (agents, workflow, action plans, diagrams)

### 5. Generate the agent instruction files

Read the 4 templates in `.github/instructions/` from the transverse repository:
- `architect.instructions.template.md` — instruction template for the ARCos agent
- `dev.instructions.template.md` — instruction template for the DEVon agent
- `qa.instructions.template.md` — instruction template for the QUALvin agent
- `doc.instructions.template.md` — instruction template for the DOCly agent

For each file, fill in placeholders with the values identified during analysis (step 2):
- `[NOM_DU_PROJET]` → project name
- `[DESCRIPTION_COURTE_DU_PROJET]` → short description (for example: React/TypeScript frontend)
- For `dev.instructions.md`: stack, versions, constants files, HTTP service, convention folders
- For `qa.instructions.md`: test framework, CI commands, coverage report paths, context names
- For `doc.instructions.md`: local docs/ path, documentation file names, frameworks + versions for `.puml`
- For `architect.instructions.md`: project layers, state provider names, HTTP service, routing

Create 4 files in the target project's `.github/instructions/` folder (or update them if they already exist), named `architect.instructions.md`, `dev.instructions.md`, `qa.instructions.md`, `doc.instructions.md`.
If some values cannot be determined from the code, keep the `[...]` placeholders and report them explicitly.

### 6. Audit and enrich (optional)

If the project has other reference files (CONTRIBUTING.md, ARCHITECTURE.md, BEST_PRACTICES.md, etc.), read them and enrich the corresponding sections of the generated file.

## ✅ Delivery Checklist

- [ ] `.github/copilot-instructions.md` file created
- [ ] `.github/instructions/*.instructions.md` files created from `*.instructions.template.md` templates (4 files: architect, dev, qa, doc)
- [ ] All `[...]` placeholders replaced with real values
- [ ] Critical placeholders replaced (minimum: NOM_DU_PROJET, technical stack)
- [ ] `[📌 À COMPLÉTER : ...]` sections removed or completed
- [ ] Section structure preserved (order, hierarchy)
- [ ] Generic sections intact (Agents, Workflow, Action Plans, Diagrams)
- [ ] Code examples from the real codebase (if relevant)
- [ ] No references to non-existent files
- [ ] French retained for all narrative text
- [ ] File readable and properly formatted (Markdown)
- [ ] `.github/agents/` contains 4 files (`Arcos.agent.md`, `Devon.agent.md`, `Qalvin.agent.md`, `Docly.agent.md`)
- [ ] `.github/skills/` contains 4 shared skills (`plan-phase-execution/SKILL.md`, `plan-creation/SKILL.md`, `fleet-guide/SKILL.md`, `adr-writing/SKILL.md`)
- [ ] `.github/PLANS.md` accessible
- [ ] `docs/ARCHITECTURE.md` exists (create from template: `cp docs/ARCHITECTURE.template.md docs/ARCHITECTURE.md`)
- [ ] `docs/adr/` exists (create if absent: `mkdir -p docs/adr`)

## 💡 Tips

1. **Be precise**: Observe and describe what actually exists, not assumptions
2. **Be concise**: Copilot instructions are read regularly; stay concise
3. **Be practical**: Include real commands, real observed patterns
4. **Keep the structure**: Do not reorganise template sections, unless highly relevant
5. **Examples from the code**: Where useful, include patterns extracted from real source code

## 🎯 Result

At the end, the `.github/copilot-instructions.md` file must be the **source of truth** for Copilot:
- Faithfully describes the state of the project
- Provides clear, applied conventions
- Guides agents in the context of the specific project
- Stays up to date and maintained by the project