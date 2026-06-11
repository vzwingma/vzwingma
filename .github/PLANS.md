# 📋 Action Plans (AP) — Centralised Documentation

**Document:** `.github/PLANS.md`  
**Purpose:** Centralised guide for creating, executing and tracking multi-phase action plans.

---

## 🎯 What is an Action Plan (AP)?

An **Action Plan (AP)** is a structured document that:
- Describes a **global objective** (for example: modernisation, new feature, major refactoring)
- Breaks down into **logical phases** and **detailed tasks**
- Assigns tasks to **specific agents** (Devon/🔵 DEV, Qalvin/🟢 QUAL, Arkos/🟠 ARC, Docly/🟣 DOC)
- Defines **success criteria** and **dependencies** between phases
- Generates **phase reports** documenting execution and results

**Use cases:**
- Modernise infrastructure and tests (AP-001: Complete Modernisation)
- Implement a large cross-team feature
- Refactor a complex business domain
- Co-ordinate dependent updates

---

## 📂 Directory Structure

```
.github/
├── PLANS.md                              # Ce document (guide centralisé)
├── plans/
│   ├── 001_feature_1.plan.md    # Fichier plan principal
│   ├── 001_reports/                          # Dossier de reporting
│   │   ├── PHASE_1_COMPLETION_REPORT.md
│   │   ├── PHASE_2_COMPLETION_REPORT.md
│   │   └── PHASE_N_FINAL_REVIEW.md
│   ├── 002_nouvelle_feature.plan.md          # Autre plan
│   ├── 002_reports/
│   │   └── PHASE_1_...
│   └── README.md                        # Index des plans actifs/archivés
└── ...
```

**Naming conventions:**
- Plan file: `.github/plans/<NO>_<nom_descriptif>.plan.md`
  - `<NO>`: Sequential number (001, 002, 003...)
  - `<nom_descriptif>`: Descriptive slug in French or English
  - Example: `001_modernisation_complète.plan.md`
- Reporting folder: `.github/plans/<NO>_reports/`
  - Contains phase reports (`PHASE_1_...`, `PHASE_2_...`, etc.)
  - One report per completed phase

---

## 📝 Plan File Format (`.plan.md`)

### 1. Header (Metadata)

```markdown
# Plan d'Action : <Titre Explicite>

**Document :** `.github/plans/<NO>_<nom>.plan.md`  
**Date de création :** YYYY-MM-DD  
**Statut :** ✅ Complété | 🔄 En cours | ⏳ Planifié | ❌ Bloqué  
**Objectif Prioritaire :** [HIGH | MEDIUM | LOW]

---
```

### 2. Global Objective (1-2 paragraphs)

```markdown
## 🎯 Objectif Global

[Décrire le problème ou le besoin en 1-2 phrases]
[Lister les domaines d'amélioration ou les outcomes attendus]

Exemple :
"Moderniser l'application domoticz-mobile en améliorant la couverture de test, 
les dépendances à jour, l'architecture du code et la performance. 
Objectifs : couverture ≥80%, 0 dépendances dépréciées, 0 breaking changes, 
documentation exhaustive."
```

### 3. Phases (One per section)

Each phase must contain:

#### A. Context
```markdown
### Contexte
- [Situation actuelle / problèmes identifiés]
- [Dépendances avec d'autres phases]
- [Ressources/outils disponibles]
```

#### B. Success Criteria
```markdown
### Critères de Réussite
✅ [Condition testable 1]  
✅ [Condition testable 2]  
✅ [Condition testable 3]  
```

**Good practices:**
- Use "≥X%" rather than "good", "sufficient"
- Measurable and verifiable
- List 3-5 criteria max per phase

#### C. Tasks
```markdown
### Tâches (Agent: [Devon (🔵 DEV) | Qalvin (🟢 QUAL) | Arkos (🟠 ARC) | Docly (🟣 DOC)])

#### T<N>.<M> - <Titre de la Tâche>
- **Fichier :** `path/to/file.ts` (ou liste si multiple)
- **Couvrir/Implémenter :**
  - Point 1
  - Point 2
- **Acceptation :** Condition mesurable

#### T<N>.<M+1> - <Autre Tâche>
- ...
```

