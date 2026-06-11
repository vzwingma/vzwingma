# 📚 Copilot Templates & Agents — Cross-Project Repository

This repository contains the **reusable templates** and **agent instructions** for orchestrating development with Copilot using a **co-ordinated multi-agent** architecture.

---

## 📂 Structure

```
.
├── docs/                                # Documentation versionnée du dépôt
│   ├── ARCHITECTURE.md                  # Architecture de ce dépôt transverse
│   ├── ARCHITECTURE.template.md        # Template à copier dans les projets
│   └── adr/                            # Architecture Decision Records
│       └── ADR-TEMPLATE.md             # Template ADR
│
└── .github/
    ├── agents/                              # Définitions des agents Copilot
    │   ├── Arcos.agent.md                   # Agent planificateur (🟠 ARC - Arcos)
    │   ├── Devon.agent.md                   # Agent implémenteur (🔵 DEV - Devon)
    │   ├── Qalvin.agent.md                  # Agent QA et tests (🟢 QUAL - Qalvin)
    │   └── Docly.agent.md                   # Agent documentation (🟣 DOC - Docly)
    │
    ├── instructions/                        # 🆕 Instructions spécifiques projet
    │   ├── architect.instructions.md        # ARCos — conventions architecturales
    │   ├── dev.instructions.md              # DEVon — stack et conventions code
    │   ├── qa.instructions.md               # QUALvin — tests et commandes
    │   └── doc.instructions.md              # DOCly — documentation et /docs
    │
    ├── prompts/                             # Prompts pour initialiser des tâches
    │   ├── init-copilot-instructions.prompt.md      # 🆕 Initialiser copilot-instructions.md
    │   ├── update-copilot-instructions.prompt.md    # Auditer et mettre à jour les instructions
    │   └── migrate-to-template.prompt.md            # Migrer un projet existant vers le template
    │
    ├── plans/                               # (Optionnel) Exemples de Plans d'Action
    │   ├── README.md                        # Index des plans
    │   └── [plans et rapports]
    │
    ├── copilot-instructions.template.md     # 🆕 Template générique à customiser
    ├── copilot-instructions.md              # Template générique (copie du .template.md)
    └── PLANS.md                             # Guide pour les Plans d'Action
```

---

## 🚀 Quick Start: Initialise Copilot in a New Project

### Step 1: Copy the template

Copy `.github/copilot-instructions.template.md` into your project:

```bash
# Depuis le dépôt transverse vers votre projet
cp .github/copilot-instructions.template.md <votre_projet>/.github/copilot-instructions.md
```

### Step 2: Use the initialisation prompt

Use the **`.github/prompts/init-copilot-instructions.prompt.md`** prompt to **generate the instructions automatically**:

```
👤 Utilisateur: "Initialise les instructions Copilot pour ce projet"
```

Or with the Copilot CLI:
```bash
copilot prompt run init-copilot-instructions
```

The prompt will:
1. ✅ Read the template
2. ✅ Analyse your source code
3. ✅ Fill the placeholders automatically
4. ✅ Generate `.github/copilot-instructions.md`

### Step 3: Validate and enrich (optional)

If your project has specific conventions that were not detected, use the **`.github/prompts/update-copilot-instructions.prompt.md`** prompt to audit and enrich:

```
👤 Utilisateur: "Complète les instructions Copilot depuis le code source"
```

---

## 📖 Key Files

### Agents (`.github/agents/`)

Each agent file defines a role, its responsibilities and how it interacts with the other agents.

| Agent | Role | When to use it |
|---|---|---|
| **Arcos.agent.md** (🟠 ARC) | Technical planner | "Design an architecture for..." |
| **Devon.agent.md** (🔵 DEV) | Code implementer | "Implement this feature" |
| **Qalvin.agent.md** (🟢 QUAL) | QA and testing expert | "Write tests for this component" |
| **Docly.agent.md** (🟣 DOC) | Documentation manager | "Update the documentation" |

All agents are **generic and reusable** in any project. Project-specific Copilot instructions are located in `.github/copilot-instructions.md`.

