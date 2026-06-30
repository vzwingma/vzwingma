# 🚀 Guide Rapide : Utiliser Ce Dépôt de Templates

Bienvenue ! Ce dépôt contient les **templates et agents réutilisables** pour orchestrer le développement avec OpenCode.

---

## ⚡ TL;DR — 3 Étapes Rapides

Si vous avez un **nouveau projet** et voulez initialiser OpenCode rapidement :

### 1️⃣ Copier les Fichiers Essentiels

```bash
# Depuis ce dépôt vers votre projet
cp -r .opencode/agents <votre_projet>/.opencode/
cp -r .opencode/instructions <votre_projet>/.opencode/
cp -r .opencode/skills <votre_projet>/.opencode/
cp .opencode/PLANS.md <votre_projet>/.opencode/
cp .opencode/instructions/*.instructions.template.md <votre_projet>/.opencode/instructions/*.instructions.md
mkdir -p <votre_projet>/.opencode/prompts
cp .opencode/prompts/*.prompt.md <votre_projet>/.opencode/prompts/
```

### 2️⃣ Initialiser les Instructions

Ouvrir OpenCode dans votre projet et lancer le prompt d'initialisation :

- [`.opencode/prompts/init-copilot-instructions.prompt.md`](.opencode/prompts/init-copilot-instructions.prompt.md) — pour initialiser un nouveau projet
- [`.opencode/prompts/update-copilot-instructions.prompt.md`](.opencode/prompts/update-copilot-instructions.prompt.md) — pour auditer et mettre à jour un projet existant

Commande typique :

```
👤 "Initialise les instructions OpenCode pour ce projet grâce au prompt d'initialisation init-copilot-instructions.prompt.md."
```

✅ Cela va analyser votre code et générer les instructions automatiquement.

Ou, pour une mise à jour après évolution du projet :

```
👤 "Mets à jour les instructions OpenCode depuis le code source grâce au prompt de mise à jour update-copilot-instructions.prompt.md."
```

### 3️⃣ Valider

```
👤 "Complète les instructions OpenCode depuis le code source"
```

✅ Votre projet est prêt ! Commencez à utiliser les agents.

---

## 📚 Contenus de Ce Dépôt

### 🤖 Agents (5)
Modèles prêts à l'emploi pour différents rôles :
- **⚫ MAINa** — Orchestration maître du workflow
- **🔵 DEVon** — Implémente le code
- **🟢 QALvin** — Écrit les tests
- **🟠 ARCos** — Analyse les options et conçoit l'architecture (consulté par MAINa)
- **🟣 DOCly** — Maintient la documentation

### 📋 Templates
- **`instructions/*.instructions.template.md`** — Template générique à customiser
- **`instructions/`** — 4 templates d'instructions agents à personnaliser par projet
- **`PLANS.md`** — Guide pour orchestrer le travail multi-phases
- **Prompts** — Pour initialiser automatiquement les instructions

### 📖 Documentation
- **`.opencode/README.md`** — Guide complet du dépôt
- **`SETUP_CHECKLIST.md`** — Checklist pour initialiser un projet

---

## 🎯 Workflow Typique

Une fois OpenCode configuré, voici comment collaborer :

```
1️⃣ Vous décrivez le besoin
   ↓
2️⃣ ⚫ MAINa consulte 🟠 ARCos → ≥2 options + recommandation
   ↓
3️⃣ ✅ Choix de la solution (Gate #0)
   ↓
4️⃣ ⚫ MAINa crée le Plan d'Action → ✅ validation (Gate #1)
   ↓
5️⃣ 🔵 DEVon implémente → ✅ validation (Gate #2)
   ↓
6️⃣ 🟢 QALvin écrit les tests → ✅ validation (Gate #3)
   ↓
7️⃣ 🟣 DOCly met à jour la doc → ✅ validation (Gate #4)
   ↓
8️⃣ ✅ Clôture de l'initiative
```

> 💡 **Parallélisation** : Utiliser `/fleet` quand QALvin et DOCly peuvent travailler en parallèle après DEVon, ou quand plusieurs tâches DEVon sont indépendantes.

---

## 🧭 Lancer Une Demande Avec MAINa

Pour une demande structurante, utilisez MAINa comme point d'entrée. L'objectif est de cadrer avant d'implémenter, puis de valider chaque gate humain.

### 1️⃣ Activer le mode plan

Commencez par activer le mode plan pour que MAINa produise un plan d'action avant toute implémentation :

```
> "/plan"
```

### 2️⃣ Activer MAINa

Invoquez MAINa explicitement pour qu'il orchestre le workflow :

```
👤 "/agent MAINa"
```