**Numbering:**
- `T<PHASE>.<NUMERO>`: T1.1, T1.2, T2.1, T3.3, etc.
- Unique per phase
- Recommended execution order

**Task template:**
```markdown
#### T<N>.<M> - <Verbe d'action> <objet> (<scope optionnel>)

- **Fichier(s) :** Chemin exact des fichiers à créer/modifier
- **Couvrir / Implémenter :**
  - Fonctionnalité 1 (avec détails)
  - Fonctionnalité 2
  - Cas d'erreur ou edge cases
- **Acceptation :** Condition mesurable et testable
  - ✓ ≥90% couverture (si tests)
  - ✓ Tous les cas couverts (si logique)
  - ✓ Performance < 1s (si perf)
```

### 4. Summary of Tasks by Agent

```markdown
## 📊 Résumé des Tâches par Agent

### Devon (🔵 DEV) Agent
- T2.1 à T2.8 : Mise à jour des dépendances
- T3.1 à T3.5 : Refactorisation architecture
- **Livrable :** Dépendances à jour, code refactorisé, tests passant
- **Durée estimée :** 2-3 semaines

### Qalvin (🟢 QUAL) Agent
- T1.1 à T1.7 : Tests unitaires + rapport de couverture
- **Livrable :** Tests ≥80% couverture
- **Durée estimée :** 1-2 semaines
```

### 5. Dependencies Between Phases

```markdown
## 📍 Dépendances entre Phases

```
Phase 1 (Tests)
    ↓
Phase 2 (Dépendances) ← [Phase 1 doit être ✅]
    ↓
Phase 3 (Architecture) ← [Phase 2 doit être ✅]
    ↓
Phase 4 (Performance) ← [Phase 3 doit être ✅]
    ↓
Phase 5 (CI/CD) ← [Phases 1, 2, 3 doivent être ✅]
    ↓
Phase 6 (Docs) ← [Phases 1-5 doivent être ✅]
```

**Règles :**
- Phase X peut démarrer si toutes ses dépendances sont ✅
- Indiquer explicitement les "dépend de" avec `←`
- Phases sans dépendances = peuvent démarrer en parallèle
```

### 6. Global Success Criteria

```markdown
## ✅ Critères de Succès Globaux

1. **Couverture de test ≥80%** (Phase 1)
2. **0 dépendances dépréciées** (Phase 2)
3. **0 `any` non-justifiés** (Phase 3)
4. **Bundle size stable ou ↓** (Phase 4)
5. **CI/CD 100% passing** (Phase 5)
6. **Documentation à jour** (Phase 6)
```

### 7. Execution Plan

```markdown
## 🚀 Plan d'Exécution

1. **Semaine 1-2 :** Lancer Phase 1 (Qalvin (🟢 QUAL) agent)
2. **Semaine 2-3 :** Lancer Phase 2 (Devon (🔵 DEV) agent, après Phase 1 ✅)
3. **Semaine 3-4 :** Lancer Phases 3-4 en parallèle (Devon (🔵 DEV) agent)
4. **Semaine 4-5 :** Lancer Phase 5 (Arkos (🟠 ARC), après Phase 3 ✅)
5. **Semaine 5-6 :** Lancer Phase 6 en parallèle (Docly (🟣 DOC))

**Triggers pour démarrer une phase :**
- Tous les rapports de la phase précédente ✅ COMPLÉTÉE
- Tous les critères de réussite atteints
- Pas de bloqueurs signalés
```

---

## 📈 Phase Reports (Execution Tracking)

### Reporting Structure

For each plan, create a `.github/plans/<NO>_reports/` folder with one report per phase:

```
.github/plans/001_reports/
├── PHASE_1_COMPLETION_REPORT.md
├── PHASE_2_COMPLETION_REPORT.md
├── PHASE_3_COMPLETION_REPORT.md
└── PHASE_6_FINAL_REVIEW.md
```

### Format of a Phase Report

