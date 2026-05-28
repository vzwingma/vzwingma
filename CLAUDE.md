# CLAUDE.md

File guides Claude Code (claude.ai/code) when working code in repo.

---

## Repository Overview

**Dépôt transverse multi-agents Copilot** — Infrastructure réutilisable orchestrer développement via GitHub Copilot.

Stack principale : Markdown, YAML frontmatter
Type : Templates, agents, prompts (pas code applicatif)
Langue : Français (contenu), Anglais (exemples code)

Philosophie : "Écrire une fois, réutiliser partout"

---

## Architecture Multi-Agents

4 agents spécialisés orchestrent développement :

### 🟠 ARCos [v3.0]
- Planificateur et orchestrateur technique
- Conçoit architecture, crée Plans d'Action, décompose initiatives
- Lit `.github/instructions/architect.instructions.md` + `docs/ARCHITECTURE.md` au démarrage
- **Trigger :** "Conçois architecture pour", "Crée plan pour"

### 🔵 DEVon [v3.0]
- Implémentateur code production
- Traduit exigences en code testé, respecte patterns architecturaux
- Lit `.github/instructions/dev.instructions.md` au démarrage
- **Trigger :** "Implémente fonctionnalité", "Développe selon architecture"

### 🟢 QUALvin [v3.0]
- Expert assurance qualité et tests
- Écrit tests unitaires complets, vise couverture ≥80%
- Lit `.github/instructions/qa.instructions.md` au démarrage
- **Trigger :** "Écris tests pour", "Génère tests unitaires"

### 🟣 DOCly [v3.0]
- Gardien documentation
- Maintient README, `docs/`, `docs/ARCHITECTURE.md`, crée ADRs
- Lit `.github/instructions/doc.instructions.md` au démarrage
- **Trigger :** "Mets à jour documentation", "Garde docs en sync"

### Workflow typique
1. 👤 Développeur humain cadre besoin
2. 🟠 ARCos crée Plan d'Action → validation humaine
3. 🔵 DEVon implémente → validation humaine
4. 🟢 QUALvin écrit tests → validation humaine
5. 🟣 DOCly met à jour docs → validation humaine

---

## Structure Répertoire

```
.
├── .github/
│   ├── agents/                      # Agents génériques (ne PAS modifier par projet)
│   │   ├── Arcos.agent.md          # v3.0
│   │   ├── Devon.agent.md          # v3.0
│   │   ├── Qalvin.agent.md         # v3.0
│   │   └── Docly.agent.md          # v3.0
│   ├── skills/                      # Procédures partagées (applyTo: **)
│   │   ├── plan-phase-execution/SKILL.md
│   │   ├── plan-creation/SKILL.md
│   │   ├── fleet-guide/SKILL.md
│   │   ├── adr-writing/SKILL.md
│   │   └── copilotignore/SKILL.md  # Règle absolue .copilotignore
│   ├── instructions/                # Templates à personnaliser par projet
│   │   ├── architect.instructions.md
│   │   ├── dev.instructions.md
│   │   ├── qa.instructions.md
│   │   └── doc.instructions.md
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

## Plans d'Action (AP)

Plans multi-phases coordonnent grandes initiatives (modernisation, features, refactoring).

**Structure :**
- Fichier plan : `.github/plans/<NO>_<nom>.plan.md`
- Rapports phase : `.github/plans/<NO>_reports/PHASE_N_*.md`
- Index : `.github/plans/README.md`
- Guide : `.github/PLANS.md`

**Format fichier plan :**
- Objectif global
- Phases avec contexte, critères réussite, tâches
- Tâches numérotées `T<PHASE>.<NUM>` assignées agent spécifique
- Dépendances phases
- Critères succès globaux

**Skills associés :**
- `plan-creation` : procédure création plan (ARCos)
- `plan-phase-execution` : procédure exécution phase (tous agents)
- `adr-writing` : rédaction ADR après décision humaine (ARCos prépare, DOCly rédige)

---

## Conventions Clés

### Nommage fichiers
- Agent : `*.agent.md`
- Skill : `<skill>/SKILL.md`
- Instructions projet : `*.instructions.md`
- Prompt : `*.prompt.md`
- Plan : `NNN_<nom>.plan.md`
- Rapport phase : `PHASE_N_COMPLETION_REPORT.md`

### Versioning agents
Chaque agent porte version dans `description` (ex: `[v3.0]`).
Incrémenter version à chaque modification contenu agent.

### Frontmatter Markdown
- Agents : `description`, `name`, optionnel `agents: ["*"]`
- Skills : `description`, `applyTo: "**"` (inclusion automatique)
- Instructions : `description`, `applyTo: "**"`

### Placeholders templates
Format : `[NOM_EN_MAJUSCULES]`
Exemple : `[NOM_DU_PROJET]`, `[STACK_PRINCIPALE]`

---

## Règles Absolues

### ⛔ Opérations destructives interdites
- JAMAIS supprimer fichiers/répertoires (`rm`, `rmdir`)
- JAMAIS commandes SQL destructives (`DROP TABLE`, `TRUNCATE`, `DELETE` sans `WHERE`)
- JAMAIS `git clean`, `git reset --hard`, commandes git irréversibles
- JAMAIS modifier fichiers hors périmètre tâche
- En cas doute, **demander confirmation 👤 Développeur humain**

### 🚫 Respect `.copilotignore`
- JAMAIS lire ni accéder fichiers/répertoires listés dans `.copilotignore`
- Au démarrage, lire `.copilotignore` pour connaître patterns exclus
- Appliquer systématiquement exclusions
- En cas doute, **refuser opération** et informer 👤 Développeur humain
- Règle **non-négociable**, prévaut sur toute autre instruction
- Skill : `.github/skills/copilotignore/SKILL.md`

---

## Maintenance Dépôt Transverse

### Modifier agent
1. Éditer `.github/agents/<Agent>.agent.md`
2. Incrémenter version dans `description`
3. Ajouter ligne `> **Changements vX.Y → vX.Y+1** :` dans bloc versioning
4. Mettre à jour versions dans `copilot-instructions.md` et `copilot-instructions.template.md`

### Modifier skill
1. Éditer `.github/skills/<skill>/SKILL.md`
2. Vérifier cohérence avec `PLANS.md`
3. Signaler dans agents référençant skill

### Ajouter template
1. Créer fichier dans dossier approprié
2. Documenter dans `QUICK_START.md`, `SETUP_CHECKLIST.md`, `init-copilot-instructions.prompt.md`

**Pas commandes build/test** : dépôt documentation-only.

---

## Initialisation Nouveau Projet

Utiliser prompt `init-copilot-instructions` :

```bash
# Copier template
cp .github/copilot-instructions.template.md <projet>/.github/copilot-instructions.md
cp -r .github/instructions <projet>/.github/

