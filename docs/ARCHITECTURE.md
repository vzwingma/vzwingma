# 🏗️ Architecture — Dépôt Transverse Copilot

> Ce document décrit l'architecture et les principes de ce dépôt de templates multi-agents.  
> Compléter les sections **⚠️ À COMPLÉTER** au fur et à mesure des évolutions.

---

## 🎯 Vue d'ensemble

Le **dépôt transverse Copilot** est un ensemble réutilisable de templates, agents et prompts pour orchestrer le développement avec GitHub Copilot via une architecture **multi-agents coordonnée**.

| Propriété | Valeur |
|---|---|
| **Type** | Dépôt de templates / infrastructure Copilot |
| **Stack principale** | Markdown, YAML (frontmatter agents) |
| **Plateforme cible** | GitHub Copilot CLI (tout type de projet consommateur) |
| **Langue** | Français (contenu), Anglais (exemples de code) |
| **Statut** | En développement actif |

**Philosophie :** *"Écrire une fois, réutiliser partout"*
- 🎯 **Généricité** : les agents restent stables d'un projet à l'autre
- 🔧 **Customisation minimale** : les placeholders `[...]` permettent l'adaptation rapide
- 🔄 **Versionning** : chaque agent porte une version pour tracker les changements
- 🚀 **Efficacité** : initialiser Copilot en 3 étapes max

---

## 🏢 Architecture Globale

### Principes de séparation des responsabilités

```
Dépôt Transverse Copilot
├── agents/          # Comportements génériques et réutilisables (non modifiés par projet)
├── instructions/    # Valeurs spécifiques au projet cible (à personnaliser via [placeholders])
├── prompts/         # Commandes réutilisables pour initialiser, auditer et migrer
├── plans/           # Orchestration du travail multi-phases
└── docs/            # Documentation de ce dépôt transverse
    └── adr/         # Décisions architecturales
```

### Flux d'utilisation (projet consommateur)

```
Nouveau Projet
    → [Copier agents/, instructions/, prompts/, docs/ARCHITECTURE.template.md]
    → [Exécuter prompt init-copilot-instructions]
    → copilot-instructions.md + instructions/*.md  (customisés pour le projet)
    → [Au démarrage de session, chaque agent lit son fichier d'instructions]
        ├── ARCos  (🟠 ARC) ← architect.instructions.md + docs/ARCHITECTURE.md
        ├── DEVon  (🔵 DEV) ← dev.instructions.md
        ├── QALvin(🟢 QUAL)← qa.instructions.md
        └── DOCly  (🟣 DOC) ← doc.instructions.md
    → [L'équipe utilise les agents via Copilot]
```

### Principes architecturaux

| Principe | Description |
|---|---|
| **Réutilisabilité** | Tous les fichiers agents sont génériques et prêts à l'emploi dans n'importe quel projet |
| **Separation of Concerns** | Agents = comportement · Instructions = valeurs projet · Prompts = automatisation |
| **Versionning** | Chaque agent commence par `[vX.Y]` pour tracker les changements |
| **Customisation minimale** | Le template permet une initialisation rapide et complète en 3 étapes |

---

## 📂 Structure des Dossiers

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
    │   ├── Maina.agent.md                       # Maître orchestrateur [v1.0]
    │   ├── Arcos.agent.md                       # Planificateur / architecte [v4.3]
    │   ├── Devon.agent.md                       # Implémentateur de code [v4.2]
    │   ├── Qalvin.agent.md                      # Expert QA [v4.2]
    │   └── Docly.agent.md                       # Gestionnaire documentation [v4.2]
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
    │   ├── qa.instructions.md                   # QALvin : tests, commandes CI, couverture
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

## 🔧 Composants Principaux

### 🤖 Agents (`.github/agents/`)

Chaque agent est un **modèle de rôle** générique défini en Markdown avec frontmatter YAML.