```markdown
# Phase N : <Titre de la Phase>

**Responsable Agent :** [Devon (🔵 DEV) | Qalvin (🟢 QUAL) | Arkos (🟠 ARC) | Docly (🟣 DOC)]  
**Date Début :** YYYY-MM-DD  
**Date Fin :** YYYY-MM-DD (ou TBD si en cours)  
**Statut :** ✅ COMPLÉTÉE | 🔄 EN_COURS | ⏳ PLANIFIÉE | ❌ BLOQUÉE

---

## 📝 Tâches

### T<N>.<M> - <Titre Tâche>

**Statut :** ✅ DONE | 🔄 IN_PROGRESS | ⏳ PENDING | ❌ BLOCKED  
**Date Fin :** YYYY-MM-DD (ou en cours si 🔄)

**Fichiers Modifiés / Créés :**
- `path/to/file1.ts` — [Brève description des changements]
- `path/to/file2.tsx` — [Ajout du composant X, refactorisation de Y]

**Résultats Quantifiés :**
- Coverage : 92% (critère : ≥90% ✅)
- Tests : 25/25 passants ✅
- Build time : 4min45s (vs. 5min avant) ✅

**Notes / Décisions :**
- [Problème rencontré et comment il a été résolu]
- [Hypothèses faites]
- [Améliorations futures identifiées (non implémentées)]

---

### T<N>.<M+1> - ...

[Répéter pour chaque tâche]

---

## 📊 Synthèse de Phase

**Tâches Complétées :** 7/7 ✅  
**Critères de Réussite Atteints :**
- ✅ Couverture ≥80%
- ✅ Tous les services testés
- ✅ Tous les controllers testés
- ✅ Composants critiques testés
- ✅ Aucun regression

**Bloqueurs :** Aucun ❌  
**Améliorations Futures :**
- [ ] Ajouter tests E2E pour les workflows critiques
- [ ] Augmenter couverture à ≥90%

---

## 📦 Livrables

✅ Tous les tests unitaires écrits et passants  
✅ Rapport de couverture dans `coverage/`  
✅ Aucune regression (tous les tests existants passent)  

---

**Rapport approuvé par :** [Utilisateur/Lead]  
**Date d'approbation :** YYYY-MM-DD  

Fin du rapport Phase N
```

---

## 🔄 Tracking Workflow

### 1. Create the Plan (User / Arkos (🟠 ARC))

```bash
# Créer le fichier plan
touch .github/plans/00X_<nom>.plan.md

# Remplir :
# - Objectif global
# - Phases avec contexte, critères, tâches
# - Dépendances
# - Critères de succès
# - Plan d'exécution
```

**Validation:**
- [ ] Phases are clearly separated with clear dependencies
- [ ] Each task has an explicit scope and measurable criteria
- [ ] Assigned agents are consistent with the tasks
- [ ] The dependency plan is acyclic

### 2. Start a Phase (Responsible Agent)

```bash
# 1. Lire le plan complet
cat .github/plans/<NO>_<nom>.plan.md

# 2. Identifier les tâches assignées
# Exemple : Agent Qalvin (🟢 QUAL) cherche "T<N>.<M>" où l'agent est "Qalvin (🟢 QUAL)"

# 3. Créer le rapport de phase
mkdir -p .github/plans/<NO>_reports/
touch .github/plans/<NO>_reports/PHASE_N_COMPLETION_REPORT.md

# 4. Exécuter les tâches T<N>.1, T<N>.2, etc.
# 5. Documenter en temps réel dans le rapport
```

### 3. Document During Execution

For each completed task:
```markdown
### T<N>.<M> - [Titre]

**Statut :** ✅ DONE (mise à jour depuis 🔄 IN_PROGRESS)
**Date Fin :** YYYY-MM-DD

**Fichiers Modifiés :**
- `app/services/__tests__/ClientHTTP.service.test.ts` — Ajout 50 tests
- `app/services/ClientHTTP.service.ts` — Nettoyage lint

**Résultats :**
- Coverage : 92% (critère ≥90% ✅)
- Tests : 50/50 passing

**Notes :**
- Découvert et fixé [bug X] qui bloquait les tests de mock API
```

### 4. Complete the Reporting (After the Phase)

Fill in the **phase summary**:
```markdown
## 📊 Synthèse de Phase

**Tâches Complétées :** 7/7 ✅
**Critères de Réussite Atteints :**
- ✅ Critère 1
- ✅ Critère 2
- ✅ Critère 3

**Bloqueurs :** Aucun
**Prochaine Phase :** Phase X peut démarrer (toutes les dépendances ✅)
```

