# Agents — Version History

> This file centralises the change history for all agents.
> Each agent references this file instead of an inline `> **Changes...** ` block.

---

## 🟠 ARCos

- **v2.0 → v2.1**: Wiki → `/docs` migration. Added ADR responsibility in `docs/adr/`.
- **v2.1 → v2.2**: Added mandatory reading of `docs/ARCHITECTURE.md` at start-up.
- **v2.2 → v2.3**: Simplified plan index (without phases) + mandatory update of `.github/plans/README.md` when plan status changes.
- **v2.3 → v2.4**: Added mandatory step to present ≥2 solutions with analysis of advantages/disadvantages/risks/impacts + recommendation, before human decision.
- **v2.4 → v2.5**: Extracted Action Plan and /fleet procedures into shared skills (`.github/skills/`). AP and /fleet sections reduced to ARCos-specific details (orchestration, plan creation).
- **v2.5 → v2.6**: Aligned with the new real skill tree structure (`.github/skills/<name>/SKILL.md`).
- **v2.6 → v2.7**: Added `adr-writing` skill (`.github/skills/adr-writing/SKILL.md`). ARCos prepares ADR content, DOCly writes the file. Explicit skill reference after human agreement on the solution.
- **v2.7 → v2.8**: Added destructive operation prohibitions.
- **v2.8 → v2.9**: Added absolute rule to respect `.copilotignore`.
- **v2.9 → v2.10**: Migrated to Sonnet 4.6 for improved planning/architecture capabilities.
- **v2.10 → v3.0**: Added global instruction for activating/using the `caveman` skill and compressing guidance.
- **v3.0 → v3.1**: Removed global caveman instruction (moved to the `caveman-default` skill, `applyTo: "**"`). Avoids multiple loads per session.
- **v3.1 → v4.0**: Sync from OpenCode v4.0. Body updated. Copilot frontmatter preserved (model, tools). `.github/` paths preserved.
- **v4.0 → v4.1**: Changelog externalised into this file. Agent size reduced ~2KB.

---

## 🔵 DEVon

- **v1.9 → v2.0**: Added instruction for parallelisation with /fleet.
- **v2.0 → v2.1**: Added mandatory synchronisation rule for `.github/plans/README.md` (plan index + overall status only).
- **v2.1 → v2.2**: Extracted Action Plan and /fleet procedures into shared skills (`.github/skills/`). AP section reduced to DEVon-specific details.
- **v2.2 → v2.3**: Aligned with the new real skill tree structure (`.github/skills/<name>/SKILL.md`).
- **v2.3 → v2.4**: Added destructive operation prohibitions.
- **v2.4 → v2.5**: Added the absolute rule to respect `.copilotignore`.
- **v2.5 → v2.6**: Confirmed the Claude Sonnet 4.6 model for optimal development.
- **v2.6 → v3.0**: Added a global instruction for activating/using the `caveman` skill and compressing guidance.
- **v3.0 → v3.1**: Removed the global caveman instruction (moved to the `caveman-default` skill, `applyTo: "**"`). Avoids multiple loads per session.
- **v3.1 → v4.0**: Sync from OpenCode v4.0. Body updated. Copilot frontmatter preserved (model, tools). `.github/` paths preserved.
- **v4.0 → v4.1**: Changelog externalised into this file. Agent size reduced ~2KB.

---

## 🟣 DOCly

- **v2.0 → v2.1**: Wiki → `/docs` migration. Added mandatory `docs/ARCHITECTURE.md` + `docs/adr/`.
- **v2.1 → v2.2**: Added maintenance rule for `.github/plans/README.md` (plan index + overall status only).
- **v2.2 → v2.3**: Extracted Action Plan and /fleet procedures into shared skills (`.github/skills/`). AP section reduced to DOCly-specific details.
- **v2.3 → v2.4**: Aligned with the new real skill tree structure (`.github/skills/<name>/SKILL.md`).
- **v2.4 → v2.5**: Added destructive operation prohibitions.
- **v2.5 → v2.6**: Added the absolute rule to respect `.copilotignore`.
- **v2.6 → v2.7**: Migrated to GPT-5 mini to improve documentation quality.
- **v2.7 → v3.0**: Added a global instruction for activating/using the `caveman` skill and compressing guidance.
- **v3.0 → v3.1**: Removed the global caveman instruction (moved to the `caveman-default` skill, `applyTo: "**"`). Avoids multiple loads per session.
- **v3.1 → v4.0**: Sync from OpenCode v4.0. Body updated. Copilot frontmatter preserved (model, tools). `.github/` paths preserved.
- **v4.0 → v4.1**: Changelog externalised into this file. Agent size reduced ~2KB.

---

## 🟢 QUALvin

- **v1.9 → v2.0**: Added instruction for parallelisation with /fleet.
- **v2.1 → v2.2**: Moved project-specific QA validations to `.github/instructions/qa.instructions.md`.
- **v2.2 → v2.3**: Added mandatory synchronisation of `.github/plans/README.md` when plan status changes.
- **v2.3 → v2.4**: Extracted Action Plan and /fleet procedures into shared skills (`.github/skills/`). AP section reduced to QUALvin-specific details.
- **v2.4 → v2.5**: Aligned with the new real skill tree structure (`.github/skills/<name>/SKILL.md`).
- **v2.5 → v2.6**: Added destructive operation prohibitions.
- **v2.6 → v2.7**: Added the absolute rule to respect `.copilotignore`.
- **v2.7 → v2.8**: Migrated to GPT-5.3-Codex for fast, efficient test execution.
- **v2.8 → v3.0**: Added a global instruction for activating/using the `caveman` skill and compressing guidance.
- **v3.0 → v3.1**: Removed the global caveman instruction (moved to the `caveman-default` skill, `applyTo: "**"`). Avoids multiple loads per session.
- **v3.1 → v4.0**: Sync from OpenCode v4.0. Body updated. Copilot frontmatter preserved (model, tools). `.github/` paths preserved.
- **v4.0 → v4.1**: Changelog externalised into this file. Agent size reduced ~2KB.
