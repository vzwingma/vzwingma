# 📋 Plans d'Action (AP) — Guide Centralisé

**Document** : `.claude/PLANS.md`  
**Objectif** : Guide créer, exécuter, tracker plans d'action multi-phases.

---

## 🎯 Qu'est-ce qu'un Plan d'Action (AP) ?

Plan d'Action (AP) = document structuré :
- Décrit **objectif global** (modernisation, feature, refactoring)
- Décompose en **phases logiques** + **tâches détaillées**
- Assigne tâches agents spécifiques (MAINa/ARCos/DEVon/QALvin/DOCly)
- Définit **critères réussite** + **dépendances phases**
- Génère **rapports phase** documenting exécution

**Cas d'usage** :
- Moderniser infrastructure + tests
- Feature complexe cross-équipes
- Refactoring domaine métier
- Mises à jour dépendantes coordonnées

---

## 📂 Structure Répertoires

```
.claude/
├── PLANS.md                              # Ce document
├── plans/
│   ├── 001_feature_1.plan.md            # Fichier plan
│   ├── 001_reports/                     # Dossier reporting
│   │   ├── PHASE_1_COMPLETION_REPORT.md
│   │   ├── PHASE_2_COMPLETION_REPORT.md
│   │   └── PHASE_N_FINAL_REVIEW.md
│   ├── 002_nouvelle_feature.plan.md
│   ├── 002_reports/
│   │   └── PHASE_1_...
│   └── README.md                        # Index plans actifs/archivés
```

**Conventions nommage** :
- Plan fichier : `.claude/plans/<NO>_<nom_descriptif>.plan.md`
  - `<NO>` : Numéro séquentiel (001, 002...)
  - `<nom_descriptif>` : Slug lisible FR/EN
  - Exemple : `001_modernisation_complete.plan.md`
- Dossier reporting : `.claude/plans/<NO>_reports/`
  - Rapports phase (`PHASE_1_...`, `PHASE_2_...`)
  - Un rapport par phase complétée

---

## 📝 Format Fichier Plan (`.plan.md`)

### En-tête (Métadonnées)

```markdown
# Plan d'Action : <Titre Explicite>

**Document** : `.claude/plans/<NO>_<nom>.plan.md`  
**Création** : YYYY-MM-DD  
**Statut** : ✅ Complété | 🔄 En cours | ⏳ Planifié | ❌ Bloqué  
**Priorité** : HIGH | MEDIUM | LOW
```

### Objectif Global

```markdown
## 🎯 Objectif Global

[Problème/besoin 1-2 phrases]
[Domaines amélioration / outcomes attendus]

Exemple :
"Moderniser application en améliorant couverture test, 
dépendances, architecture, performance.
Objectifs : couverture ≥80%, 0 dépréciées, docs exhaustive."
```

### Phases

Chaque phase contient :

#### A. Contexte
```markdown
### Contexte
- [Situation actuelle / problèmes identifiés]
- [Dépendances avec autres phases]
- [Ressources/outils disponibles]
```

#### B. Critères Réussite
```markdown
### Critères Réussite
✅ [Condition testable 1]  
✅ [Condition testable 2]
```

#### C. Tâches Détaillées
```markdown
### Tâches

**T<PHASE>.<NUM> (Agent assigné)** — [Description courte]
- Input : [What given]
- Output : [What produced]
- Critères : [How verify completion]

Exemple:
**T1.1 (ARCos)** — Analyser architecture actuelle
- Input : Code existant
- Output : Rapport analyse architecture
- Critères : Couches identifiées, dépendances mappées
```

#### D. Dépendances
```markdown
### Dépendances
- Phase 1 → Phase 2 (Code implémentation avant tests)
- Phase 2 ↔ Phase 3 (Parallélisable)
```

---

## 🚀 Procédure Création Plan (ARCos)

### Étape 1 : Comprendre Besoin (AVT développeur)

- Clarifier objectif global
- Identifier domaines à améliorer
- Définir critères acceptation
- Identifier contraintes

### Étape 2 : Analyser Situation Actuelle (ARCos)

- Auditer code/infrastructure
- Identifier pain points
- Cartographier dépendances
- Documenter blocages

### Étape 3 : Proposer Solutions (ARCos)

- Générer ≥2 approches
- Tableau comparatif avantages/inconvénients/risques/impacts/effort
- Recommandation motivée
- **Attendre décision développeur**

### Étape 4 : Concevoir Solution (ARCos)

- Affiner conception solution choisie
- Identifier phases logiques
- Décomposer tâches
- Mapper agents responsables

### Étape 5 : Documenter Plan (ARCos)

- Remplir format `.plan.md`
- Définir critères réussite
- Documenter tâches numérotées
- Identifier risques/mitigations

