# 🏗️ Architecture — Copilot Cross-Repository

> This document describes the architecture and principles of this multi-agent template repository.  
> Complete the **⚠️ TO COMPLETE** sections as the repository evolves.

---

## 🎯 Overview

The **Copilot cross-repository** is a reusable set of templates, agents and prompts for orchestrating development with GitHub Copilot through a **coordinated multi-agent** architecture.

| Property | Value |
|---|---|
| **Type** | Template repository / Copilot infrastructure |
| **Main stack** | Markdown, YAML (agent frontmatter) |
| **Target platform** | GitHub Copilot CLI (any type of consumer project) |
| **Language** | English (content), English (code examples) |
| **Status** | In active development |

**Philosophy:** *"Write once, reuse everywhere"*
- 🎯 **Genericity**: agents remain stable from one project to another
- 🔧 **Minimal customisation**: `[...]` placeholders allow quick adaptation
- 🔄 **Versioning**: each agent carries a version to track changes
- 🚀 **Efficiency**: initialise Copilot in 3 steps maximum

---

## 🏢 Overall Architecture

### Principles for separating responsibilities

```
Dépôt Transverse Copilot
├── agents/          # Comportements génériques et réutilisables (non modifiés par projet)
├── instructions/    # Valeurs spécifiques au projet cible (à personnaliser via [placeholders])
├── prompts/         # Commandes réutilisables pour initialiser, auditer et migrer
├── plans/           # Orchestration du travail multi-phases
└── docs/            # Documentation de ce dépôt transverse
    └── adr/         # Décisions architecturales
```

### Usage flow (consumer project)

```
Nouveau Projet
    → [Copier agents/, instructions/, prompts/, docs/ARCHITECTURE.template.md]
    → [Exécuter prompt init-copilot-instructions]
    → copilot-instructions.md + instructions/*.md  (customisés pour le projet)
    → [Au démarrage de session, chaque agent lit son fichier d'instructions]
        ├── ARCos  (🟠 ARC) ← architect.instructions.md + docs/ARCHITECTURE.md
        ├── DEVon  (🔵 DEV) ← dev.instructions.md
        ├── QUALvin(🟢 QUAL)← qa.instructions.md
        └── DOCly  (🟣 DOC) ← doc.instructions.md
    → [L'équipe utilise les agents via Copilot]
```

### Architectural principles

| Principle | Description |
|---|---|
| **Reusability** | All agent files are generic and ready to use in any project |
| **Separation of Concerns** | Agents = behaviour · Instructions = project values · Prompts = automation |
| **Versioning** | Each agent starts with `[vX.Y]` to track changes |
| **Minimal customisation** | The template allows quick and complete initialisation in 3 steps |

---

## 📂 Folder Structure

