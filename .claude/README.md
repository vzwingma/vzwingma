# 🤖 .claude — Configuration Claude Code

Infrastructure orchestrée pour Claude Code (claude.ai/code, CLI, IDEs).
**Parallèle Claude de `.github/`** pour Copilot.

## 📂 Structure

```
.claude/
├── README.md                          # Ce fichier
├── CLAUDE.md                          # Instructions système
├── PLANS.md                           # Guide Plans d'Action
├── CHANGELOG.md                       # Versioning agents
├── agents/                            # Agents spécialisés
│   ├── README.md                     # Index agents + exemples
│   ├── Maina.agent.md                # ⚫ Orchestrateur
│   ├── Arcos.agent.md                # 🟠 Architecte
│   ├── Devon.agent.md                # 🔵 Implémentateur
│   ├── Qalvin.agent.md               # 🟢 Expert QA
│   └── Docly.agent.md                # 🟣 Gardien docs
├── instructions/                      # Templates instructions projet
│   ├── architect.instructions.template.md
│   ├── dev.instructions.template.md
│   ├── qa.instructions.template.md
│   └── doc.instructions.template.md
├── skills/                            # Procédures partagées
│   ├── plan-creation/SKILL.md
│   ├── plan-phase-execution/SKILL.md
│   ├── fleet-guide/SKILL.md
│   ├── adr-writing/SKILL.md
│   ├── caveman-default/SKILL.md
│   ├── compact-context/SKILL.md
│   ├── maina-help/SKILL.md
│   └── copilotignore/SKILL.md
├── plans/                             # Plans d'Action + rapports
│   ├── README.md                     # Index plans
│   └── [plans + /reports/]
├── prompts/                           # Prompts initialisation
│   ├── init-copilot-instructions.prompt.md
│   └── update-copilot-instructions.prompt.md
├── templates/                         # Réservé templates futurs
└── workflows/                         # Réservé workflows futurs
```

---

## 📚 Fichiers Clés

### `.claude/CLAUDE.md`
Instructions système. Lire EN PREMIER.
- Mode caveman
- 5 agents + rôles
- Workflow strict
- Règles absolues

### `.claude/PLANS.md`
Guide complet Plans d'Action.
- Création plans (ARCos)
- Exécution phases (tous agents)
- Format rapports phase
- Tracking index

### `.claude/CHANGELOG.md`
Versioning agents + skills.
- Historique modifications
- Versions courantes
- Dépendances

### `.claude/agents/README.md`
Index agents + exemples workflow.
- Rôles agents
- Quand utiliser
- Exemples usage

---

## 🤖 Agents (5 spécialisés)

| Agent | Rôle | Quand |
|-------|------|-------|
| **⚫ MAINa** | Orchestrateur principal | Workflow complet |
| **🟠 ARCos** | Architecte/planification | "Conçois architecture" |
| **🔵 DEVon** | Implémentateur | "Implémente fonctionnalité" |
| **🟢 QALvin** | Expert QA/tests | "Écris tests" |
| **🟣 DOCly** | Gardien documentation | "Mets à jour doc" |

**→ [agents/README.md](./agents/README.md) pour détails complets.**

---

## 📖 Workflow Strict

```
Besoin → MAINa intake
        ↓
       ARCos : plan & architecture
        ↓ (validation humaine)
       DEVon : implémentation
        ↓ (validation humaine)
       QALvin : tests
        ↓ (validation humaine)
       DOCly : documentation
        ↓ (validation humaine)
       ✅ Clôture initiative
```

Chaque étape = **validation humaine obligatoire** avant progression.

---

## 🚀 Démarrage Rapide

### Travail Simple

Invoquer agent directement :

```
@ARCos "Conçois architecture pour..."
@DEVon "Implémente cette fonctionnalité..."
@QALvin "Écris tests pour..."
@DOCly "Mets à jour documentation..."
```

### Travail Complexe (Multi-Phases)

Utiliser MAINa orchestrateur :

```
@MAINa "J'ai ce besoin : [description]"

# MAINa :
# 1. Clarifie besoin
# 2. Active ARCos pour plan
# 3. Attend validation
# 4. Active DEVon pour code
# 5. Attend validation
# 6. Active QALvin pour tests
# 7. Attend validation
# 8. Active DOCly pour docs
# 9. Clôture initiative
```

---

## 📋 Instructions Projet (Optionnelles)

Personnaliser agents par projet. Agents lisent au démarrage si présent :

- `.github/instructions/architect.instructions.md` → 🟠 ARCos
- `.github/instructions/dev.instructions.md` → 🔵 DEVon
- `.github/instructions/qa.instructions.md` → 🟢 QALvin
- `.github/instructions/doc.instructions.md` → 🟣 DOCly

Templates fournis dans `.claude/instructions/` (personnaliser + copier en `.github/`).

---

## 🛠️ Skills Partagés

Procédures automatiquement incluses dans contexte tous agents :

| Skill | Contenu |
|-------|---------|
| `plan-creation` | Créer Plans d'Action (ARCos orchestration) |
| `plan-phase-execution` | Exécuter phases (avant/pendant/après, rapports) |
| `fleet-guide` | Parallélisation `/fleet` |
| `adr-writing` | Rédaction ADR (ARCos prépare, DOCly rédige) |
| `caveman-default` | Mode caveman règles |
| `compact-context` | Compression contexte mémoire |
| `maina-help` | Aide MAINa + workflow |
| `copilotignore` | Respect `.copilotignore` |

---

## 🔐 Règles Absolues

Tous agents respectent :

- ⛔ JAMAIS supprimer fichiers/répertoires
- ⛔ JAMAIS commandes SQL destructives
- ⛔ JAMAIS `git clean`, `git reset --hard`
- ⛔ JAMAIS modifier fichiers hors périmètre
- ⛔ **Respect ABSOLU `.copilotignore`**

En cas doute → demander confirmation.

---

## 📖 Références Complètes

- [CLAUDE.md](./CLAUDE.md) — Instructions système (lire d'abord)
- [PLANS.md](./PLANS.md) — Plans d'Action guide
- [CHANGELOG.md](./CHANGELOG.md) — Versioning agents
- [agents/README.md](./agents/README.md) — Index + exemples agents
- [agents/Maina.agent.md](./agents/Maina.agent.md) — Orchestrateur
- [agents/Arcos.agent.md](./agents/Arcos.agent.md) — Architecte
- [agents/Devon.agent.md](./agents/Devon.agent.md) — Implémentateur
- [agents/Qalvin.agent.md](./agents/Qalvin.agent.md) — Expert QA
- [agents/Docly.agent.md](./agents/Docly.agent.md) — Gardien docs

---

**Dernière mise à jour** : 2026-06-25
