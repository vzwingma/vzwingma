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
- **Agents** = Rôles génériques (indépendants du projet)
- **Instructions Copilot** = Conventions spécifiques du projet
- **Prompts** = Commandes réutilisables
- **Plans** = Orchestration du travail

### 3. **Versionning**
Chaque agent commence par une version (ex: `[v1.5]`) pour tracker les changements.

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
    │   ├── Devon (🔵 DEV).agent.md          [v1.5]
    │   ├── Qalvin (🟢 QUAL).agent.md            [v1.5]
    │   ├── Arkos (🟠 ARC).agent.md [v1.6]
    │   └── Docly (🟣 DOC).agent.md        [v1.5]
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
[Copier Templates & Agents]
    ↓
[Utiliser prompt init-copilot-instructions]
    ↓
copilot-instructions.md (customisé)
    ↓
[Équipe utilise agents]
    ↓
Devon (🔵 DEV), Qalvin (🟢 QUAL), Arkos (🟠 ARC), Docly (🟣 DOC)
```

---

## 📋 Détail des Composants

### 🤖 Agents (`.github/agents/`)

Chaque agent est un **modèle de rôle** générique, défini en markdown avec frontmatter YAML.

**Fichiers :**
- `Devon (🔵 DEV).agent.md` — Implémentateur de code [v1.5]
- `Qalvin (🟢 QUAL).agent.md` — Expert QA [v1.5]
- `Arkos (🟠 ARC).agent.md` — Planificateur [v1.6]
- `Docly (🟣 DOC).agent.md` — Gestionnaire doc [v1.5]

**Caractéristiques :**
- ✅ Génériques (pas de dépendances au projet)
- ✅ Versionés (v1.5, v1.6, etc.)
- ✅ Indépendants (peuvent être copiés isolément)
- ✅ Prêts à l'emploi (pas besoin de modification)

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
   - Remplit le template automatiquement
   - Génère `.github/copilot-instructions.md`

2. `update-copilot-instructions.prompt.md` — Mettre à jour les instructions
   - Audite le code source
   - Enrichit les sections existantes
   - Garde la doc synchronisée

3. `migrate-to-template.prompt.md` — Migrer un projet existant
   - Guide pour transformer un projet legacy
   - Archive les anciennes instructions
   - Copie les templates et agents

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

---

## 🚀 Utilisation Typique

### Nouveau Projet

```bash
# 1. Copier les fichiers essentiels
cp -r copilot-templates/.github/agents mon-projet/.github/
cp copilot-templates/.github/*.md mon-projet/.github/

# 2. Utiliser le prompt d'initialisation
👤 "Initialise les instructions Copilot pour ce projet"

# 3. Vérifier et valider
👤 "Complète les instructions Copilot depuis le code source"

# 4. Utiliser les agents
👤 "Implémente l'authentification JWT"  → Devon (🔵 DEV)
👤 "Écris des tests pour ce composant"   → Qalvin (🟢 QUAL)
👤 "Conçois une architecture pour..."    → Arkos (🟠 ARC)
```

### Projet Existant

```bash
# 1. Utiliser le prompt de migration
👤 "Aide-moi à migrer ce projet vers les templates Copilot"

# 2. Copier et customiser
cp copilot-templates/.github/copilot-instructions.template.md mon-projet/.github/copilot-instructions.md

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
| Templates | 2 | ✅ Oui (avec placeholders) |
| Exemples | 1 | ✅ Oui (Domoticz) |
| Guides | 5 | ✅ Oui |

---

## 🔄 Maintenance

### Mise à Jour des Agents

Si une version d'agent change (ex: Devon (🔵 DEV) v1.5 → v1.6) :

1. Modifier le fichier `.github/agents/Devon (🔵 DEV).agent.md`
2. Incrémenter le numéro de version : `[v1.5]` → `[v1.6]`
3. Documenter les changements dans un changelog interne
4. Les projets copient la nouvelle version lors du prochain sync

### Mise à Jour des Templates

Si le template change :

1. Modifier `.github/copilot-instructions.template.md`
2. Ajouter une note de version en en-tête
3. Les projets pourront se re-synchroniser via les prompts

### Ajout de Nouveaux Prompts

Pour ajouter un nouveau prompt réutilisable :

1. Créer `.github/prompts/<nom>.prompt.md`
2. Documenter clairement son rôle
3. Ajouter dans `.github/README.md`

---

## 🎓 Philosophie

Ce dépôt suit la philosophie :

> **"Écrire une fois, réutiliser partout"**

- 🎯 **Généricité** : Les agents et templates ne changent pas entre projets
- 🔧 **Customisation minimale** : Les placeholders permettent une adaptation rapide
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

**Dernière mise à jour :** 2026-04-24