```
.                                                # Racine du dépôt transverse
├── README.md                                    # Présentation du dépôt
├── QUICK_START.md                               # Démarrage rapide (3 étapes)
├── SETUP_CHECKLIST.md                           # Checklist d'initialisation
│
├── docs/                                        # Documentation versionnée
│   ├── ARCHITECTURE.md                          # Ce fichier
│   ├── ARCHITECTURE.template.md                 # Template à copier dans les projets
│   └── adr/                                     # Architecture Decision Records
│       └── ADR-TEMPLATE.md                      # Template ADR
│
└── .github/
    ├── README.md                                # Guide complet d'utilisation
    ├── PLANS.md                                 # Guide des Plans d'Action
    ├── copilot-instructions.md                  # Template générique (version par défaut)
    ├── copilot-instructions.template.md         # Template original avec placeholders
    │
    ├── agents/                                  # 🤖 Rôles réutilisables
    │   ├── Arcos.agent.md                       # Planificateur / orchestrateur [v3.1]
    │   ├── Devon.agent.md                       # Implémentateur de code [v3.1]
    │   ├── Qalvin.agent.md                      # Expert QA [v3.1]
    │   └── Docly.agent.md                       # Gestionnaire documentation [v3.1]
    │
    ├── skills/                                  # 🛠️ Procédures partagées (applyTo: **)
    │   ├── plan-phase-execution/SKILL.md        # Exécution phase AP
    │   ├── plan-creation/SKILL.md               # Création Plan d'Action
    │   ├── fleet-guide/SKILL.md                 # Guide parallélisation /fleet
    │   ├── adr-writing/SKILL.md                 # Rédaction ADR
    │   ├── copilotignore/SKILL.md               # Règle absolue .copilotignore
    │   └── caveman-default/SKILL.md             # Mode caveman full par défaut
    │
    ├── instructions/                            # 📐 Spécificités projet (à compléter par projet)
    │   ├── architect.instructions.md            # ARCos : architecture, SQL handoff, ADR
    │   ├── dev.instructions.md                  # DEVon : stack, code, HTTP, modèles
    │   ├── qa.instructions.md                   # QUALvin : tests, commandes CI, couverture
    │   └── doc.instructions.md                  # DOCly : docs/, ARCHITECTURE.md, ADRs
    │
    ├── prompts/                                 # 🎯 Commandes réutilisables
    │   ├── init-copilot-instructions.prompt.md  # Initialiser un nouveau projet
    │   ├── update-copilot-instructions.prompt.md# Maintenir les instructions à jour
    │   └── migrate-to-template.prompt.md        # Migrer un projet existant
    │
    ├── examples/                                # 📖 Exemples concrets
    │   └── copilot-instructions-domoticz.example.md  # React Native / Expo
    │
    └── plans/                                   # 📅 Plans d'Action
        └── README.md                            # Index des plans
```

---

## 🔧 Main Components

### 🤖 Agents (`.github/agents/`)

Each agent is a generic **role model** defined in Markdown with YAML frontmatter.

| Agent | File | Version | Role |
|---|---|---|---|
| 🟠 ARCos | `Arcos.agent.md` | v3.1 | Planner / orchestrator |
| 🔵 DEVon | `Devon.agent.md` | v3.1 | Code implementer |
| 🟢 QUALvin | `Qalvin.agent.md` | v3.1 | QA and testing expert |
| 🟣 DOCly | `Docly.agent.md` | v3.1 | Documentation manager |

**Characteristics:**
- ✅ Generic (no dependencies on a specific project)
- ✅ Versioned (incremented on each behavioural change)
- ✅ Independent (can be copied into a project on their own)
- ✅ Ready to use (no modification needed to start)

### 📐 Agent instructions (`.github/instructions/`)

These files complement the generic agents with the **specifics of the target project**.

| File | Agent | Content |
|---|---|---|
| `architect.instructions.md` | 🟠 ARCos | Architectural conventions, SQL hand-off protocol, ADR |
| `dev.instructions.md` | 🔵 DEVon | Technology stack, code conventions, organisation |
| `qa.instructions.md` | 🟢 QUALvin | Test stack, CI commands, cases to cover |
| `doc.instructions.md` | 🟣 DOCly | `docs/` structure, writing conventions |

> **Difference from the agents:** Agents = reusable behaviour · Instructions = concrete project values

### 🎯 Prompts (`.github/prompts/`)

| Prompt | Role |
|---|---|
| `init-copilot-instructions` | Analyses the source code, fills the main template and the 4 `instructions/` files |
| `update-copilot-instructions` | Audits the code, checks outdated values and unfilled placeholders |
| `migrate-to-template` | Guide for transforming a legacy project into this system |

### 📄 Templates (`docs/`)

| File | Role |
|---|---|
| `docs/ARCHITECTURE.template.md` | `docs/ARCHITECTURE.md` template to copy into each project |
| `docs/adr/ADR-TEMPLATE.md` | ADR template to copy for each architectural decision |
| `.github/copilot-instructions.template.md` | `copilot-instructions.md` template with placeholders |

---

## 📐 Conventions and Invariants

### Agents — must remain generic
- No references to a specific project in `.agent.md` files
- No paths relative to a particular project
- Increment the version on every behavioural change

