# 📋 Plans d'Action (Action Plans)

Bienvenue dans le répertoire des Plans d'Action (AP) du projet . 

Chaque plan orchestre une initiative multi-phases coordonnée entre plusieurs agents (developer, test-qa, solution-architect, doc-manager) et produit des rapports de suivi documentant l'exécution.

---

## 📂 Plans Actifs / En Cours

_(Aucun plan en cours pour l'instant)_

---

## 📋 Plans Archivés / Complétés

_(Aucun plan archivé pour l'instant)_

---

## 🚀 Comment Créer un Nouveau Plan

1. **Créer le fichier plan** : `.github/plans/<NO>_<nom>.plan.md`
   - Utiliser le numéro séquentiel suivant (ex: 002 après 001)
   - Suivre le format défini dans [`.github/PLANS.md`](../PLANS.md)

2. **Créer le dossier reporting** : `.github/plans/<NO>_reports/`
   - Contiendra les rapports de phase complétées

3. **Soumettre pour validation** au développeur humain ou lead du projet

**Guide complet :** 📖 [`.github/PLANS.md`](../PLANS.md)

---

## 📚 Documentation Associée

- **Guide complet des Plans d'Action** : [`.github/PLANS.md`](../PLANS.md)
- **Instructions agent developer** : [`.github/agents/developer.agent.md`](../agents/developer.agent.md)
- **Instructions agent test-qa** : [`.github/agents/test-qa.agent.md`](../agents/test-qa.agent.md)
- **Instructions agent doc-manager** : [`.github/agents/doc-manager.agent.md`](../agents/doc-manager.agent.md)
- **Instructions agent solution-architect** : [`.github/agents/solution-architect.agent.md`](../agents/solution-architect.agent.md)
- **Instructions Copilot globales** : [`.github/copilot-instructions.md`](../copilot-instructions.md)

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

**Dernière mise à jour :** 2026-04-24  
**Gestionnaire des Plans :** solution-architect & Développeur humain
