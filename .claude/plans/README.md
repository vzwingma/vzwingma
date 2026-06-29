# 📋 Plans d'Action (Action Plans)

Bienvenue dans le répertoire des Plans d'Action (AP) de ce dépôt transverse. 

Chaque plan orchestre une initiative multi-phases coordonnée entre plusieurs agents (MAINa (⚫), ARCos (🟠 ARC), DEVon (🔵 DEV), QALvin (🟢 QUAL), DOCly (🟣 DOC)) et produit des rapports de suivi documentant l'exécution.

Cet index liste uniquement les plans et leur **statut global**.

> **Règle d'indexation :** ne pas détailler les phases dans ce fichier.  
> Les détails de phases restent dans les fichiers `*.plan.md` et les rapports `*_reports/`.

---

## 📂 Plans Actifs / En Cours

| # | Nom | Statut | Date |
|---|-----|--------|------|
| 004 | [Analyse critique & remédiation infra agents](004_analyse-critique-infra-agents.plan.md) | ⏳ Finalisation (Phases 1-5 ✅, Phase 6 ✅ — validation finale 👤 en attente) | 2026-06-29 |

---

## 📋 Plans Archivés / Complétés

> Fichiers archivés sous `.github/plans/` (source de vérité).

| # | Nom | Statut | Date |
|---|-----|--------|------|
| 003 | [Agent maitre MAINa](../../.github/plans/003_maina-orchestrateur.plan.md) | ✅ Complété | 2026-06-25 |
| 002 | [Rationalisation agents Copilot](../../.github/plans/002_agent-rationalisation.plan.md) | ✅ Complété | 2026-06-25 |
| 001 | [Optimisation tokens Copilot CLI](../../.github/plans/001_token-optimisation.plan.md) | ✅ Complété | 2026-06-23 |

---

## 🚀 Comment Créer un Nouveau Plan

1. **Créer le fichier plan** : `.claude/plans/<NO>_<nom>.plan.md`
   - Utiliser le numéro séquentiel suivant (ex: 004 après 003)
   - Suivre le format défini dans [`.claude/PLANS.md`](../PLANS.md)

2. **Créer le dossier reporting** : `.claude/plans/<NO>_reports/`
   - Contiendra les rapports de phase complétées

3. **Soumettre pour validation** au 👤 Développeur humain ou lead du projet

**Guide complet :** 📖 [`.claude/PLANS.md`](../PLANS.md)

---

## 📚 Documentation Associée

- **Guide complet des Plans d'Action** : [`.claude/PLANS.md`](../PLANS.md)
- **Instructions agent MAINa (⚫)** : [`.claude/agents/Maina.agent.md`](../agents/Maina.agent.md)
- **Instructions agent DEVon (🔵 DEV)** : [`.claude/agents/Devon.agent.md`](../agents/Devon.agent.md)
- **Instructions agent QALvin (🟢 QUAL)** : [`.claude/agents/Qalvin.agent.md`](../agents/Qalvin.agent.md)
- **Instructions agent DOCly (🟣 DOC)** : [`.claude/agents/Docly.agent.md`](../agents/Docly.agent.md)
- **Instructions agent ARCos (🟠 ARC)** : [`.claude/agents/Arcos.agent.md`](../agents/Arcos.agent.md)
- **Instructions globales** : [`.claude/CLAUDE.md`](../CLAUDE.md)

---

## ✅ Checklist pour un Plan Bien Structuré

Avant de créer un nouveau plan, vérifier :

- [ ] Titre explicite et objectif global clair
- [ ] Phases bien séparées (3-6 phases généralement)
- [ ] Chaque phase a contexte, critères de réussite, tâches
- [ ] Chaque tâche est numérotée T<N>.<M> avec :
  - [ ] Verbe d'action + objet
  - [ ] Fichiers précis
  - [ ] Scope explicite
  - [ ] Critères d'acceptation mesurables
  - [ ] Agent assigné
- [ ] Dépendances explicites et diagramme
- [ ] Critères de succès globaux (5-7 items)
- [ ] Plan d'exécution avec triggers

---

## 🤝 Contribution aux Plans

Pour contribuer ou modifier un plan existant :

1. **Ne pas modifier le fichier plan après son lancement** — créer un nouveau plan pour les changements majeurs
2. **Documenter dans le rapport** : Tout changement de scope ou nouvelle tâche découverte
3. **Notifier l'équipe** : Si un bloqueur ou risque est identifié
4. **Mettre à jour ce README** : Refléter le statut actuel des phases

---

**Gestionnaire des Plans :** MAINa (⚫) & 👤 Développeur humain

