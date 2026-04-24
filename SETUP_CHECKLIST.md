# ✅ Checklist : Initialiser Copilot dans un Nouveau Projet

Utiliser cette checklist pour **initialiser rapidement** ce dépôt de templates dans votre projet.

---

## 🚀 Étape 1 : Copier les Templates et Agents

- [ ] Copier `.github/agents/*.md` vers votre projet
- [ ] Copier `.github/PLANS.md` vers votre projet
- [ ] Copier `.github/copilot-instructions.template.md` vers votre projet
- [ ] Créer `.github/prompts/` si inexistant
- [ ] Copier `.github/prompts/init-copilot-instructions.prompt.md` vers votre projet

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

### Option B : Manuel
1. [ ] Copier `copilot-instructions.template.md` → `copilot-instructions.md`
2. [ ] Ouvrir et remplir les sections `[...]` :
   - [ ] `[NOM_DU_PROJET]`
   - [ ] **Présentation du Projet**
   - [ ] **Commandes**
   - [ ] **Architecture**
   - [ ] **Conventions Clés**
   - [ ] **État du Projet**

---

## 🔧 Étape 3 : Valider et Enrichir

- [ ] Exécuter ce prompt pour auditer le code :
  ```
  👤 "Complète les instructions Copilot depuis le code source"
  ```

- [ ] Vérifier que **AUCUN** placeholder `[...]` ne subsiste
- [ ] Vérifier que les sections sont pertinentes pour votre projet
- [ ] Supprimer les sections non applicables (ex: conventions mobile si projet backend)

---

## 📋 Étape 4 : Configurer les Plans d'Action

- [ ] Créer `.github/plans/` s'il n'existe pas
- [ ] Créer `.github/plans/README.md` (ou utiliser le template)
- [ ] Ajouter `.github/PLANS.md` comme guide de référence

---

## ✨ Étape 5 : Premier Test

- [ ] Vérifier que vous pouvez appeler les agents :
  ```
  👤 "Conçois une architecture pour une authentification JWT"
  ```
  → `Arkos (🟠 ARC)` doit répondre

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
👤 "Conçois une architecture pour refactoriser la base de données et crée un plan d'action"
```
→ `Arkos (🟠 ARC)` crée un Plan d'Action

### Mettre à Jour la Documentation
```
👤 "Mets à jour la documentation après cette implémentation"
```
→ `Docly (🟣 DOC)` s'en charge

---

## 🔄 Maintenance Continue

- [ ] **Chaque mois** : Exécuter `update-copilot-instructions` pour synchroniser
- [ ] **Après un changement majeur** : Mettre à jour `.github/copilot-instructions.md`
- [ ] **Quand une initiative grande** : Créer un Plan d'Action dans `.github/plans/`

---

## ✅ Checklist Finale

Avant de considérer Copilot "prêt" :

- [ ] `.github/copilot-instructions.md` existe et est customisé
- [ ] `.github/agents/*.md` (4 fichiers) sont présents
- [ ] `.github/PLANS.md` est accessibles
- [ ] Aucun placeholder `[...]` dans copilot-instructions.md
- [ ] Premier test avec `Arkos (🟠 ARC)` réussi ✅
- [ ] Premier test avec `Devon (🔵 DEV)` réussi ✅
- [ ] Équipe sensibilisée au workflow multi-agents

---

**🎉 Vous êtes prêt ! Commencez à collaborer avec Copilot et les agents.**

Pour en savoir plus, consulter :
- [`.github/README.md`](.github/README.md) — Guide complet
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — Instructions du projet
- [`.github/PLANS.md`](.github/PLANS.md) — Guide des Plans d'Action



