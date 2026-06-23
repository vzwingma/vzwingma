# 📚 OpenCode Agents & Templates — Dépôt Transverse

Ce dépôt contient les **modèles réutilisables** et les **agents OpenCode** pour orchestrer le développement avec OpenCode en utilisant une architecture **multi-agents coordonnée**.

---

## 📂 Structure

```
.
├── .opencode/
│   ├── agents/                              # Définitions des agents OpenCode
│   │   ├── Arcos.agent.md                   # Agent planificateur (🟠 ARC - Arcos)
│   │   ├── Devon.agent.md                   # Agent implémenteur (🔵 DEV - Devon)
│   │   ├── Qalvin.agent.md                  # Agent QA et tests (🟢 QUAL - Qalvin)
│   │   └── Docly.agent.md                   # Agent documentation (🟣 DOC - Docly)
│   │
│   ├── instructions/                        # Instructions spécifiques projet (templates)
│   │   ├── architect.instructions.template.md
│   │   ├── dev.instructions.template.md
│   │   ├── qa.instructions.template.md
│   │   └── doc.instructions.template.md
│   │
│   ├── prompts/                             # Prompts pour initialiser des tâches
│   │   ├── init-opencode.prompt.md           # Initialiser AGENTS.md et instructions
│   │   └── update-opencode.prompt.md         # Auditer et mettre à jour les instructions
│   │
│   ├── plans/                               # (Optionnel) Exemples de Plans d'Action
│   │   ├── README.md                        # Index des plans
│   │   └── [plans et rapports]
│   │
│   ├── skills/                              # Skills partagés OpenCode
│   │   ├── adr-writing/
│   │   ├── caveman-default/
│   │   ├── copilotignore/
│   │   ├── fleet-guide/
│   │   ├── plan-creation/
│   │   └── plan-phase-execution/
│   │
│   ├── PLANS.md                             # Guide pour les Plans d'Action
│   └── README.md                            # Ce fichier
│
├── .agents/                                 # Skills OpenCode (caveman family)
├── docs/                                    # Documentation versionnée du dépôt
│   ├── ARCHITECTURE.md
│   ├── ARCHITECTURE.template.md
│   └── adr/
│       └── ADR-TEMPLATE.md
│
├── .github/                                 # Legacy Copilot (templates pour projets aval)
│   ├── copilot-instructions.md
│   └── copilot-instructions.template.md
│
├── AGENTS.md                                # Instructions OpenCode racine
└── ...
```

---

## 🚀 Quick Start : Initialiser OpenCode dans un Nouveau Projet

### Étape 1 : Copier les agents

Copier `.opencode/agents/` vers votre projet :

```bash
# Depuis le dépôt transverse vers votre projet
cp -r .opencode/agents <votre_projet>/.opencode/agents
```

### Étape 2 : Utiliser le prompt d'initiation

Utiliser le prompt **`init-opencode`** pour **générer automatiquement** la configuration :

```
👤 Utilisateur: "Initialise la configuration OpenCode pour ce projet"
```

Le prompt va :
1. ✅ Analyser votre code source
2. ✅ Générer `AGENTS.md` avec la structure du projet
3. ✅ Créer les fichiers `.opencode/instructions/` personnalisés

### Étape 3 : Utiliser les agents

Les agents sont prêts ! Ouvrir OpenCode à la racine du projet :

```bash
opencode
```

---

## 📖 Fichiers Clés

### Agents (`.opencode/agents/`)

Chaque fichier agent définit un rôle, ses responsabilités et comment il interagit avec les autres agents.

| Agent | Rôle | Quand l'utiliser |
|---|---|---|
| **Arkos.agent.md** (🟠 ARC) | Planificateur technique | "Conçois une architecture pour..." |
| **Devon.agent.md** (🔵 DEV) | Implémentateur de code | "Implémente cette fonctionnalité" |
| **Qalvin.agent.md** (🟢 QUAL) | Expert QA et tests | "Écris des tests pour ce composant" |
| **Docly.agent.md** (🟣 DOC) | Gestionnaire documentation | "Mets à jour la documentation" |

Tous les agents sont **génériques et réutilisables** dans n'importe quel projet. Les instructions spécifiques au projet se trouvent dans `.opencode/instructions/`.

> Les agents sont **génériques**. Ils lisent au démarrage leur fichier `instructions/` correspondant pour les spécificités du projet.

### Prompts (`.opencode/prompts/`)

Prompts réutilisables pour des tâches récurrentes.

| Prompt | Rôle | Utilisation |
|---|---|---|
| **init-opencode.prompt.md** | Initialiser `AGENTS.md` et les fichiers `instructions/` | `init-opencode` |
| **update-opencode.prompt.md** | Auditer et mettre à jour `AGENTS.md` et les fichiers `instructions/` | `update-opencode` |

### Documentation

| Fichier | Rôle |
|---|---|
| **PLANS.md** | Guide complet pour créer et exécuter les Plans d'Action |

---

## 🎯 Workflow Typique avec OpenCode

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

Pour en savoir plus, lire `.opencode/PLANS.md`.

---

## ✅ Checklist pour Initialiser un Nouveau Projet

- [ ] Copier `.opencode/agents/` → `.opencode/agents/` du projet
- [ ] Copier `.opencode/skills/` → `.opencode/skills/` du projet
- [ ] Copier `.opencode/PLANS.md` → `.opencode/PLANS.md` du projet
- [ ] Utiliser le prompt `init-opencode` pour remplir les sections
- [ ] Remplir les placeholders dans les 4 fichiers `instructions/`
- [ ] Valider que tous les placeholders sont remplacés
- [ ] Les agents sont prêts ! Utiliser `@ARCos`, `@DEVon`, etc.

---

## 📚 Ressources

- **Architecture** : `docs/ARCHITECTURE.md` — architecture de ce dépôt transverse
- **Templates docs** : `docs/ARCHITECTURE.template.md` + `docs/adr/ADR-TEMPLATE.md`
- **Agents génériques** : Présents dans `.opencode/agents/`, prêts à l'emploi
- **Prompts réutilisables** : `.opencode/prompts/` — s'adapter au contexte du projet
- **Instructions agents** : `.opencode/instructions/` — à personnaliser par projet
- **Plans d'Action** : `.opencode/PLANS.md` — guide pour orchestrer le travail multi-phases

---

## 🔄 Maintenance

### Mettre à jour les agents

Si les versions des agents changent (ex: `Devon [v4.0]`), mettre à jour les fichiers `.opencode/agents/*.md`.

### Mettre à jour les instructions d'un projet

Utiliser le prompt `update-opencode` régulièrement pour garder les instructions à jour avec le code réel.

---

## 🤝 Contribution

Pour ajouter un nouvel agent, prompt ou skill :

1. Créer le fichier dans le dossier approprié (`.opencode/agents/`, `.opencode/prompts/`, etc.)
2. Suivre les conventions existantes (format YAML frontmatter pour agents/prompts)
3. Tester dans un projet de sandbox avant de committer
4. Documenter dans ce README

---

**Dernière mise à jour :** 2026-06-18
