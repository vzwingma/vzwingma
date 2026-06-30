# 🚀 Guide Rapide : Utiliser Ce Dépôt de Templates Claude Code

Bienvenue ! Ce dépôt contient les **templates et agents réutilisables** pour orchestrer le développement avec Claude Code.

---

## ⚡ TL;DR — 3 Étapes Rapides

Si vous avez un **nouveau projet** et voulez initialiser Claude Code rapidement :

### 1️⃣ Copier les Fichiers Essentiels

```bash
# Depuis ce dépôt vers votre projet
cp -r .claude/agents <votre_projet>/.claude/
cp -r .claude/instructions <votre_projet>/.claude/
cp -r .claude/skills <votre_projet>/.claude/
cp .claude/PLANS.md <votre_projet>/.claude/
cp .claude/README.md <votre_projet>/.claude/
cp .claude/CLAUDE.template.md <votre_projet>/.claude/CLAUDE.md
mkdir -p <votre_projet>/.claude/prompts
cp .claude/prompts/*.prompt.md <votre_projet>/.claude/prompts/
```

### 2️⃣ Initialiser les Instructions

Ouvrir Claude Code dans votre projet et lancer le prompt d'initialisation :

- [`.claude/prompts/init-copilot-instructions.prompt.md`](.claude/prompts/init-copilot-instructions.prompt.md) — pour initialiser un nouveau projet
- [`.claude/prompts/update-copilot-instructions.prompt.md`](.claude/prompts/update-copilot-instructions.prompt.md) — pour auditer et mettre à jour un projet existant

Commande typique :

```
👤 "Initialise les instructions Claude pour ce projet grâce au prompt d'initialisation init-copilot-instructions.prompt.md."
```

✅ Cela va analyser votre code et générer les instructions automatiquement.

Ou, pour une mise à jour après évolution du projet :

```
👤 "Mets à jour les instructions Claude depuis le code source grâce au prompt de mise à jour update-copilot-instructions.prompt.md."
```

### 3️⃣ Valider

```
👤 "Complète les instructions Claude depuis le code source"
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

- **`.claude/CLAUDE.template.md`** — template générique à customiser en `.claude/CLAUDE.md`
- **`.claude/instructions/`** — templates d'instructions agents à personnaliser par projet
- **`.claude/PLANS.md`** — guide pour orchestrer le travail multi-phases
- **`.claude/prompts/`** — prompts pour initialiser automatiquement les instructions

### 📖 Documentation

- **`.claude/README.md`** — guide complet du sous-arbre Claude
- **`SETUP_CHECKLIST.md`** — checklist pour initialiser un projet

---

## 🎯 Workflow Typique

Une fois Claude Code configuré, voici comment collaborer :

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

```
> "/plan"
```

### 2️⃣ Activer MAINa

```
👤 "/agent MAINa"
```

Vous pouvez aussi demander l'aide intégrée :

```
👤 "/maina-help"
```

### 3️⃣ Expliquer la demande

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
git clone <ce_repo> claude-templates
cp -r claude-templates/.claude/* mon-projet/.claude/
```

### Q: Est-ce que je dois tout copier ?

A: Non ! Minimum requis :

- `.claude/agents/` (5 fichiers)
- `.claude/skills/` (9 skills — un dossier par skill avec `SKILL.md`)
- `.claude/instructions/` (fichiers à personnaliser)
- `.claude/CLAUDE.template.md` (renommer en `CLAUDE.md`)
- `.claude/PLANS.md`

### Q: Comment initialiser rapidement ?

A: Une fois les fichiers copiés, exécuter dans votre projet :

```
👤 "Initialise les instructions Claude pour ce projet"
```

Prompt associé : [`.claude/prompts/init-copilot-instructions.prompt.md`](.claude/prompts/init-copilot-instructions.prompt.md).

Pour mettre à jour des instructions existantes, utiliser : [`.claude/prompts/update-copilot-instructions.prompt.md`](.claude/prompts/update-copilot-instructions.prompt.md).

### Q: Les agents sont-ils customisables ?

A: Les agents sont **génériques**, la customisation se fait dans `.claude/CLAUDE.md` et `.claude/instructions/*.instructions.md`.

### Q: Comment paralléliser les tâches entre agents ?

A: Utiliser `/fleet` quand plusieurs agents ont des tâches indépendantes.

### Q: Où stocker mes Plans d'Action ?

A: Dans `.claude/plans/` — utiliser le format `XXX_<nom>.plan.md`.

---

## 📞 Besoin d'Aide ?

1. **Lire** [`.claude/README.md`](.claude/README.md) — Guide complet
2. **Consulter** [`.claude/PLANS.md`](.claude/PLANS.md) — Guide des Plans d'Action
3. **Suivre** [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) — Étape par étape

---

## ✅ Vérification Rapide

Après configuration, vérifier que :

- [ ] `.claude/agents/` a 5 fichiers ✅
- [ ] `.claude/skills/` a 9 skills (dossiers avec `SKILL.md`) ✅
- [ ] `.claude/instructions/` contient les instructions agents ✅
- [ ] `.claude/CLAUDE.md` existe et est customisé ✅
- [ ] `.claude/PLANS.md` est accessible ✅
- [ ] Appeler `MAINa` (⚫) ou `@MAINa /maina-help` fonctionne ✅
- [ ] Appeler `ARCos` (🟠 ARC) fonctionne ✅
- [ ] Appeler `DEVon` (🔵 DEV) fonctionne ✅

---

**C'est tout ! Vous êtes prêt à collaborer avec Claude Code. 🚀**

Lisez [`.claude/README.md`](.claude/README.md) pour plus de détails sur chaque agent et prompt.
