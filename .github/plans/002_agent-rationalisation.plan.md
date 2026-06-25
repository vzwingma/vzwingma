# Plan 002 — Rationalisation agents Copilot

**Date :** 2026-06-25  
**Statut :** ✅ Complété  
**Auteur :** 🟠 ARCos

---

## Objectif Global

Reduire la verbosite des fichiers `.github/agents/*.agent.md` en deplacant la vue transverse, les relations inter-agents et une partie des explications de coordination vers un nouveau `.github/README.md`.

Le lot reste limite au sous-arbre `.github/`, sans modification du `README.md` racine ni du miroir `.opencode/agents/`.

---

## Phase 1 : Concevoir la cible documentaire ✅

**Critères atteints :**
- ✅ Scope borne a `.github/agents/*.agent.md`
- ✅ Nouveau point d'entree `.github/README.md` defini
- ✅ Inspiration prise sur `.opencode/README.md`

**Fichiers créés/modifiés :**
- `.github/README.md`
- `.github/plans/002_reports/PHASE_1_COMPLETION_REPORT.md`

---

## Phase 2 : Simplifier les agents Copilot ✅

**Critères atteints :**
- ✅ 4 descriptions frontmatter raccourcies
- ✅ Sections `Relations avec autres agents` retirees des 4 agents
- ✅ Référence commune vers `.github/README.md` ajoutée

**Fichiers modifiés :**
- `.github/agents/Arcos.agent.md`
- `.github/agents/Devon.agent.md`
- `.github/agents/Qalvin.agent.md`
- `.github/agents/Docly.agent.md`
- `.github/plans/002_reports/PHASE_2_COMPLETION_REPORT.md`

---

## Phase 3 : Synchroniser la documentation transverse ✅

**Critères atteints :**
- ✅ `CHANGELOG.md` mis a jour en `v4.2` pour les 4 agents
- ✅ `copilot-instructions.md` synchronise avec nouvelles versions
- ✅ `copilot-instructions.template.md` synchronise avec nouvelles versions
- ✅ `plans/README.md` mis a jour avec le plan 002
- ✅ ADR non requis : externalisation documentaire, pas de changement architectural majeur

**Fichiers modifiés :**
- `.github/CHANGELOG.md`
- `.github/copilot-instructions.md`
- `.github/copilot-instructions.template.md`
- `.github/plans/README.md`
- `.github/plans/002_reports/PHASE_3_COMPLETION_REPORT.md`

---

## Résultats finaux

| Critère | Résultat |
|---|---|
| Nouveau `.github/README.md` | ✅ |
| Sections relations retirees des 4 agents | ✅ |
| Versions agents passees en `v4.2` | ✅ |
| `README.md` racine non modifie | ✅ |
| Scope `.opencode/agents/` preserve | ✅ |
