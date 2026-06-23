# Rapport Phase 1 — Cherry-pick feat/ai → main

**Date :** 2026-06-18
**Agent :** DEVon (exécuté via OpenCode)
**Statut :** ✅ Complété

---

## Fichiers créés

### `.github/agents/` (4 fichiers)
- `Arcos.agent.md` — frontmatter Copilot valide (`description`, `name`, `model`, `tools`)
- `Devon.agent.md` — frontmatter Copilot valide
- `Docly.agent.md` — frontmatter Copilot valide
- `Qalvin.agent.md` — frontmatter Copilot valide

### `.github/skills/` (6 SKILL.md)
- `adr-writing/SKILL.md`
- `caveman-default/SKILL.md`
- `copilotignore/SKILL.md`
- `fleet-guide/SKILL.md`
- `plan-creation/SKILL.md`
- `plan-phase-execution/SKILL.md`

### `.github/instructions/` (4 templates)
- `architect.instructions.template.md` — `applyTo: "**"` ✅
- `dev.instructions.template.md` — `applyTo: "**"` ✅
- `doc.instructions.template.md` — `applyTo: "**"` ✅
- `qa.instructions.template.md` — `applyTo: "**"` ✅

### `.github/prompts/` (2 prompts)
- `init-copilot-instructions.prompt.md`
- `update-copilot-instructions.prompt.md`

### `.github/` (guides)
- `PLANS.md`
- `plans/README.md`

---

## Vérifications

| Critère | Résultat |
|---|---|
| 4 agents présents dans `.github/agents/` | ✅ |
| Frontmatter Copilot valide (`description`, `name`, `model`, `tools`) | ✅ |
| Pas de `mode:` ni `permission:` dans agents | ✅ |
| 6 skills présents dans `.github/skills/` | ✅ |
| 4 templates instructions présents | ✅ |
| `applyTo: "**"` dans instructions | ✅ |
| 2 prompts présents | ✅ |
| `.github/PLANS.md` présent | ✅ |
| `.github/plans/README.md` présent | ✅ |
| Aucun fichier `.opencode/` modifié | ✅ |

---

## Anomalies détectées

- **Versions agents** : Les agents Copilot récupérés sont en **v3.1** (`.opencode/agents/` = v4.0). À corriger en **Phase 2**.
- **Skills Copilot** : Frontmatter contient `name:` uniquement (pas `applyTo: "**"`). Comportement normal pour Copilot — les skills sont invoqués via `@workspace`, pas via `applyTo`. Pas de correction nécessaire.
- **Fichiers `Mammouth/`** : Récupérés accidentellement depuis feat/ai (hors périmètre), retirés immédiatement.

---

## Prochaine étape

**Phase 2** — Aligner les agents Copilot sur v4.0 (corps depuis `.opencode/agents/`, chemins + frontmatter adaptés).
