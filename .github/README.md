# 📚 Copilot Templates & Agents — Dépôt Transverse

Ce dépôt contient les **modèles réutilisables** et les **instructions d'agents** pour orchestrer le développement avec Copilot en utilisant une architecture **multi-agents coordonnée**.

---

## 📂 Structure

```
.github/
├── agents/                              # Définitions des agents Copilot
│   ├── developer.agent.md              # Agent implémenteur
│   ├── test-qa.agent.md                # Agent QA et tests
│   ├── solution-architect.agent.md     # Agent planificateur
│   └── doc-manager.agent.md            # Agent documentation
│
├── prompts/                             # Prompts pour initialiser des tâches
│   ├── init-copilot-instructions.prompt.md      # 🆕 Initialiser copilot-instructions.md
│   ├── update-copilot-instructions.prompt.md    # Auditer et mettre à jour les instructions
│   └── [autres prompts]
│
├── plans/                               # (Optionnel) Exemples de Plans d'Action
│   ├── README.md                        # Index des plans
│   └── [plans et rapports]
│
├── examples/                            # 🆕 Exemples concrets pour référence
│   ├── copilot-instructions-domoticz.example.md  # Exemple : projet React Native/Expo
│   └── [autres exemples]
│
├── copilot-instructions.template.md     # 🆕 Template générique à customiser
├── copilot-instructions.md              # Template générique (copie du .template.md)
├── PLANS.md                             # Guide pour les Plans d'Action
└── [autres fichiers]
```

---

## 🚀 Quick Start : Initialiser Copilot dans un Nouveau Projet

### Étape 1 : Copier le template

Copier `.github/copilot-instructions.template.md` vers votre projet :

```bash
# Depuis le dépôt transverse vers votre projet
cp .github/copilot-instructions.template.md <votre_projet>/.github/copilot-instructions.md
```

### Étape 2 : Utiliser le prompt d'initiation

Utiliser le prompt **`.github/prompts/init-copilot-instructions.prompt.md`** pour **générer automatiquement** les instructions :

```
👤 Utilisateur: "Initialise les instructions Copilot pour ce projet"
```

Ou avec le CLI Copilot :
```bash
copilot prompt run init-copilot-instructions
```

Le prompt va :
1. ✅ Lire le template
2. ✅ Analyser votre code source
3. ✅ Remplir les placeholders automatiquement
4. ✅ Générer `.github/copilot-instructions.md`

### Étape 3 : Valider et enrichir (optionnel)

Si votre projet a des conventions spécifiques non détectées, utilisez le prompt **`.github/prompts/update-copilot-instructions.prompt.md`** pour auditer et enrichir :

```
👤 Utilisateur: "Complète les instructions Copilot depuis le code source"
```

---

## 📖 Fichiers Clés

### Agents (`.github/agents/`)

Chaque fichier agent définit un rôle, ses responsabilités et comment il interagit avec les autres agents.

| Agent | Rôle | Quand l'utiliser |
|---|---|---|
| **developer.agent.md** | Implémentateur de code | "Implémente cette fonctionnalité" |
| **test-qa.agent.md** | Expert QA et tests | "Écris des tests pour ce composant" |
| **solution-architect.agent.md** | Planificateur technique | "Conçois une architecture pour..." |
| **doc-manager.agent.md** | Gestionnaire documentation | "Mets à jour la documentation" |

Tous les agents sont **génériques et réutilisables** dans n'importe quel projet. Les instructions Copilot spécifiques au projet se trouvent dans `.github/copilot-instructions.md`.

### Prompts (`.github/prompts/`)

Prompts réutilisables pour des tâches récurrentes.

| Prompt | Rôle | Utilisation |
|---|---|---|
| **init-copilot-instructions.prompt.md** | 🆕 Initialiser les instructions Copilot | `copilot prompt run init-copilot-instructions` |
| **update-copilot-instructions.prompt.md** | Auditer et mettre à jour les instructions | `copilot prompt run update-copilot-instructions` |

### Templates

| Fichier | Rôle | Utilisation |
|---|---|---|
| **copilot-instructions.template.md** | Template générique avec placeholders | Copier et customiser dans un nouveau projet |
| **copilot-instructions.md** | Version "générique par défaut" | Exemple de fichier de base |

### Exemples (`.github/examples/`)

Exemples concrets d'instructions pour différents types de projets.

| Exemple | Type de projet | Utilisation |
|---|---|---|
| **copilot-instructions-domoticz.example.md** | React Native / Expo | Référence pour projets mobiles |

### Documentation

| Fichier | Rôle |
|---|---|
| **PLANS.md** | Guide complet pour créer et exécuter les Plans d'Action |

---

## 🎯 Workflow Typique avec Copilot

```
1️⃣ Utilisateur cadre le besoin
   ↓
2️⃣ solution-architect crée un Plan d'Action
   ↓
3️⃣ developer implémente les tâches
   ↓
4️⃣ test-qa écrit les tests
   ↓
5️⃣ doc-manager met à jour la documentation
   ↓
6️⃣ Phase suivante du plan (retour à 2️⃣)
```

Pour en savoir plus, lire `.github/PLANS.md`.

---

## ✅ Checklist pour Initialiser un Nouveau Projet

- [ ] Copier `.github/copilot-instructions.template.md` → `.github/copilot-instructions.md`
- [ ] Utiliser le prompt `init-copilot-instructions` pour remplir les sections
- [ ] Valider que tous les placeholders sont remplacés
- [ ] (Optionnel) Utiliser `update-copilot-instructions` pour enrichir depuis le code
- [ ] Committer `.github/copilot-instructions.md` dans le repo
- [ ] Les agents sont prêts ! Utiliser `/solve` ou les appeler par nom

---

## 📚 Ressources

- **Agents génériques** : Présents dans ce dépôt, prêts à l'emploi
- **Prompts réutilisables** : `.github/prompts/` — s'adapter au contexte du projet
- **Templates** : `.github/copilot-instructions.template.md` — customiser pour votre projet
- **Exemples** : `.github/examples/` — références pour différents types de projets
- **Plans d'Action** : `.github/PLANS.md` — guide pour orchestrer le travail multi-phases

---

## 🔄 Maintenance

### Mettre à jour les agents

Si les versions des agents changent (ex: `developer [v1.6]`), mettre à jour les fichiers `.github/agents/*.md`.

### Mettre à jour les instructions d'un projet

Utiliser le prompt `update-copilot-instructions` régulièrement pour garder les instructions à jour avec le code réel.

---

## 🤝 Contribution

Pour ajouter un nouvel agent, prompt ou template :

1. Créer le fichier dans le dossier approprié (`.github/agents/`, `.github/prompts/`, etc.)
2. Suivre les conventions existantes (format YAML frontmatter pour agents/prompts)
3. Tester dans un projet de sandbox avant de committer
4. Documenter dans ce README

---

**Dernière mise à jour :** 2026-04-24
