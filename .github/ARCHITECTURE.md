# 🏗️ Architecture du Dépôt Transverse Copilot

Ce document décrit l'architecture et les principes de ce dépôt de templates.

---

## 🎯 Objectif

Fournir un **ensemble réutilisable et cohérent** de :
- **Agents Copilot** — Modèles de rôles pour orchestrer le développement
- **Templates** — Fichiers de base customisables pour tout nouveau projet
- **Prompts** — Commandes réutilisables pour automatiser les tâches
- **Documentation** — Guides et bonnes pratiques

---

## 🏢 Principes d'Architecture

### 1. **Réutilisabilité**
Tous les fichiers sont **génériques** et **prêts à l'emploi** dans n'importe quel projet.

### 2. **Separation of Concerns**
- **Agents (`.github/agents/`)** = rôles génériques et workflows réutilisables
- **Instructions (`.github/instructions/`)** = conventions, stack, chemins et versions propres au projet cible
- **Prompts** = commandes réutilisables pour initialiser, auditer et migrer
- **Plans** = orchestration du travail

Cette séparation permet de copier les agents tels quels dans n'importe quel dépôt, puis d'adapter uniquement les fichiers d'instructions via leurs placeholders `[...]`.

### 3. **Versionning**
Chaque agent commence par une version (ex: `[v1.9]`) pour tracker les changements.

### 4. **Customisation Minimale**
Le template permet une initialisation **rapide et complète** avec 3 étapes.

---

## 📂 Structure

```
.
├── README.md                                    # Présentation du dépôt
├── QUICK_START.md                               # Démarrage rapide (3 étapes)
├── SETUP_CHECKLIST.md                           # Checklist d'initialisation
│
└── .github/
    ├── README.md                                # Guide complet d'utilisation
    ├── PLANS.md                                 # Guide des Plans d'Action
    ├── ARCHITECTURE.md                          # Ce fichier
    │
    ├── agents/                                  # 🤖 Rôles réutilisables
    │   ├── Arcos.agent.md                       [v1.9]
    │   ├── Devon.agent.md                       [v1.9]
    │   ├── Qalvin.agent.md                      [v1.9]
    │   └── Docly.agent.md                       [v1.9]
    │
    ├── instructions/                            # 📐 Spécificités projet à compléter
    │   ├── architect.instructions.md            (ARCos : architecture, SQL, interactions)
    │   ├── dev.instructions.md                  (DEVon : stack, code, HTTP, modèles)
    │   ├── qa.instructions.md                   (QUALvin : tests, commandes CI, couverture)
    │   └── doc.instructions.md                  (DOCly : docs, wiki, coordination)
    │
    ├── prompts/                                 # 🎯 Commandes réutilisables
    │   ├── init-copilot-instructions.prompt.md          (initialiser)
    │   ├── update-copilot-instructions.prompt.md        (maintenir à jour)
    │   └── migrate-to-template.prompt.md                (migrer un projet)
    │
    ├── copilot-instructions.md                  # 📋 Template générique (version par défaut)
    ├── copilot-instructions.template.md         # 📋 Template original avec placeholders
    │
    ├── examples/                                # 📖 Exemples concrets
    │   └── copilot-instructions-domoticz.example.md    (React Native / Expo)
    │
    └── plans/                                   # 📅 Plans d'Action
        └── README.md                            (index)
```

---

## 🔄 Flux de Données

```
Nouveau Projet
    ↓
[Copier templates, agents et instructions]
    ↓
[Utiliser prompt init-copilot-instructions]
    ↓
copilot-instructions.md + instructions/*.md (customisés)
    ↓
[Au démarrage, chaque agent lit son fichier d'instructions]
    ↓
Arcos (🟠 ARC) ⇐ architect.instructions.md
Devon (🔵 DEV) ⇐ dev.instructions.md
Qalvin (🟢 QUAL) ⇐ qa.instructions.md
Docly (🟣 DOC) ⇐ doc.instructions.md
    ↓
[Équipe utilise les agents]
```

---

## 📋 Détail des Composants

### 🤖 Agents (`.github/agents/`)