Vous pouvez aussi demander l'aide intégrée :

```
👤 "/maina-help"
```

### 3️⃣ Expliquer la demande

Décrivez le besoin avec le plus de contexte utile possible :

```
👤 "Besoin : [objectif].
Contexte : [code, métier, contrainte technique].
Contraintes : [délais, compatibilité, sécurité, tests].
Livrables attendus : [code, tests, documentation, ADR]."
```

### 4️⃣ Valider l'option recommandée

MAINa consulte ARCos pour comparer plusieurs options. Avant tout plan détaillé, validez le choix de solution proposé.

```
👤 "Je valide l'option 2. Crée le Plan d'Action."
```

### 5️⃣ Valider le Plan d'Action

MAINa produit ensuite le Plan d'Action. Relisez le périmètre, les tâches, les dépendances et les gates.

```
👤 "Plan validé. Tu peux lancer la phase d'implémentation."
```

### 6️⃣ Suivre les phases et gates

Chaque phase revient vers vous pour validation avant de continuer :

- **DEVon** implémente le code, puis demande validation code
- **QALvin** écrit et exécute les tests, puis demande validation tests
- **DOCly** synchronise la documentation, puis demande validation finale

Ne clôturez l'initiative qu'après validation du code, des tests et de la documentation.

---

## ❓ FAQ

### Q: Comment copier rapidement ce dépôt vers mon projet ?
A: 
```bash
git clone <ce_repo> copilot-templates
cp -r copilot-templates/.opencode/* mon-projet/.opencode/
```

### Q: Est-ce que je dois tout copier ?
A: Non ! Minimum requis :
- `.opencode/agents/` (5 fichiers)
- `.opencode/skills/` (9 skills — un dossier par skill avec `SKILL.md`)
- `.opencode/instructions/` (4 fichiers — à personnaliser)
- `.opencode/instructions/*.instructions.template.md` (renommer en `instructions/*.instructions.md`)
- `.opencode/PLANS.md`

### Q: Comment initialiser rapidement ?
A: Une fois les fichiers copiés, exécuter dans votre projet :
```
👤 "Initialise les instructions OpenCode pour ce projet"
```
Prompt associé : [`.opencode/prompts/init-copilot-instructions.prompt.md`](.opencode/prompts/init-copilot-instructions.prompt.md).

Pour mettre à jour des instructions existantes, utiliser : [`.opencode/prompts/update-copilot-instructions.prompt.md`](.opencode/prompts/update-copilot-instructions.prompt.md).

### Q: Les agents sont-ils customisables ?
A: Les agents sont **génériques**, la customisation se fait dans deux endroits : `.opencode/instructions/*.instructions.md` (contexte global) et `.opencode/instructions/*.instructions.md` (spécificités par agent).

### Q: Comment paralléliser les tâches entre agents ?
A: Utiliser `/fleet` quand plusieurs agents ont des tâches indépendantes (ex: QALvin + DOCly après DEVon, ou plusieurs composants à implémenter sans dépendance). `/fleet` dispatche les sous-agents en simultané.

### Q: Où stocker mes Plans d'Action ?
A: Dans `.opencode/plans/` — utiliser le format `XXX_<nom>.plan.md`.

### Q: Quelle est la licence ?
A: Libre d'utilisation — c'est un dépôt de templates transverse.

---

## 📞 Besoin d'Aide ?

1. **Lire** [`.opencode/README.md`](.opencode/README.md) — Guide complet
2. **Consulter** [`.opencode/PLANS.md`](.opencode/PLANS.md) — Guide des Plans d'Action
3. **Suivre** [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) — Étape par étape

---

## ✅ Vérification Rapide

Après configuration, vérifier que :

- [ ] `.opencode/agents/` a 5 fichiers ✅
- [ ] `.opencode/skills/` a 9 skills (dossiers avec `SKILL.md`) ✅
- [ ] `.opencode/instructions/` a 4 fichiers avec `[NOM_DU_PROJET]` rempli ✅
- [ ] `.opencode/instructions/*.instructions.md` existe et est customisé ✅
- [ ] `.opencode/PLANS.md` est accessible ✅
- [ ] Appeler `MAINa` (⚫) ou `@MAINa /maina-help` fonctionne ✅
- [ ] Appeler `Arcos` (🟠 ARC) fonctionne ✅
- [ ] Appeler `Devon` (🔵 DEV) fonctionne ✅

---

**C'est tout ! Vous êtes prêt à collaborer avec OpenCode. 🚀**

Lisez [`.opencode/README.md`](.opencode/README.md) pour plus de détails sur chaque agent et prompt.


