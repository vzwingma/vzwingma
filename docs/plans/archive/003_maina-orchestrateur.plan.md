# Plan 003 — Agent maitre MAINa

**Date :** 2026-06-25  
**Statut :** ✅ Complété  
**Auteur :** 🟠 ARCos + ⚫ MAINa

---

## Objectif Global

Ajouter un agent **MAINa** comme point d'entree principal pour fiabiliser orchestration du workflow multi-agents.

Le flux cible impose sequence stricte `ARCos -> DEVon -> QALvin -> DOCly` avec validations humaines obligatoires entre phases.

---

## Phase 1 : Specifier contrat orchestration MAINa ✅

**Critères atteints :**
- ✅ MAINa defini comme maitre orchestrateur
- ✅ Commandes aide definies (`/maina-help`, `@MAINa /maina-help`)
- ✅ Workflow strict et gates humains explicites

**Fichiers créés/modifiés :**
- `.github/agents/Maina.agent.md`

---

## Phase 2 : Integrer MAINa dans documentation transverse ✅

**Critères atteints :**
- ✅ Docs centrales passent de 4 a 5 agents
- ✅ Workflow officiel commence par MAINa
- ✅ Exemples usage MAINa ajoutes dans guides setup

**Fichiers modifiés :**
- `.github/README.md`
- `.github/copilot-instructions.md`
- `.github/copilot-instructions.template.md`
- `QUICK_START.md`
- `SETUP_CHECKLIST.md`
- `.github/prompts/init-copilot-instructions.prompt.md`
- `.github/prompts/update-copilot-instructions.prompt.md`
- `docs/ARCHITECTURE.md`

---

## Phase 3 : Gouvernance (Plan + ADR + Index + Changelog) ✅

**Critères atteints :**
- ✅ Plan 003 cree et reference dans index plans
- ✅ ADR 001 cree pour decision architecturale
- ✅ Changelog agents mis a jour avec MAINa

**Fichiers modifiés :**
- `.github/plans/README.md`
- `docs/adr/001-maina-orchestrateur.md`
- `.github/CHANGELOG.md`

## Phase 4 : Skill aide MAINa (renommage `/help` → `/maina-help`) 🔄

**Critères atteints :**
- ✅ Skill `maina-help` créée (`.github/skills/maina-help/SKILL.md`)
- ✅ Commande renommée `/help` → `/maina-help` pour éviter collision
- ✅ MAINa v1.0 → v1.1 : support `/maina-help` et `@MAINa /maina-help`
- ✅ Toute documentation mise à jour

**Fichiers modifiés :**
- `.github/skills/maina-help/SKILL.md` (création)
- `.github/agents/Maina.agent.md` (v1.0 → v1.1)
- `.github/copilot-instructions.md`
- `.github/copilot-instructions.template.md`
- `.github/README.md`
- `.github/CHANGELOG.md`
- `.github/plans/003_maina-orchestrateur.plan.md` (cette phase)

---



| Critère | Résultat |
|---|---|
| MAINa disponible comme agent principal | ✅ |
| Workflow strict documenté partout | ✅ |
| Commandes aide MAINa documentées | ✅ |
| Plan + ADR + index synchronisés | ✅ |
