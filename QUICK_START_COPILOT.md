# 🚀 Guide Rapide : Utiliser Ce Dépôt de Templates

Bienvenue ! Ce dépôt contient les **templates et agents réutilisables** pour orchestrer le développement avec Copilot.

---

## ⚡ TL;DR — 3 Étapes Rapides

Si vous avez un **nouveau projet** et voulez initialiser Copilot rapidement :

### 1️⃣ Copier les Fichiers Essentiels

```bash
# Depuis ce dépôt vers votre projet
cp -r .github/agents <votre_projet>/.github/
cp -r .github/instructions <votre_projet>/.github/
cp -r .github/skills <votre_projet>/.github/
cp .github/PLANS.md <votre_projet>/.github/
cp .github/copilot-instructions.template.md <votre_projet>/.github/copilot-instructions.md
mkdir -p <votre_projet>/.github/prompts
cp .github/prompts/*.prompt.md <votre_projet>/.github/prompts/
```

### 2️⃣ Initialiser les Instructions

Ouvrir Copilot dans votre projet et lancer le prompt d'initialisation :

- [`.github/prompts/init-copilot-instructions.prompt.md`](.github/prompts/init-copilot-instructions.prompt.md) — pour initialiser un nouveau projet
- [`.github/prompts/update-copilot-instructions.prompt.md`](.github/prompts/update-copilot-instructions.prompt.md) — pour auditer et mettre à jour un projet existant

Commande typique :

```
👤 "Initialise les instructions Copilot pour ce projet grâce au prompt d'initialisation init-copilot-instructions.prompt.md."
```

✅ Cela va analyser votre code et générer les instructions automatiquement.

Ou, pour une mise à jour après évolution du projet :

```
👤 "Mets à jour les instructions Copilot depuis le code source grâce au prompt de mise à jour update-copilot-instructions.prompt.md."
```

### 3️⃣ Valider

```
👤 "Complète les instructions Copilot depuis le code source"
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
- **`copilot-instructions.template.md`** — Template générique à customiser
- **`instructions/`** — 4 templates d'instructions agents à personnaliser par projet
- **`PLANS.md`** — Guide pour orchestrer le travail multi-phases
- **Prompts** — Pour initialiser automatiquement les instructions

### 📖 Documentation
- **`.github/README.md`** — Guide complet du dépôt
- **`SETUP_CHECKLIST.md`** — Checklist pour initialiser un projet

---

## 🎯 Workflow Typique

Une fois Copilot configuré, voici comment collaborer :

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
cp -r copilot-templates/.github/* mon-projet/.github/
```

### Q: Est-ce que je dois tout copier ?
A: Non ! Minimum requis :
- `.github/agents/` (5 fichiers)
- `.github/skills/` (9 skills — un dossier par skill avec `SKILL.md`)
- `.github/instructions/` (4 fichiers — à personnaliser)
- `.github/copilot-instructions.template.md` (renommer en `copilot-instructions.md`)
- `.github/PLANS.md`

### Q: Comment initialiser rapidement ?
A: Une fois les fichiers copiés, exécuter dans votre projet :
```
👤 "Initialise les instructions Copilot pour ce projet"
```
Prompt associé : [`.github/prompts/init-copilot-instructions.prompt.md`](.github/prompts/init-copilot-instructions.prompt.md).

Pour mettre à jour des instructions existantes, utiliser : [`.github/prompts/update-copilot-instructions.prompt.md`](.github/prompts/update-copilot-instructions.prompt.md).

### Q: Les agents sont-ils customisables ?
A: Les agents sont **génériques**, la customisation se fait dans deux endroits : `.github/copilot-instructions.md` (contexte global) et `.github/instructions/*.instructions.md` (spécificités par agent).

### Q: Comment paralléliser les tâches entre agents ?
A: Utiliser `/fleet` quand plusieurs agents ont des tâches indépendantes (ex: QALvin + DOCly après DEVon, ou plusieurs composants à implémenter sans dépendance). `/fleet` dispatche les sous-agents en simultané.

### Q: Où stocker mes Plans d'Action ?
A: Dans `.github/plans/` — utiliser le format `XXX_<nom>.plan.md`.

### Q: Quelle est la licence ?
A: Libre d'utilisation — c'est un dépôt de templates transverse.

---

## 📞 Besoin d'Aide ?

1. **Lire** [`.github/README.md`](.github/README.md) — Guide complet
2. **Consulter** [`.github/PLANS.md`](.github/PLANS.md) — Guide des Plans d'Action
3. **Suivre** [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) — Étape par étape

---

## ✅ Vérification Rapide

Après configuration, vérifier que :

- [ ] `.github/agents/` a 5 fichiers ✅
- [ ] `.github/skills/` a 9 skills (dossiers avec `SKILL.md`) ✅
- [ ] `.github/instructions/` a 4 fichiers avec `[NOM_DU_PROJET]` rempli ✅
- [ ] `.github/copilot-instructions.md` existe et est customisé ✅
- [ ] `.github/PLANS.md` est accessible ✅
- [ ] Appeler `MAINa` (⚫) ou `@MAINa /maina-help` fonctionne ✅
- [ ] Appeler `Arcos` (🟠 ARC) fonctionne ✅
- [ ] Appeler `Devon` (🔵 DEV) fonctionne ✅

---

**C'est tout ! Vous êtes prêt à collaborer avec Copilot. 🚀**

Lisez [`.github/README.md`](.github/README.md) pour plus de détails sur chaque agent et prompt.


