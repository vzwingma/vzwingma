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

Ouvrir Copilot dans votre projet et exécuter :

```
👤 "Initialise les instructions Copilot pour ce projet"
```

✅ Cela va analyser votre code et générer les instructions automatiquement.

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
- **🟠 ARCos** — Planifie et crée les Plans d'Action
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
2️⃣ ⚫ MAINa orchestre et déclenche ARCos
   ↓
3️⃣ ✅ Validation humaine du plan
   ↓
4️⃣ 🔵 DEVon implémente les tâches
   ↓
5️⃣ ✅ Validation humaine du code
   ↓
6️⃣ 🟢 QALvin écrit les tests
   ↓
7️⃣ ✅ Validation humaine des tests
   ↓
8️⃣ 🟣 DOCly met à jour la documentation
   ↓
9️⃣ ✅ Validation humaine finale
```

> 💡 **Parallélisation** : Utiliser `/fleet` quand QALvin et DOCly peuvent travailler en parallèle après DEVon, ou quand plusieurs tâches DEVon sont indépendantes.

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
- `.github/skills/` (3 skills — un dossier par skill avec `SKILL.md`)
- `.github/instructions/` (4 fichiers — à personnaliser)
- `.github/copilot-instructions.template.md` (renommer en `copilot-instructions.md`)
- `.github/PLANS.md`

### Q: Comment initialiser rapidement ?
A: Une fois les fichiers copiés, exécuter dans votre projet :
```
👤 "Initialise les instructions Copilot pour ce projet"
```

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
3. **Regarder** [`.github/examples/`](.github/examples/) — Exemples concrets
4. **Suivre** [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) — Étape par étape

---

## ✅ Vérification Rapide

Après configuration, vérifier que :

- [ ] `.github/agents/` a 5 fichiers ✅
- [ ] `.github/skills/` a 3 skills (dossiers avec `SKILL.md`) ✅
- [ ] `.github/instructions/` a 4 fichiers avec `[NOM_DU_PROJET]` rempli ✅
- [ ] `.github/copilot-instructions.md` existe et est customisé ✅
- [ ] `.github/PLANS.md` est accessible ✅
- [ ] Appeler `MAINa` (⚫) ou `@MAINa /help` fonctionne ✅
- [ ] Appeler `Arcos` (🟠 ARC) fonctionne ✅
- [ ] Appeler `Devon` (🔵 DEV) fonctionne ✅

---

**C'est tout ! Vous êtes prêt à collaborer avec Copilot. 🚀**

Lisez [`.github/README.md`](.github/README.md) pour plus de détails sur chaque agent et prompt.


