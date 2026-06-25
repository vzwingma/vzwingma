# Plan 001 — Optimisation tokens Copilot CLI

**Date :** 2026-06-23  
**Statut :** ✅ Complété  
**Auteur :** 🟠 ARCos

---

## Objectif Global

Réduire la consommation de tokens dans les sessions Copilot CLI en appliquant 4 correctifs identifiés par `/chronicle cost-tips` sur la configuration :

- **Tip 1** : Guidance `/compact` entre phases SDLC/AP
- **Tip 2** : Élimination du double-chargement du mode caveman
- **Tip 4** : Externalisation des changelogs des agents (-5.2KB/session multi-agent)
- **Tip 5** : Nouveau skill `compact-context` avec instructions preCompact

---

## Phase 1 : Fix applyTo + caveman anti-duplication ✅

**Critères atteints :**
- ✅ 6 skill files ont `applyTo: "**"` (étaient 0/6 avant)
- ✅ `caveman-default/SKILL.md` renforcé avec note anti-duplication explicite

**Fichiers modifiés :**
- `.github/skills/caveman-default/SKILL.md`
- `.github/skills/plan-phase-execution/SKILL.md`
- `.github/skills/plan-creation/SKILL.md`
- `.github/skills/copilotignore/SKILL.md`
- `.github/skills/adr-writing/SKILL.md`
- `.github/skills/fleet-guide/SKILL.md`

---

## Phase 2 : Externalisation changelogs agents ✅

**Critères atteints :**
- ✅ `.github/CHANGELOG.md` créé (historique complet 4 agents)
- ✅ Blocs changelog inline remplacés par référence 1 ligne dans 4 agents
- ✅ Tous les agents passés en v4.1
- ✅ Réduction totale : 52.6KB → 47.4KB (−5.2KB)

**Fichiers modifiés/créés :**
- `.github/CHANGELOG.md` (nouveau)
- `.github/agents/Arcos.agent.md` (18.5KB → 16.8KB)
- `.github/agents/Devon.agent.md` (11.5KB → 10.4KB)
- `.github/agents/Qalvin.agent.md` (12.4KB → 11.1KB)
- `.github/agents/Docly.agent.md` (10.2KB → 9.1KB)

---

## Phase 3 : Compact guidance dans workflow plans ✅

**Critères atteints :**
- ✅ `plan-phase-execution/SKILL.md` — section "Compact avant phase suivante" ajoutée
- ✅ `plan-creation/SKILL.md` — note compact post-validation ajoutée
- ✅ `.github/skills/compact-context/SKILL.md` créé avec `applyTo: "**"`

**Fichiers modifiés/créés :**
- `.github/skills/plan-phase-execution/SKILL.md`
- `.github/skills/plan-creation/SKILL.md`
- `.github/skills/compact-context/SKILL.md` (nouveau)

---

## Résultats finaux

| Critère | Résultat |
|---------|---------|
| Skills avec `applyTo` | 7/7 ✅ |
| ARCos taille | 16.8KB (< 18KB cible) ✅ |
| DEVon taille | 10.4KB ✅ |
| `plan-phase-execution` contient "compact" | ✅ |
| `.github/CHANGELOG.md` existe | ✅ |
| `compact-context/SKILL.md` existe | ✅ |
