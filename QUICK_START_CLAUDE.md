# 🚀 Guide Rapide : Utiliser Ce Dépôt de Templates

Bienvenue ! Ce dépôt contient les **templates et agents réutilisables** pour orchestrer le développement avec Claude.

---

## ⚡ TL;DR — 3 Étapes Rapides

Si vous avez un **nouveau projet** et voulez initialiser Claude rapidement :

### 1️⃣ Copier les Fichiers Essentiels

```bash
# Depuis ce dépôt vers votre projet
cp -r .claude/agents <votre_projet>/.claude/
cp -r .claude/skills <votre_projet>/.claude/
cp .claude/PLANS.md .claude/CLAUDE.template.md <votre_projet>/.claude/
mkdir -p <votre_projet>/docs/adr
cp docs/ARCHITECTURE.template.md <votre_projet>/docs/
cp docs/adr/ADR-TEMPLATE.md <votre_projet>/docs/adr/
```
<!-- claude-only -->
Garde-fous (permissions + hook de blocage) :

```bash
cp -r .claude/hooks .claude/settings.template.json <votre_projet>/.claude/
```
<!-- /claude-only -->
<!-- copilot-only
GitHub Copilot CLI : ne copier aucune projection à la main. Depuis la source `.claude/`, générer
`.github/` avec `scripts/sync-claude-to-github.ps1`, puis vérifier avec `-Check`.

La cible vérifiée est la CLI Copilot (`1.0.99-0`, puis `1.0.99-1`). VS Code et cloud agent sont hors
périmètre.
-->

### 2️⃣ Initialiser les Instructions

Ouvrir Claude dans votre projet et lancer :

```
/init-harness
```

✅ Analyse le code, génère `CLAUDE.md` depuis le template et remplit les conventions par rôle
(nouveau projet ou projet existant).

Pour une mise à jour après évolution du projet :

```
/update-harness
```

### 3️⃣ Valider

Relire les placeholders `[...]` restants signalés par `/init-harness` et les compléter.

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
- **`CLAUDE.template.md`** — Template générique à customiser
- **`skills/conventions-<rôle>/`** — conventions projet par agent (templates remplis par `/init-harness`)
- **`PLANS.md`** — Guide pour orchestrer le travail multi-phases
- **`/init-harness`, `/update-harness`** — initialisation et mise à jour automatiques

### 📖 Documentation
- **`.claude/README.md`** — Guide complet du dépôt
- **`SETUP_CHECKLIST.md`** — Checklist pour initialiser un projet

---

## 🎯 Workflow Typique

Une fois Claude configuré, voici comment collaborer :

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

> 💡 **Parallélisation** : jamais entre phases séparées par un gate (DOCly attend la validation des tests) ; possible au sein d'une phase quand plusieurs tâches sont indépendantes.

---

## 🧭 Lancer Une Demande Avec MAINa

Pour une demande structurante, utilisez MAINa comme point d'entrée. L'objectif est de cadrer avant d'implémenter, puis de valider chaque gate humain.

<!-- claude-only -->
### 1️⃣ Lancer MAINa

MAINa doit être l'**agent principal** de la session pour pouvoir poser les questions de gate :

```bash
claude --agent MAINa
```

Dans une session déjà ouverte : `/maina <besoin>`. Aide intégrée : `/maina-help`.

> ⚠️ Ne pas activer le mode plan de Claude Code (Shift+Tab) : il interdit les écritures, donc la création du
> Plan d'Action dans `docs/plans/`. MAINa conduit lui-même cadrage, plan et gates.
<!-- /claude-only -->
<!-- copilot-only
### 1️⃣ Activer MAINa

Lancer **MAINa** dans GitHub Copilot CLI (`copilot --agent MAINa`) ou `/agent MAINa`. Aide intégrée :
`/maina-help`.

Chaque profil généré demande explicitement le chargement de ses skills. La CLI les sélectionne selon
pertinence ; `.github/skills/` l'emporte sur `.claude/skills/` à nom identique.
-->

### 2️⃣ Expliquer la demande

Décrivez le besoin avec le plus de contexte utile possible :

```
👤 "Besoin : [objectif].
Contexte : [code, métier, contrainte technique].
Contraintes : [délais, compatibilité, sécurité, tests].
Livrables attendus : [code, tests, documentation, ADR]."
```

### 3️⃣ Valider l'option recommandée

MAINa consulte ARCos pour comparer plusieurs options. Avant tout plan détaillé, validez le choix de solution proposé.

