# Plan 001 — Copilot CLI Token Optimisation

**Date:** 2026-06-23  
**Status:** ✅ Completed  
**Author:** 🟠 ARCos

---

## Overall Objective

Reduce token consumption in Copilot CLI sessions by applying 4 fixes identified by `/chronicle cost-tips` on the repository configuration:

- **Tip 1**: `/compact` guidance between SDLC/AP phases
- **Tip 2**: Eliminate double-loading of caveman mode
- **Tip 4**: Externalise agent changelogs (-5.2KB/multi-agent session)
- **Tip 5**: New `compact-context` skill with preCompact instructions

---

## Phase 1: Fix applyTo + caveman anti-duplication ✅

**Criteria met:**
- ✅ 6 skill files have `applyTo: "**"` (was 0/6 before)
- ✅ `caveman-default/SKILL.md` reinforced with explicit anti-duplication note

**Modified files:**
- `.github/skills/caveman-default/SKILL.md`
- `.github/skills/plan-phase-execution/SKILL.md`
- `.github/skills/plan-creation/SKILL.md`
- `.github/skills/copilotignore/SKILL.md`
- `.github/skills/adr-writing/SKILL.md`
- `.github/skills/fleet-guide/SKILL.md`

---

## Phase 2: Externalise agent changelogs ✅

**Criteria met:**
- ✅ `.github/agents/CHANGELOG.md` created (complete history for 4 agents)
- ✅ Inline changelog blocks replaced by 1-line reference in 4 agents
- ✅ All agents upgraded to v4.1
- ✅ Total reduction: 52.6KB → 47.4KB (−5.2KB)

**Modified/created files:**
- `.github/agents/CHANGELOG.md` (new)
- `.github/agents/Arcos.agent.md` (18.5KB → 16.8KB)
- `.github/agents/Devon.agent.md` (11.5KB → 10.4KB)
- `.github/agents/Qalvin.agent.md` (12.4KB → 11.1KB)
- `.github/agents/Docly.agent.md` (10.2KB → 9.1KB)

---

## Phase 3: Compact guidance in plan workflows ✅

**Criteria met:**
- ✅ `plan-phase-execution/SKILL.md` — "Compact before next phase" section added
- ✅ `plan-creation/SKILL.md` — post-validation compact note added
- ✅ `.github/skills/compact-context/SKILL.md` created with `applyTo: "**"`

**Modified/created files:**
- `.github/skills/plan-phase-execution/SKILL.md`
- `.github/skills/plan-creation/SKILL.md`
- `.github/skills/compact-context/SKILL.md` (new)

---

## Final Results

| Criterion | Result |
|-----------|--------|
| Skills with `applyTo` | 7/7 ✅ |
| ARCos size | 16.8KB (< 18KB target) ✅ |
| DEVon size | 10.4KB ✅ |
| `plan-phase-execution` contains "compact" | ✅ |
| `CHANGELOG.md` exists | ✅ |
| `compact-context/SKILL.md` exists | ✅ |