### Instructions — must be specific
- Customised for each consumer project
- Reflect real conventions (not assumptions)
- Updated regularly (`update-copilot-instructions` prompt)

### Prompts — must be reusable
- Independent of the project
- Clearly documented in their YAML frontmatter
- Tested in several contexts

### Templates — must have clear placeholders
- Format: `[DESCRIPTION_OF_WHAT_IS_MISSING]`
- Visible filling instructions
- Practical examples: `[PROJECT_NAME]`, `[MAIN_STACK]`

### `instructions/` files — must remain initialisable
- Explicit and understandable `[...]` placeholders
- Filled in project by project during initialisation
- Synchronised with the real stack, paths and versions

---

## 🗺️ Architectural Decisions (ADR)

> Major architectural decisions are documented in `docs/adr/`.  
> Format: `docs/adr/NNN-short-title.md` — use `docs/adr/ADR-TEMPLATE.md` as the base.

| # | Decision | Status | Date |
|---|---|---|---|
| 001 | Wiki documentation migration → `/docs` | Accepted | 2026-05-07 |
| 002 | ARCos reads `docs/ARCHITECTURE.md` at start-up | Accepted | 2026-05-07 |

> 💡 Each new major decision in this cross-repository should be covered by an ADR.

---

## 🚀 Typical Usage

### New project

```bash
# 1. Copier les fichiers essentiels
cp -r copilot-templates/.github/agents mon-projet/.github/
cp -r copilot-templates/.github/instructions mon-projet/.github/
cp copilot-templates/.github/*.md mon-projet/.github/
mkdir -p mon-projet/docs/adr
cp copilot-templates/docs/ARCHITECTURE.template.md mon-projet/docs/ARCHITECTURE.md
cp copilot-templates/docs/adr/ADR-TEMPLATE.md mon-projet/docs/adr/

# 2. Initialiser avec le prompt
👤 "Initialise les instructions Copilot pour ce projet"

# 3. Vérifier et enrichir
👤 "Complète les instructions Copilot depuis le code source"
```

### Existing project

```bash
# Utiliser le prompt de migration
👤 "Aide-moi à migrer ce projet vers les templates Copilot"
```

---

## 📊 Inventory

| Item | Count | Generic |
|---|---|---|
| Agents | 4 | ✅ Yes |
| Prompts | 3 | ✅ Yes |
| Instruction templates | 4 | ✅ Yes (with placeholders) |
| Documentation templates | 2 | ✅ Yes (ARCHITECTURE + ADR) |
| Examples | 1 | ✅ Yes |

---

## 🔄 Maintenance

### Updating agents

1. Modify `.github/agents/<Agent>.agent.md`
2. Increment the version: `[vX.Y]` → `[vX.Y+1]`
3. Document the changes in the frontmatter (line `> **Changes...`)
4. Update the inventory table above

### Updating templates

1. Modify `docs/ARCHITECTURE.template.md` or `.github/copilot-instructions.template.md`
2. Consumer projects resynchronise via the prompts

### Adding a new prompt

1. Create `.github/prompts/<name>.prompt.md`
2. Document its role in the YAML frontmatter
3. Reference it in `.github/README.md`

---

## 📝 Version History

| Version | Date | Major changes |
|---|---|---|
| v3.1 | 2026-06-11 | FINNops agent removed; `adr-writing` and `caveman-default` skills added |
| v3.0 | 2026-05-28 | Global activation of `caveman` mode in all agents + instruction compression |
| v2.1 | 2026-05-07 | Wiki migration → `/docs`; ARCHITECTURE.md and ADR templates added |
| v2.0 | 2026-05-05 | `/fleet` parallelisation added in all agents |

---

## 🔗 Resources

- **README** : [`.github/README.md`](.github/README.md)
- **Action Plan Guide** : [`.github/PLANS.md`](.github/PLANS.md)
- **Checklist** : [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md)
- **ADRs** : [`docs/adr/`](./adr/)
- **Examples** : [`.github/examples/`](.github/examples/)
