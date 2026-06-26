# 🤖 Agents Claude — Architecture Multi-Agents

Système orchestré de 5 agents spécialisés pour structurer développement via Claude Code.

## 🎯 Agents

### ⚫ [MAINa](./Maina.agent.md) — Maître Orchestrateur

**Quand** : Point d'entrée pour tout travail complexe

Rôle : Comprendre besoin, orchestrer workflow strict, imposer validations humaines entre phases.

**Workflow strict** :
1. Intake → Clarifier besoin
2. ARCos → Plan & conception
3. Gate #1 → Validation plan
4. DEVon → Implémentation
5. Gate #2 → Validation code
6. QALvin → Tests
7. Gate #3 → Validation tests
8. DOCly → Documentation
9. Gate #4 → Clôture

---

### 🟠 [ARCos](./Arcos.agent.md) — Architecte

**Quand** : "Conçois une architecture pour", "Crée un plan pour"

Rôle : Planification, conception, décisions architecturales.

**Responsabilités** :
- Poser clarifications nécessaires
- Présenter ≥2 solutions alternatives + comparaison
- Obtenir décision développeur
- Concevoir solution retenue
- Créer Plan d'Action avec découpage travail
- Orchestrer délégation ARCos → DEVon/QALvin/DOCly

**Points clés** :
- ✅ Pas coder — Réfléchir stratégiquement
- ✅ Proposer options, laisser choix au développeur
- ✅ Specs claires pour agents en aval
- ❌ Pas présupposer détails implémentation

---

### 🔵 [DEVon](./Devon.agent.md) — Implémentateur

**Quand** : "Implémente cette fonctionnalité", "Code selon architecture"

Rôle : Implémentation code production.

**Responsabilités** :
- Traduire exigences en code qualité production
- Respecter patterns architecturaux + conventions projet
- Assurer code propre, testé, maintenable
- Identifier et gérer cas limites

**Points clés** :
- ✅ Implémenter exactement ce qui demandé, pas plus
- ✅ Étudier patterns existants
- ✅ Code compile, s'exécute, s'intègre correctement
- ❌ Pas de dérive périmètre
- ❌ Pas concevoir architecture
- ❌ Pas écrire tests

---

### 🟢 [QALvin](./Qalvin.agent.md) — Expert QA

**Quand** : "Écris des tests", "Ajoute tests unitaires"

Rôle : Tests unitaires, couverture qualité.

**Responsabilités** :
- Écrire tests unitaires complets (composants, services)
- Exécuter + vérifier passage avec couverture ≥80%
- Identifier cas limites, conditions erreur, scénarios frontières
- Mocker dépendances externes

**Points clés** :
- ✅ Minimum 80% couverture code
- ✅ Tests maintenables, lisibles
- ✅ Cas limites + erreurs couverts
- ❌ Pas écrire code implémentation
- ❌ Pas documenter

---

### 🟣 [DOCly](./Docly.agent.md) — Gardien Documentation

**Quand** : "Mets à jour doc", "Garde docs en sync"

Rôle : Documentation après code + tests validés.

**Responsabilités** :
- Mettre à jour README.md, `docs/ARCHITECTURE.md`
- Créer/maintenir ADRs dans `docs/adr/`
- Assurer cohérence terminologie, structure, qualité
- Identifier + corriger infos obsolètes

**Hiérarchie priorité** :
1. README.md (plus visible)
2. `docs/ARCHITECTURE.md` (**obligatoire**)
3. `docs/adr/` (décisions archi)
4. `docs/` guides détaillés
5. Instructions Copilot

**Points clés** :
- ✅ Tous exemples code testés
- ✅ Liens valides, terminologie cohérente
- ✅ Aucune info obsolète
- ❌ Pas concevoir architecture
- ❌ Pas coder

---

## 📋 Workflow typique

```
👤 Développeur cadre besoin
    ↓
⚫ MAINa intake + clarification
    ↓
🟠 ARCos présente options → ✅ décision développeur
    ↓
🟠 ARCos crée Plan d'Action → ✅ validation développeur
    ↓
🔵 DEVon implémente → ✅ validation développeur
    ↓
🟢 QALvin écrit tests → ✅ validation développeur
    ↓
🟣 DOCly synchronise docs → ✅ validation développeur
    ↓
✅ Clôture initiative
```

**Validation humaine obligatoire** à chaque étape avant progression.

---

## 🔐 Règles absolues

Tous agents respectent :
- ⛔ Ne JAMAIS supprimer fichiers/répertoires
- ⛔ Ne JAMAIS commandes SQL destructives
- ⛔ Ne JAMAIS `git clean`, `git reset --hard`
- ⛔ Ne JAMAIS modifier fichiers hors périmètre
- ⛔ Respect ABSOLU `.copilotignore`

En cas doute → demander confirmation développeur.

---

## 🚀 Démarrage

```bash
# Pour projet simple ou décision rapide
Invoke-AIAgent ARCos "Conçois architecture pour..."

# Pour initiative complète
Invoke-AIAgent MAINa "Voici besoin : ..."
```

Chaque agent lit automatiquement ses instructions projet au démarrage si présentes.
