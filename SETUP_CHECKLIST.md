# ✅ Checklist : Initialiser Copilot dans un Nouveau Projet

Utiliser cette checklist pour **initialiser rapidement** ce dépôt de templates dans votre projet.

---

## 🚀 Étape 1 : Copier les Templates et Agents

- [ ] Copier `.github/agents/*.md` vers votre projet
- [ ] Copier `.github/skills/` (8 dossiers de skills) vers votre projet
- [ ] Copier `.github/PLANS.md` vers votre projet
- [ ] Copier `.github/copilot-instructions.template.md` vers votre projet
- [ ] Copier `.github/instructions/*.instructions.md` vers votre projet
- [ ] Créer `.github/prompts/` si inexistant
- [ ] Copier `.github/prompts/init-copilot-instructions.prompt.md` vers votre projet
- [ ] Copier `docs/ARCHITECTURE.template.md` → `docs/ARCHITECTURE.md` de votre projet
- [ ] Créer `docs/adr/` et y copier `docs/adr/ADR-TEMPLATE.md`

---

## 🎯 Étape 2 : Initialiser les Instructions Copilot

### Option A : Automatique (Recommandée)
```bash
# Exécuter ce prompt
👤 "Initialise les instructions Copilot pour ce projet"
```

Le prompt va :
1. ✅ Analyser votre code source
2. ✅ Identifier le stack technologique
3. ✅ Remplir automatiquement `.github/copilot-instructions.md`
4. ✅ Génère les fichiers `.github/instructions/*.instructions.md`

### Option B : Manuel
1. [ ] Copier `copilot-instructions.template.md` → `copilot-instructions.md`
2. [ ] Ouvrir et remplir les sections `[...]` :
   - [ ] `[NOM_DU_PROJET]`
   - [ ] **Présentation du Projet**
   - [ ] **Commandes**
   - [ ] **Architecture**
   - [ ] **Conventions Clés**
   - [ ] **État du Projet**
3. [ ] Remplir les placeholders dans les 4 fichiers `instructions/` :
   - [ ] `[NOM_DU_PROJET]` dans chaque fichier
   - [ ] Stack technique dans `dev.instructions.md`
   - [ ] Commandes de test dans `qa.instructions.md`
   - [ ] Fichiers docs/ dans `doc.instructions.md`

---

## 🔧 Étape 3 : Valider et Enrichir

- [ ] Exécuter ce prompt pour auditer le code :
  ```
  👤 "Complète les instructions Copilot depuis le code source"
  ```

- [ ] Vérifier que **AUCUN** placeholder `[...]` ne subsiste
- [ ] Vérifier que les placeholders critiques (`[NOM_DU_PROJET]`, stack) sont remplis dans les fichiers `instructions/`
- [ ] Vérifier que les sections sont pertinentes pour votre projet
- [ ] Supprimer les sections non applicables (ex: conventions mobile si projet backend)

---

## 📋 Étape 4 : Configurer les Plans d'Action et la Documentation

- [ ] Créer `.github/plans/` s'il n'existe pas
- [ ] Créer `.github/plans/README.md` (ou utiliser le template)
- [ ] Ajouter `.github/PLANS.md` comme guide de référence
- [ ] Vérifier que `docs/ARCHITECTURE.md` est initialisé (sinon : `cp docs/ARCHITECTURE.template.md docs/ARCHITECTURE.md`)
- [ ] Compléter les sections **⚠️ À COMPLÉTER** dans `docs/ARCHITECTURE.md`

---

## ✨ Étape 5 : Premier Test

- [ ] Vérifier que vous pouvez appeler les agents :
  ```
  👤 "@MAINa /maina-help"
  ```
  → `MAINa (⚫)` doit expliquer workflow et commandes

- [ ] Vérifier orchestration MAINa :
  ```
  👤 "Organise ce besoin de bout en bout"
  ```
  → `MAINa (⚫)` doit présenter des options (ARCos), créer le Plan d'Action, puis imposer les gates humains

- [ ] Tester un prompt :
  ```
  👤 "Initialise les instructions Copilot pour ce projet"
  ```

---

## 📚 Étape 6 : Documenter

- [ ] Ajouter une note dans `README.md` :
  ```markdown
  ## 🤖 Copilot & Agents
  
  Ce projet utilise une architecture multi-agents orchestrée.
  Voir [`.github/copilot-instructions.md`](.github/copilot-instructions.md) pour les conventions et les instructions.
  ```

- [ ] Committer :
  ```bash
  git commit -m "chore: initialiser Copilot avec agents et templates transverses"
  ```

---

## 🎓 Utilisation Après Configuration

### Lancer une Implémentation
```
👤 "Implémente l'authentification JWT dans le service d'auth"
```
→ `Devon (🔵 DEV)` s'en charge

### Écrire des Tests
```
👤 "Écris des tests pour le service d'authentification"
```
→ `Qalvin (🟢 QUAL)` s'en charge

### Planifier une Grosse Tâche
```
👤 "MAINa, organise la refactorisation de la base de données de bout en bout"
```
→ `MAINa (⚫)` déclenche ARCos puis orchestre le workflow

### Mettre à Jour la Documentation
```
👤 "Mets à jour la documentation après cette implémentation"
```
→ `Docly (🟣 DOC)` s'en charge

### Paralléliser des Tâches Indépendantes
```
👤 "Lance DEVon sur le composant A et QALvin sur le composant B en parallèle"
```
→ Utiliser `/fleet` : les tâches sans dépendance s'exécutent simultanément

---

## 🔄 Maintenance Continue

- [ ] **Chaque mois** : Exécuter `update-copilot-instructions` pour synchroniser
- [ ] **Après un changement majeur** : Mettre à jour `.github/copilot-instructions.md`
- [ ] **Quand une initiative grande** : Créer un Plan d'Action dans `.github/plans/`
- [ ] **Tâches parallèles** : Utiliser `/fleet` quand DEVon, QALvin ou DOCly ont des tâches indépendantes

---

## ✅ Checklist Finale

Avant de considérer Copilot "prêt" :

- [ ] `.github/copilot-instructions.md` existe et est customisé
- [ ] `.github/agents/*.md` (5 fichiers) sont présents
- [ ] `.github/skills/*/SKILL.md` (8 skills) présents
- [ ] `.github/instructions/*.instructions.md` (4 fichiers) présents et personnalisés
- [ ] `.github/PLANS.md` est accessible
- [ ] `docs/ARCHITECTURE.md` existe et les sections ⚠️ sont complétées
- [ ] `docs/adr/` existe (avec `ADR-TEMPLATE.md` comme modèle)
- [ ] Aucun placeholder `[...]` dans copilot-instructions.md
- [ ] Premier test avec `MAINa (⚫)` réussi ✅
- [ ] Premier test avec `Arcos (🟠 ARC)` réussi ✅
- [ ] Premier test avec `Devon (🔵 DEV)` réussi ✅
- [ ] Équipe sensibilisée au workflow multi-agents

---

**🎉 Vous êtes prêt ! Commencez à collaborer avec Copilot et les agents.**

Pour en savoir plus, consulter :
- [`.github/README.md`](.github/README.md) — Guide complet
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — Instructions du projet
- [`.github/PLANS.md`](.github/PLANS.md) — Guide des Plans d'Action