### 5. Validate and Archive (User / Lead)

```bash
# Approuver le rapport
# Lister dans README si archivé
# Créer issue GitHub pour tracking si souhaité
```

---

## 🎯 Integration with the Agents

Each agent must receive a **structured prompt** that:
1. **Points to the plan** (`.github/plans/<NO>_<nom>.plan.md`)
2. **Identifies its tasks** (T<N>.X where agent = [its role])
3. **Specifies the report to fill in** (`.github/plans/<NO>_reports/PHASE_N_...`)

**Example prompt for Qalvin (🟢 QUAL):**
```
Exécute la Phase 1 du plan : .github/plans/001_modernisation_complète.plan.md

**Tâches assignées :**
- T1.1 : Tests ClientHTTP.service
- T1.2 : Tests DataUtils.service
- ... (T1.1 à T1.7)

**Rapport à remplir :**
- `.github/plans/001_reports/PHASE_1_COMPLETION_REPORT.md`

**Pour chaque tâche, documenter :**
- Fichiers créés/modifiés
- Résultats (coverage %, test count, etc.)
- Notes et décisions
- Statut final (✅ DONE ou ❌ BLOCKED + raison)

**À la fin :**
- Remplir la synthèse de phase
- Confirmer critères de réussite atteints
- Signaler tout bloqueur pour la phase suivante
```

**Delegation chain between agents:**
```
Arkos (🟠 ARC) (plan)
    ↓
Devon (🔵 DEV) (T2.1-T3.5)
    ├→ Qalvin (🟢 QUAL) (valider + écrire tests)
    └→ Docly (🟣 DOC) (documenter changements)
```

---

## ✅ Checklist for a Good Plan

- [ ] **Explicit title** (for example: "Complete Modernisation", not "AP-001")
- [ ] **Clear objective** (1-2 sentences, measurable)
- [ ] **Well-separated phases** (3-6 phases generally)
- [ ] **Each phase has:**
  - [ ] Context (current situation)
  - [ ] Success criteria (3-5, measurable)
  - [ ] Numbered tasks (T<N>.<M>)
  - [ ] Responsible agent identified
- [ ] **Each task has:**
  - [ ] Title with action verb
  - [ ] Precise files
  - [ ] Explicit scope (what to cover / implement)
  - [ ] Testable acceptance criteria
- [ ] **Explicit dependencies** (diagram or list)
- [ ] **Global success criteria** (5-7 items)
- [ ] **Execution plan** (when to start each phase, triggers)

---

## ✅ Checklist for a Good Phase Report

- [ ] **Complete header** (Agent, dates, status)
- [ ] **Each task documents:**
  - [ ] Final status (✅ DONE, ❌ BLOCKED, etc.)
  - [ ] Modified/created files (precise paths)
  - [ ] Measured results (coverage %, count, etc.)
  - [ ] Relevant notes
- [ ] **Phase summary:**
  - [ ] Completed tasks (X/Y)
  - [ ] Success criteria achieved (checklist)
  - [ ] Blockers identified (where applicable)
  - [ ] Future improvements (optional)
- [ ] **Clear deliverables** (list of what was produced)

---

## 📚 Existing Examples

- **AP-001:** Complete Modernisation
  - Plan: `.github/plans/001_modernisation_complète.plan.md`
  - Reports: `.github/plans/001_reports/PHASE_*_*.md`
  - Phases: 1 (Tests), 2 (Dependencies), 3 (Architecture), 4 (Performance), 5 (CI/CD), 6 (Docs)
  - Status: 🔄 Phase 1 in progress

---

## 🚀 Launch a New Plan

1. **Create the file** `.github/plans/<NO>_<nom>.plan.md`
2. **Fill in** the global objective, phases, tasks and dependencies
3. **Validate** that tasks are measurable and agents are assigned
4. **Create the folder** `.github/plans/<NO>_reports/`
5. **Launch Phase 1** with the responsible agent
6. **Track** through the phase reports

---

**End of the Action Plans documentation**