```
👤 "Je valide l'option 2. Crée le Plan d'Action."
```

### 4️⃣ Valider le Plan d'Action

MAINa produit ensuite le Plan d'Action. Relisez le périmètre, les tâches, les dépendances et les gates.

```
👤 "Plan validé. Tu peux lancer la phase d'implémentation."
```

### 5️⃣ Suivre les phases et gates

Après chaque phase, MAINa vous présente le livrable et ses **preuves** (bloc `handoff` de l'agent), puis
demande une décision `GO` / `AJUSTER` / `STOP`, consignée dans le journal des gates du plan :

- **Gate #2** — code DEVon : build, lint, tests existants verts + revue automatique code et sécurité
- **Gate #3** — tests QALvin : résultats, couverture, détection de régression
- **Gate #4** — documentation DOCly : fichiers mis à jour, ADR `Acceptée`, plan clôturé

`AJUSTER` relance le même agent avec vos retours ; rien n'avance sans `GO`.

<!-- copilot-only
Les scénarios AP 006 ont observé l'arrêt de MAINa au Gate #0 en mode `-p`, mais cet arrêt n'est pas une
garantie native générale. Gardes, exclusion des chemins, frontières DEVon/QALvin/DOCly et arrêt aux autres
gates restent des comportements observés ou portés par la prose.
-->

---

## ❓ FAQ

### Q: Comment copier rapidement ce dépôt vers mon projet ?
A: 
```bash
git clone <ce_repo> copilot-templates
cp -r copilot-templates/.claude/* mon-projet/.claude/
```

### Q: Est-ce que je dois tout copier ?
A: Non ! Minimum requis :
- `.claude/agents/` (5 fichiers)
- `.claude/skills/` (un dossier par skill avec `SKILL.md`, conventions par rôle incluses)
- `.claude/CLAUDE.template.md` (`/init-harness` génère `CLAUDE.md`)
- `.claude/PLANS.md`

### Q: Comment initialiser rapidement ?
A: Une fois les fichiers copiés, exécuter dans votre projet :
```
/init-harness
```

Pour mettre à jour des instructions existantes : `/update-harness`.

### Q: Les agents sont-ils customisables ?
A: Les agents sont **génériques**, la customisation se fait dans deux endroits : `.claude/CLAUDE.md` (contexte global) et les conventions par rôle (<!-- claude-only -->`.claude/skills/conventions-<rôle>/SKILL.md`<!-- /claude-only --><!-- copilot-only `.claude/instructions/<rôle>.instructions.md` -->).

### Q: Comment paralléliser les tâches entre agents ?
A: Au sein d'une même phase uniquement, pour des tâches indépendantes (ex: plusieurs composants sans dépendance) — jamais à travers un gate. Voir skill `parallel-guide`.

### Q: Où stocker mes Plans d'Action ?
A: Dans `docs/plans/` — utiliser le format `XXX_<nom>.plan.md`.

### Q: Quelle est la licence ?
A: Libre d'utilisation — c'est un dépôt de templates transverse.

---

## 📞 Besoin d'Aide ?

1. **Lire** [`.claude/README.md`](.claude/README.md) — Guide complet
2. **Consulter** [`.claude/PLANS.md`](.claude/PLANS.md) — Guide des Plans d'Action
3. **Suivre** [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) — Étape par étape

---

## ✅ Vérification Rapide

Après configuration, vérifier que :

- [ ] `.claude/agents/` a 5 fichiers ✅
- [ ] `.claude/skills/` présent (dossiers avec `SKILL.md`) ✅
- [ ] Conventions par rôle remplies (aucun `[NOM_DU_PROJET]` restant) ✅
- [ ] `.claude/CLAUDE.md` existe et est customisé ✅
- [ ] `.claude/PLANS.md` est accessible ✅
<!-- claude-only -->
- [ ] `/agents` liste les 5 agents (modèle, outils) ✅
- [ ] `/hooks` affiche le hook `guard.sh` (après redémarrage de session) ✅
<!-- /claude-only -->
- [ ] `/maina-help` répond ✅
- [ ] `/arcos <question>` et `/devon <tâche>` lancent l'agent et rendent un bloc `handoff` ✅

---

**C'est tout ! Vous êtes prêt à collaborer avec Claude. 🚀**

Lisez [`.claude/README.md`](.claude/README.md) pour plus de détails sur chaque agent et skill.