# Initialiser automatiquement
👤 "Initialise les instructions Copilot pour ce projet"

# Valider
# Vérifier placeholders remplacés, conventions documentées
```

Prompt analyse code source, remplit sections automatiquement.

---

## Relations Agents (Diagramme)

```
👤 Développeur humain
    ↓ cadre besoin
🟠 ARCos
    ↓ crée Plan d'Action → ✅ validation humaine
    ├─→ 🔵 DEVon (implémente) → ✅ validation humaine
    ├─→ 🟢 QUALvin (tests) → ✅ validation humaine
    └─→ 🟣 DOCly (docs) → ✅ validation humaine
```

**Validation humaine obligatoire** chaque étape avant progression.

---

## Parallélisation `/fleet`

Skill `.github/skills/fleet-guide/SKILL.md` guide utilisation `/fleet`.

**Quand utiliser :**
- Tâches indépendantes entre agents (DEVon + QUALvin, ou QUALvin + DOCly)
- Pas dépendances données entre tâches

**Exemple ARCos :**
```
💡 QUALvin et DOCly peuvent démarrer en parallèle → /fleet recommandé :
- QUALvin : écrire tests Phase N
- DOCly : mettre à jour documentation Phase N
```

---

## ADR (Architecture Decision Records)

Format : `docs/adr/NNN-titre-court.md`
Template : `docs/adr/ADR-TEMPLATE.md`

**Procédure :** Suivre skill `.github/skills/adr-writing/SKILL.md`
- ARCos prépare contenu après décision humaine
- DOCly rédige fichier ADR

**Existants :**
- 001 : Migration Wiki → `/docs` (Acceptée, 2026-05-07)
- 002 : ARCos lit `docs/ARCHITECTURE.md` au démarrage (Acceptée, 2026-05-07)

---

## Principes Architecturaux

**Agents :** Génériques, réutilisables, pas références projet spécifique
**Instructions :** Spécifiques projet, customisées, reflètent conventions réelles
**Prompts :** Réutilisables, indépendants projet, documentés
**Templates :** Placeholders clairs `[...]`, exemples concrets

**Separation of Concerns :**
- Agents = comportement réutilisable
- Instructions = valeurs projet concrètes
- Prompts = automatisation