> The agents are **generic**. At start-up, they read their corresponding `instructions/` file for project-specific details.

### Prompts (`.github/prompts/`)

Reusable prompts for recurring tasks.

| Prompt | Role | Usage |
|---|---|---|
| **init-copilot-instructions.prompt.md** | 🆕 Initialise `copilot-instructions.md` and the `instructions/` files | `copilot prompt run init-copilot-instructions` |
| **update-copilot-instructions.prompt.md** | Audit and update `copilot-instructions.md` and the `instructions/` files | `copilot prompt run update-copilot-instructions` |
| **migrate-to-template.prompt.md** | Migrate an existing project | `copilot prompt run migrate-to-template` |

### Templates

| File | Role | Usage |
|---|---|---|
| **copilot-instructions.template.md** | Generic template with placeholders | Copy and customise in a new project |
| **copilot-instructions.md** | "Default generic" version | Example of a base file |
| **instructions/*.instructions.md** | 4 templates to complete per project | Copy and fill the placeholders |
| **docs/ARCHITECTURE.template.md** | `docs/ARCHITECTURE.md` template | Copy into the target project's `docs/ARCHITECTURE.md` |
| **docs/adr/ADR-TEMPLATE.md** | ADR template | Copy into `docs/adr/NNN-titre.md` for each decision |

### Examples (`.github/examples/`)

Concrete examples of instructions for different kinds of projects.

| Example | Project type | Usage |
|---|---|---|
| **copilot-instructions-domoticz.example.md** | React Native / Expo | Reference for mobile projects |

### Documentation

| File | Role |
|---|---|
| **PLANS.md** | Complete guide for creating and executing Action Plans |

---

## 🎯 Typical Workflow with Copilot

```
1️⃣ Utilisateur cadre le besoin
   ↓
2️⃣ Arkos (🟠 ARC) crée un Plan d'Action
   ↓
3️⃣ Devon (🔵 DEV) implémente les tâches
   ↓
4️⃣ Qalvin (🟢 QUAL) écrit les tests
   ↓
5️⃣ Docly (🟣 DOC) met à jour la documentation
   ↓
6️⃣ Phase suivante du plan (retour à 2️⃣)
```

To learn more, read `.github/PLANS.md`.

---

## ✅ Checklist for Initialising a New Project

- [ ] Copy `.github/copilot-instructions.template.md` → `.github/copilot-instructions.md`
- [ ] Copy `.github/instructions/` → the project's `.github/instructions/`
- [ ] Use the `init-copilot-instructions` prompt to fill in the sections
- [ ] Fill in the placeholders in the 4 `instructions/` files
- [ ] Validate that all placeholders are replaced
- [ ] (Optional) Use `update-copilot-instructions` to enrich from the code
- [ ] Commit `.github/copilot-instructions.md` to the repo
- [ ] The agents are ready! Use `/solve` or call them by name

---

## 📚 Resources

- **Architecture**: `docs/ARCHITECTURE.md` — architecture of this cross-project repository
- **Docs templates**: `docs/ARCHITECTURE.template.md` + `docs/adr/ADR-TEMPLATE.md`
- **Generic agents**: Present in this repository, ready to use
- **Reusable prompts**: `.github/prompts/` — adapt to the project's context
- **Templates**: `.github/copilot-instructions.template.md` — customise for your project
- **Agent instructions**: `.github/instructions/` — to customise per project
- **Examples**: `.github/examples/` — references for different project types
- **Action Plans**: `.github/PLANS.md` — guide for orchestrating multi-phase work

---

## 🔄 Maintenance

### Update the agents

If agent versions change (for example: `Devon [v1.8]`), update the `.github/agents/*.md` files.

### Update a project's instructions

Use the `update-copilot-instructions` prompt regularly to keep the instructions aligned with the real code.

---

## 🤝 Contribution

To add a new agent, prompt or template:

1. Create the file in the appropriate folder (`.github/agents/`, `.github/prompts/`, etc.)
2. Follow the existing conventions (YAML frontmatter format for agents/prompts)
3. Test in a sandbox project before committing
4. Document it in this README

---

**Last updated:** 2026-05-05
