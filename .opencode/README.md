# 📚 GitHub OpenCode Agents & Templates — Dépôt Transverse

Ce sous-arbre `.opencode/` contient les **artefacts OpenCode réutilisables** du dépôt : agents, skills, prompts, templates d'instructions et plans d'action.

Il sert de point d'entree pour comprendre **qui fait quoi**, **comment les agents se coordonnent** et **quels fichiers copier ou maintenir** sans surcharger chaque `*.agent.md`.

---

## 📂 Structure

```
.opencode/
├── agents/                              # 4 agents OpenCode generiques
│   ├── Arcos.agent.md                   # Planification / architecture
│   ├── Devon.agent.md                   # Implementation
│   ├── Qalvin.agent.md                  # Tests
│   └── Docly.agent.md                   # Documentation
├── instructions/                        # Templates d'instructions par role
├── prompts/                             # Prompts d'initialisation / mise a jour
├── skills/                              # Procedures partagees auto-chargees
├── plans/                               # Plans d'Action et rapports
├── CHANGELOG.md                         # Historique des versions des agents
├── PLANS.md                             # Guide des Plans d'Action
├── README.md                            # Ce fichier
├── copilot-instructions.md              # Instructions de ce depot transverse
└── copilot-instructions.template.md     # Template a copier dans les projets
```

---

## 🚀 Quick Start : reutiliser le sous-arbre `.opencode/`

### Etape 1 : Copier les artefacts utiles

Selon le projet cible, copier :

- `.opencode/agents/`
- `.opencode/skills/`
- `.opencode/instructions/`
- `.opencode/prompts/`
- `.opencode/PLANS.md`
- `.opencode/copilot-instructions.template.md`

### Etape 2 : Initialiser les instructions projet

Utiliser le prompt `init-copilot-instructions` pour generer les fichiers d'instructions adaptes au projet consommateur.

### Etape 3 : Utiliser les agents

Les agents peuvent ensuite etre invoques selon le besoin :

- `ARCos` pour concevoir et planifier
- `DEVon` pour implementer
- `QUALvin` pour tester
- `DOCly` pour documenter

---

## 📖 Fichiers cles

### Agents (`.opencode/agents/`)

| Agent | Role | Quand l'utiliser |
|---|---|---|
| **Arcos.agent.md** (🟠 ARC) | Planificateur / architecte | "Conçois une architecture pour..." |
| **Devon.agent.md** (🔵 DEV) | Implementateur | "Implémente cette fonctionnalité" |
| **Qalvin.agent.md** (🟢 QUAL) | QA / tests | "Écris des tests pour..." |
| **Docly.agent.md** (🟣 DOC) | Documentation | "Mets à jour la documentation" |

Les agents restent focalises sur leurs instructions runtime. La vue transverse et la coordination sont documentees ici pour eviter la duplication.

### Instructions (`.opencode/instructions/`)

| Fichier | Role |
|---|---|
| `architect.instructions.md` | Conventions architecture / SQL handoff |
| `dev.instructions.md` | Stack technique, versions, conventions de code |
| `qa.instructions.md` | Framework de test, commandes CI, cas a couvrir |
| `doc.instructions.md` | Cibles documentaires et conventions de doc |

### Prompts (`.opencode/prompts/`)

| Prompt | Utilisation |
|---|---|
| `init-copilot-instructions.prompt.md` | Initialiser les instructions OpenCode dans un projet |
| `update-copilot-instructions.prompt.md` | Auditer et mettre a jour les instructions |
| `migrate-to-template.prompt.md` | Migrer un projet vers le format template transverse |

### Plans et gouvernance

| Fichier | Role |
|---|---|
| `PLANS.md` | Guide complet de creation / execution des Plans d'Action |
| `plans/README.md` | Index des plans et statut global |
| `CHANGELOG.md` | Historique de version des 4 agents |

---

## 🤝 Relations entre agents

Le workflow cible reste simple :

1. 👤 **Developpeur humain** cadre le besoin et valide chaque livrable cle.
2. 🟠 **ARCos** conçoit la solution, compare les options et cree le plan.
3. 🔵 **DEVon** implemente selon le plan valide.
4. 🟢 **QUALvin** ecrit et execute les tests.
5. 🟣 **DOCly** synchronise la documentation.

Relations de passage :

- `ARCos` → `DEVon`, `QUALvin`, `DOCly`
- `DEVon` → `QUALvin`, puis `DOCly`
- `QUALvin` → `DOCly`
- chaque etape importante revient vers le 👤 Developpeur humain pour validation

> Les agents n'ont plus besoin de porter chacun ce schema ; ils pointent vers ce README.

---

## 🎯 Workflow typique

```
1. Besoin cadre par le developpeur humain
   ↓
2. ARCos cree le plan et la cible
   ↓
3. DEVon implemente
   ↓
4. QUALvin valide par les tests
   ↓
5. DOCly met a jour la documentation
   ↓
6. Phase suivante / cloture du plan
```

Pour les details de phases, de rapports et de dependances, voir `PLANS.md`.

---

## ✅ Checklist de maintenance

- Modifier un agent => incrementer sa version dans le frontmatter
- Reporter la modification dans `CHANGELOG.md`
- Synchroniser les versions dans `copilot-instructions.md` et `copilot-instructions.template.md`
- Mettre a jour `plans/README.md` a chaque nouveau Plan d'Action
- Garder ce README comme source de verite pour la coordination transverse `.opencode/`

---

## 📚 Ressources

- `README.md` racine : presentation generale du depot
- `docs/ARCHITECTURE.md` : architecture transverse globale
- `.opencode/PLANS.md` : format et execution des Plans d'Action
- `.opencode/copilot-instructions.md` : instructions detaillees du depot OpenCode
