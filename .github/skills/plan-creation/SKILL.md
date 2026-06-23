---
name: "plan-creation"
description: "Skill — Procedure for creating + orchestrating an Action Plan (AP). For orchestrator agents (ARCos + future planning agents)."
applyTo: "**"
---

# Skill: Creating an Action Plan (AP)

> This skill describes the standard procedure for creating, validating and launching an Action Plan.
> Reserved for orchestration agents (for example: 🟠 ARCos).
> Full AP format reference: `.github/PLANS.md`

---

## Before creating a plan

1. **Clarify the problem / objective**
   - What is the user or technical need?
   - What are the measurable success criteria?
   - Time, resource or technology constraints?

2. **Structure the approach**
   - Which logical phases are needed?
   - How do the phases depend on each other?
   - Which agent (DEVon, QUALvin, DOCly, ARCos) does what?

---

## Create the plan file

Create the file `.github/plans/<NO>_<nom>.plan.md` containing:

1. **Header**: Title, date, status (`⏳ Planned`), document link
2. **Overall Objective**: 1-2 paragraphs on the problem + expected outcomes
3. **Phases**: 3-6 phases with:
   - Context (current situation, stakes)
   - Success Criteria (3-5 measurable conditions)
   - Tasks (T<N>.<M>) assigned to agents
4. **Summary by Agent**: Who does what, deliverables, estimated duration
5. **Dependencies**: Execution order diagram
6. **Overall Success Criteria**: Final project measures
7. **Execution Plan**: When to start each phase, triggers

**Full format reference**: `.github/PLANS.md` (section "Format du Fichier Plan")

### Structuring tasks

Each task must have:
- **Unique number**: `T<PHASE>.<NUM>` (for example: T1.1, T2.3)
- **Assigned agent**: DEVon, QUALvin, DOCly, ARCos
- **Explicit scope**: Files to create/modify, what to cover
- **Measurable criteria**: "≥90% coverage", "5/5 tests passing", etc.

```markdown
#### T1.1 - <Verbe d'action> <objet>
- **Agent :** [QUALvin | DEVon | DOCly | ARCos]
- **Fichier(s) :** Chemin exact
- **Couvrir / Implémenter :**
  - Fonctionnalité 1
  - Cas d'erreur
- **Acceptation :** Condition mesurable (ex: ≥90% couverture)
```

---

## Create the reporting folder

```
.github/plans/<NO>_reports/
```

The folder will contain one report per phase:
- `PHASE_1_COMPLETION_REPORT.md`
- `PHASE_2_COMPLETION_REPORT.md`
- etc.

---

## Present and validate the plan

Before launching phases:

1. **Submit the plan** to the 👤 human Developer for validation
2. **Key validation points:**
   - Are the phases logically well separated?
   - Are the dependencies correct (no cycles)?
   - Are the tasks clear + measurable?
   - Are the assigned agents appropriate?
3. **Adjust** according to feedback

---

## Launch a phase

When the plan is validated + dependencies are satisfied:

1. **Check dependencies**: All previous phases are ✅
2. **Identify the agent responsible** for the phase
3. **Create an empty report**: `.github/plans/<NO>_reports/PHASE_N_COMPLETION_REPORT.md`
4. **Delegate to the agent** with a structured prompt including:
   - Link to the full plan
   - List of assigned tasks (T<N>.X to T<N>.Y)
   - Link to the report to fill in
   - Success criteria + critical dependencies

**Example launch prompt:**
```
Exécute la Phase N du plan : .github/plans/<NO>_<nom>.plan.md

Tâches assignées : T<N>.1 à T<N>.M
Rapport à remplir : .github/plans/<NO>_reports/PHASE_N_COMPLETION_REPORT.md

Critères de réussite :
- ✅ [Critère 1]
- ✅ [Critère 2]
```

---

## Validate and move forward

After a phase is reported as completed:

1. **Read the report**: `.github/plans/<NO>_reports/PHASE_N_...md`
2. **Check**: All criteria ✅, no blockers, deliverables present
3. **Decide**: Can the next phase start?
4. **Update** the plan status if there is a global change

---

## Mandatory rule — Plan index synchronisation

- `.github/plans/README.md` must contain **only** the list of plans + **global status**.
- For each plan creation or global status change, update `.github/plans/README.md` in the **same change**.

---

## Checklist for a good plan

- [ ] Explicit title + measurable objective
- [ ] 3-6 well-separated phases with clear dependencies
- [ ] Each task has: number, agent, files, scope, acceptance criteria
- [ ] Explicit dependencies (diagram or list)
- [ ] Overall success criteria (5-7 items)
- [ ] Execution plan with start triggers

---

## References

- 📋 Full guide: `.github/PLANS.md`
- 📌 Plans index: `.github/plans/README.md`