Chaque agent est un **modèle de rôle** générique, défini en markdown avec frontmatter YAML.

**Fichiers :**
- `Arcos.agent.md` — Planificateur / orchestrateur [v1.9]
- `Devon.agent.md` — Implémentateur de code [v1.9]
- `Qalvin.agent.md` — Expert QA [v1.9]
- `Docly.agent.md` — Gestionnaire doc [v1.9]

**Caractéristiques :**
- ✅ Génériques (pas de dépendances au projet)
- ✅ Versionés (v1.9, etc.)
- ✅ Indépendants (peuvent être copiés isolément)
- ✅ Prêts à l'emploi (pas besoin de modification)

### 📐 Instructions agents (`.github/instructions/`)

Ces fichiers complètent les agents génériques avec les **spécificités du projet cible**.

**Fichiers :**
- `architect.instructions.md` — conventions architecturales, protocole SQL de handoff, interactions inter-projets
- `dev.instructions.md` — stack technique, conventions de code, organisation des composants et services
- `qa.instructions.md` — stack de test, commandes CI, cas à couvrir systématiquement
- `doc.instructions.md` — documentation à maintenir, conventions de rédaction, coordination wiki

**Différence avec les agents :**
- **Agents** = comportement, workflow et responsabilités réutilisables
- **Instructions** = valeurs concrètes à personnaliser via des placeholders `[...]`
- **Lecture au démarrage** = chaque agent charge son fichier d'instructions dédié avant exécution

### 📋 Templates

#### `copilot-instructions.template.md`
- **Rôle** : Modèle générique avec placeholders `[...]`
- **Utilisation** : Copier et remplir pour un nouveau projet
- **Contenu** :
  - Sections génériques (agents, workflow, plans)
  - Sections spécifiques avec placeholders (projet, commandes, architecture, conventions)
  - Instructions de remplissage

#### `copilot-instructions.md`
- **Rôle** : Version "par défaut" du template (copie identique)
- **Utilisation** : Référence ou copie de départ
- **Note** : À customiser dans chaque projet

### 🎯 Prompts (`.github/prompts/`)

Commandes réutilisables pour automatiser les tâches.

**Fichiers :**
1. `init-copilot-instructions.prompt.md` — Initialiser les instructions
   - Analyse le code source
   - Remplit le template principal et les 4 fichiers `instructions/`
   - Génère `.github/copilot-instructions.md` et les spécificités projet

2. `update-copilot-instructions.prompt.md` — Mettre à jour les instructions
   - Audite le code source
   - Vérifie aussi les valeurs obsolètes et placeholders non remplis dans `instructions/`
   - Garde la doc synchronisée

3. `migrate-to-template.prompt.md` — Migrer un projet existant
   - Guide pour transformer un projet legacy
   - Archive les anciennes instructions
   - Copie les templates, agents et fichiers `instructions/`

### 📖 Exemples (`.github/examples/`)

Exemples concrets pour différents types de projets.

**Fichiers :**
- `copilot-instructions-domoticz.example.md` — React Native / Expo
  - Exemple complet d'instructions customisées
  - Basé sur un vrai projet (Domoticz)
  - Peut servir de référence

### 📅 Plans (`.github/plans/`)

Structure pour organiser les Plans d'Action multi-phases.

**Fichiers :**
- `README.md` — Index et guide des plans
  - Liste les plans actifs/archivés
  - Explique la structure
  - Pointe vers le guide PLANS.md

---

## 🔐 Invariants

Pour garder ce dépôt cohérent :

✅ **Les agents doivent rester génériques**
- Pas de références au projet spécifique
- Pas de chemins relatifs au projet
- Versionner toute modification

✅ **Les instructions doivent être spécifiques**
- Customisées pour chaque projet
- Refléter les conventions réelles
- Mettre à jour régulièrement (monthly)

✅ **Les prompts doivent être réutilisables**
- Indépendants du projet
- Documentés clairement
- Testés dans plusieurs contextes

✅ **Les templates doivent avoir des placeholders clairs**
- Format : `[DESCRIPTION_DE_CE_QUI_MANQUE]`
- Instructions de remplissage visibles
- Exemple : `[NOM_DU_PROJET]`, `[ARCHITECTURE]`

