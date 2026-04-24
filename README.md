# 🤖 Copilot Templates & Agents Repository

Ce dépôt est un **centre de référence transverse** pour les modèles réutilisables, les instructions et les prompts Copilot. Il permet de coordonner le développement avec une **architecture multi-agents orchestrée**.

## 📚 Contenus

### 🤖 Agents Copilot (.github/agents/)

Quatre agents spécialisés pour orchestrer le développement :

- **developer.agent.md** — Implémentateur de code de production
- **test-qa.agent.md** — Expert QA et tests unitaires
- **solution-architect.agent.md** — Planificateur technique et orchestrateur
- **doc-manager.agent.md** — Gestionnaire de documentation

Tous les agents sont **génériques et prêts à l'emploi** dans n'importe quel projet.

### 📋 Templates (.github/)

- **copilot-instructions.template.md** — Template générique pour initialiser les instructions Copilot dans un nouveau projet (avec placeholders)
- **copilot-instructions.md** — Copie du template (version de base générique)
- **PLANS.md** — Guide complet pour créer et exécuter les Plans d'Action multi-phases

### 🎯 Prompts (.github/prompts/)

Prompts réutilisables pour des tâches récurrentes :

- **init-copilot-instructions.prompt.md** — ✨ **NOUVEAU** — Initialiser les instructions Copilot dans un nouveau projet
- **update-copilot-instructions.prompt.md** — Auditer et mettre à jour les instructions depuis le code source

### 📖 Exemples (.github/examples/)

Exemples concrets pour différents types de projets :

- **copilot-instructions-domoticz.example.md** — Exemple : projet React Native / Expo (archivé à titre de référence)

### 📖 Documentation

- **.github/README.md** — Guide d'utilisation des templates, agents et prompts

---

## 🚀 Quick Start : Initialiser un Nouveau Projet

### 1. Copier le template

```bash
cp .github/copilot-instructions.template.md <votre_projet>/.github/copilot-instructions.md
```

### 2. Initialiser automatiquement

Utiliser le prompt init-copilot-instructions pour générer les instructions :

```
👤 "Initialise les instructions Copilot pour ce projet"
```

Le prompt va analyser votre code et remplir les sections automatiquement.

### 3. Valider

Vérifier que tous les placeholders sont remplacés et que les conventions du projet sont bien documentées.

---

## 🎯 Workflow Typique

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

Pour en savoir plus, consulter .github/PLANS.md.

---

## 📚 Documentation

- **.github/README.md** — Guide complet d'utilisation
- **.github/PLANS.md** — Guide pour les Plans d'Action
- **.github/agents/*.md** — Instructions pour chaque agent
- **.github/prompts/*.md** — Documentation des prompts
- **.github/examples/** — Exemples concrets

---

## ✅ Ce que vous Trouvez Ici

✅ **Agents génériques** — Prêts à l'emploi dans n'importe quel projet  
✅ **Templates** — Customisables pour votre contexte  
✅ **Prompts** — Pour automatiser l'initialisation et la mise à jour  
✅ **Documentation complète** — Guide d'utilisation et bonnes pratiques  
✅ **Exemples** — Références pour différents types de projets  

---

## 🔄 Maintenance

Les templates et prompts sont **génériques et versionés**. Chaque agent commence par une version (ex: [v1.5]) pour tracker les changements.

Pour mettre à jour les instructions d'un projet existant, utiliser :
```
👤 "Complète les instructions Copilot depuis le code source"
```

---

### Hello there <img src="https://github.com/vzwingma/vzwingma/assets/10505762/5250a9d9-e4b4-4b1f-9f10-9d3ac7294928" alt= "" width="60" height="60"/>

[![vzwingma's GitHub stats](https://github-readme-stats.vercel.app/api?username=vzwingma)](https://github.com/vzwingma/vzwingma)