### Étape 6 : Valider Plan (Développeur)

- Revue plan complet
- Validation tâches clarté
- Validation dépendances
- Approbation avant exécution

---

## ▶️ Procédure Exécution Phase

### Avant Phase (MAINa)

1. Vérifier prérequis phase (phases amont complétées)
2. Invoquer agent responsable phase
3. Passer tâches assignées agent
4. Définir critères succès
5. Pointer rapports à remplir

### Pendant Phase (Agent assigné)

1. Lire contexte + critères phase
2. Exécuter tâches T<N>.X assignées
3. Documenter progrès
4. Signaler blocages

### Après Phase (Agent + Développeur)

1. Agent remplit rapport phase `.claude/plans/<NO>_reports/PHASE_N_COMPLETION_REPORT.md`
2. Rapport = résumé livrables, métriques, blocages, approvals
3. Développeur revue + valide
4. MAINa orchestre phase suivante (ou signale blocage)

---

## 📄 Format Rapport Phase

```markdown
# PHASE N Completion Report

**Plan** : `.claude/plans/<NO>_<nom>.plan.md`  
**Phase** : N — [Titre phase]  
**Agent** : [🟠 ARCos | 🔵 DEVon | 🟢 QALvin | 🟣 DOCly]  
**Date Complétion** : YYYY-MM-DD  
**Statut** : ✅ Complété | ⚠️ Complété avec risques | ❌ Bloqué

---

## Livrables

### Tâches Complétées
- **T<N>.1** [ARCos] ✅ [Décription] → [Fichier/Résultat]
- **T<N>.2** [DEVon] ✅ [Décription] → [Fichier/Résultat]

### Métriques
- Couverture test : X%
- Dépendances mises à jour : N
- Docs mises à jour : Y fichiers

### Points Bloquants
[Si aucun, noter "Aucun"; sinon lister + actions correctives]

### Notes + Recommandations
[Observations, amélioration possibles, impacts aval]
```

---

## 🔄 Parallélisation (`/fleet`)

Phases peuvent paralleliser quand indépendantes.

**Exemple** :
```
Phase 2 (DEVon implementation) + Phase 3 (QALvin tests)
→ Après validation Phase 1, MAINa peut lancer DEVon + QALvin parallelisme

A faire : orchestrer via skill fleet-guide
```

---

## 📊 Tracking Index

Fichier `.claude/plans/README.md` = index plans :

```markdown
# Plans d'Action Index

| # | Titre | Statut | Phases | Créé | Modifié |
|---|-------|--------|--------|------|---------|
| 001 | Feature X | ✅ Complété | 5 | 2026-01-15 | 2026-02-28 |
| 002 | Refactor Y | 🔄 Phase 2 | 4 | 2026-03-01 | 2026-06-15 |
| 003 | Modernisation Z | ⏳ Planifié | 6 | 2026-06-01 | 2026-06-01 |
```

---

## 🎓 Exemple Minimal Plan

```markdown
# Plan d'Action : Feature Auth

**Document** : `.claude/plans/001_feature_auth.plan.md`  
**Création** : 2026-06-25  
**Statut** : ⏳ Planifié  
**Priorité** : HIGH

## 🎯 Objectif Global

Implémenter système authentification complet avec tests couvrant.
Objectifs : OAuth2 flow, couverture ≥80%, zero dépréciées.

---

## Phase 1 : Architecture

### Contexte
- App utilise session tokens, besoin migration OAuth2
- Dépend de : DB users setup

### Critères Réussite
✅ Architecture OAuth2 documentée
✅ Intégration services tiers mapped

### Tâches
**T1.1 (ARCos)** — Concevoir architecture OAuth2
- Input : Exigences auth, contraintes légales
- Output : Diagramme architecture + spec
- Critères : Schéma clair, flux identifiés, risques mappés

---

## Phase 2 : Implémentation

**T2.1 (DEVon)** — Coder endpoints auth
**T2.2 (DEVon)** — Intégrer DB users

---

## Phase 3 : Tests

**T3.1 (QALvin)** — Tests endpoints auth
**T3.2 (QALvin)** — Tests erreurs + limites

---

## Phase 4 : Docs

**T4.1 (DOCly)** — Documenter flow auth
**T4.2 (DOCly)** — Ajouter exemples code
```

---

## 🔐 Règles Plans

- **Validation humaine obligatoire** : Plan complet avant exécution
- **Rapports obligatoires** : Chaque phase génère rapport
- **Traçabilité** : Tous tâches numérotées, agents assignés
- **Pas dérives scope** : Tâches périmètre strict

---

**Dernière mise à jour** : 2026-06-25