✅ **Les fichiers `instructions/` doivent rester initialisables**
- Placeholders `[...]` explicites et compréhensibles
- Remplis projet par projet lors de l'initialisation
- Synchronisés avec la stack, les chemins et les versions réelles

---

## 🚀 Utilisation Typique

### Nouveau Projet

```bash
# 1. Copier les fichiers essentiels
cp -r copilot-templates/.github/agents mon-projet/.github/
cp -r copilot-templates/.github/instructions mon-projet/.github/
cp copilot-templates/.github/*.md mon-projet/.github/

# 2. Utiliser le prompt d'initialisation
👤 "Initialise les instructions Copilot pour ce projet"

# 3. Vérifier et valider
👤 "Complète les instructions Copilot depuis le code source"

# 4. Utiliser les agents
👤 "Implémente l'authentification JWT"  → Devon (🔵 DEV)
👤 "Écris des tests pour ce composant"   → Qalvin (🟢 QUAL)
👤 "Conçois une architecture pour..."    → Arcos (🟠 ARC)
```

### Projet Existant

```bash
# 1. Utiliser le prompt de migration
👤 "Aide-moi à migrer ce projet vers les templates Copilot"

# 2. Copier et customiser
cp copilot-templates/.github/copilot-instructions.template.md mon-projet/.github/copilot-instructions.md
cp -r copilot-templates/.github/instructions mon-projet/.github/

# 3. Initialiser
👤 "Initialise les instructions Copilot pour ce projet"

# 4. Continuer comme avant
```

---

## 📊 Statistiques

| Élément | Nombre | Générique |
|---------|--------|-----------|
| Agents | 4 | ✅ Oui |
| Prompts | 3 | ✅ Oui |
| Templates | 6 | ✅ Oui (avec placeholders) |
| Guides | 5 | ✅ Oui |

---

## 🔄 Maintenance

### Mise à Jour des Agents

Si une version d'agent change (ex: `Devon.agent.md` v1.9 → v1.10) :

1. Modifier le fichier `.github/agents/Devon.agent.md`
2. Incrémenter le numéro de version : `[v1.9]` → `[v1.10]`
3. Documenter les changements dans un changelog interne
4. Les projets copient la nouvelle version lors du prochain sync

### Mise à Jour des Templates

Si le template change :

1. Modifier `.github/copilot-instructions.template.md`
2. Ajouter une note de version en en-tête
3. Les projets pourront se re-synchroniser via les prompts

### Mise à Jour des Instructions Agents

Si une convention projet ou une version technique change :

1. Modifier le fichier concerné dans `.github/instructions/`
2. Garder des placeholders `[...]` explicites pour les valeurs à personnaliser
3. Vérifier la cohérence avec l'agent correspondant et les prompts d'init/update/migration
4. Re-synchroniser les projets consommateurs lors du prochain passage des prompts

### Ajout de Nouveaux Prompts

Pour ajouter un nouveau prompt réutilisable :

1. Créer `.github/prompts/<nom>.prompt.md`
2. Documenter clairement son rôle
3. Ajouter dans `.github/README.md`

---

## 🎓 Philosophie

Ce dépôt suit la philosophie :

> **"Écrire une fois, réutiliser partout"**

- 🎯 **Généricité** : Les agents restent stables d'un projet à l'autre
- 🔧 **Customisation minimale** : Les placeholders permettent d'adapter rapidement `copilot-instructions.md` et `instructions/`
- 📚 **Documentation centralisée** : Un seul guide (PLANS.md) pour tous les projets
- 🔄 **Versionning** : Chaque agent a une version pour tracker les changements
- 🚀 **Efficacité** : Initialiser Copilot en 3 étapes max

---

## 📞 Support & Questions

Pour des questions ou des améliorations :

1. Consulter `.github/README.md` (guide complet)
2. Lire les exemples dans `.github/examples/`
3. Suivre le `SETUP_CHECKLIST.md` pour l'initialisation
4. Exécuter `update-copilot-instructions` pour synchroniser

---

**Dernière mise à jour :** 2026-05-05