| Agent | Fichier | Version | Rôle |
|---|---|---|---|
| ⚫ MAINa | `Maina.agent.md` | v1.0 | Maître orchestrateur (point d'entrée principal) |
| 🟠 ARCos | `Arcos.agent.md` | v4.3 | Planificateur / architecte |
| 🔵 DEVon | `Devon.agent.md` | v4.2 | Implémentateur de code |
| 🟢 QALvin | `Qalvin.agent.md` | v4.2 | Expert QA et tests |
| 🟣 DOCly | `Docly.agent.md` | v4.2 | Gestionnaire documentation |

**Caractéristiques :**
- ✅ Génériques (pas de dépendances au projet spécifique)
- ✅ Versionnés (incrémentés à chaque modification comportementale)
- ✅ Indépendants (peuvent être copiés isolément dans un projet)
- ✅ Prêts à l'emploi (pas besoin de modification pour démarrer)

### 📐 Instructions agents (`.github/instructions/`)

Ces fichiers complètent les agents génériques avec les **spécificités du projet cible**.

| Fichier | Agent | Contenu |
|---|---|---|
| `architect.instructions.md` | 🟠 ARCos | Conventions architecturales, protocole SQL handoff, ADR |
| `dev.instructions.md` | 🔵 DEVon | Stack technique, conventions de code, organisation |
| `qa.instructions.md` | 🟢 QALvin | Stack de test, commandes CI, cas à couvrir |
| `doc.instructions.md` | 🟣 DOCly | Structure `docs/`, conventions de rédaction |

> **Différence avec les agents :** Agents = comportement réutilisable · Instructions = valeurs projet concrètes

### 🎯 Prompts (`.github/prompts/`)

| Prompt | Rôle |
|---|---|
| `init-copilot-instructions` | Analyse le code source, remplit le template principal, conserve orchestration MAINa et génère les 4 fichiers `instructions/` |
| `update-copilot-instructions` | Audite le code, vérifie les valeurs obsolètes et placeholders non remplis |
| `migrate-to-template` | Guide pour transformer un projet legacy vers ce système |

### 📄 Templates (`docs/`)

| Fichier | Rôle |
|---|---|
| `docs/ARCHITECTURE.template.md` | Template `docs/ARCHITECTURE.md` à copier dans chaque projet |
| `docs/adr/ADR-TEMPLATE.md` | Template ADR à copier pour chaque décision architecturale |
| `.github/copilot-instructions.template.md` | Template `copilot-instructions.md` avec placeholders |

---

## 📐 Conventions et Invariants

### Agents — doivent rester génériques
- Pas de références au projet spécifique dans les fichiers `.agent.md`
- Pas de chemins relatifs à un projet particulier
- Incrémenter la version à chaque modification comportementale

### Instructions — doivent être spécifiques
- Customisées pour chaque projet consommateur
- Refléter les conventions réelles (pas des hypothèses)
- Mises à jour régulièrement (prompt `update-copilot-instructions`)

### Prompts — doivent être réutilisables
- Indépendants du projet
- Documentés clairement dans leur frontmatter YAML
- Testés dans plusieurs contextes

### Templates — doivent avoir des placeholders clairs
- Format : `[DESCRIPTION_DE_CE_QUI_MANQUE]`
- Instructions de remplissage visibles
- Exemples concrets : `[NOM_DU_PROJET]`, `[STACK_PRINCIPALE]`

### Fichiers `instructions/` — doivent rester initialisables
- Placeholders `[...]` explicites et compréhensibles
- Remplis projet par projet lors de l'initialisation
- Synchronisés avec la stack, les chemins et versions réelles

---

## 🗺️ Décisions Architecturales (ADR)

> Les décisions architecturales majeures sont documentées dans `docs/adr/`.  
> Format : `docs/adr/NNN-titre-court.md` — utiliser `docs/adr/ADR-TEMPLATE.md` comme base.

| # | Décision | Statut | Date |
|---|---|---|---|
| 001 | Migration documentation Wiki → `/docs` | Acceptée | 2026-05-07 |
| 002 | ARCos lit `docs/ARCHITECTURE.md` au démarrage | Acceptée | 2026-05-07 |

> 💡 Chaque nouvelle décision majeure sur ce dépôt transverse doit faire l'objet d'un ADR.

---

## 🚀 Utilisation Typique

### Nouveau projet

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

### Projet existant

```bash
# Utiliser le prompt de migration
👤 "Aide-moi à migrer ce projet vers les templates Copilot"
```

---

## 📊 Inventaire

| Élément | Nombre | Générique |
|---|---|---|
| Agents | 4 | ✅ Oui |
| Prompts | 3 | ✅ Oui |
| Templates instructions | 4 | ✅ Oui (avec placeholders) |
| Templates docs | 2 | ✅ Oui (ARCHITECTURE + ADR) |
| Exemples | 1 | ✅ Oui |

---

## 🔄 Maintenance

### Mise à jour des agents

1. Modifier `.github/agents/<Agent>.agent.md`
2. Incrémenter la version : `[vX.Y]` → `[vX.Y+1]`
3. Documenter les changements dans le frontmatter (ligne `> **Changements...`)
4. Mettre à jour le tableau d'inventaire ci-dessus

### Mise à jour des templates

1. Modifier `docs/ARCHITECTURE.template.md` ou `.github/copilot-instructions.template.md`
2. Les projets consommateurs se re-synchronisent via les prompts

### Ajout d'un nouveau prompt

1. Créer `.github/prompts/<nom>.prompt.md`
2. Documenter son rôle dans le frontmatter YAML
3. Référencer dans `.github/README.md`

---

## 📝 Historique des Versions

| Version | Date | Changements majeurs |
|---|---|---|
| v3.1 | 2026-06-11 | Suppression agent FINNops ; ajout skills `adr-writing` et `caveman-default` |
| v3.0 | 2026-05-28 | Activation globale du mode `caveman` dans tous les agents + compression des instructions |
| v2.1 | 2026-05-07 | Migration wiki → `/docs` ; ajout templates ARCHITECTURE.md et ADR |
| v2.0 | 2026-05-05 | Ajout parallélisation `/fleet` dans tous les agents |

---

## 🔗 Ressources

- **README** : [`.github/README.md`](.github/README.md)
- **Guide Plans d'Action** : [`.github/PLANS.md`](.github/PLANS.md)
- **Checklist** : [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md)
- **ADRs** : [`docs/adr/`](./adr/)
- **Exemples** : [`.github/examples/`](.github/examples/)
