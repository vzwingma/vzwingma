---
name: "plan-phase-execution"
description: "Skill — Procedure for executing an Action Plan (AP) phase. Automatically applied to all agents."
---

# Skill: Executing an Action Plan (AP) Phase

> This skill describes the **standard procedure** for an agent to execute an Action Plan phase.
> Each agent knows its own identifier and delegation targets (see instructions).
> Full AP format reference: `.github/PLANS.md`

---

## Before starting

1. **Read the full plan**: `.github/plans/<NO>_<nom>.plan.md`
2. **Identify your tasks**: Look for your agent identifier in the phase (for example: `🔵 DEVon`, `🟢 QUALvin`, etc.)
3. **List the assigned tasks** (T<N>.X, T<N>.Y, etc.) and their sequence
4. **Understand dependencies**: Which phase(s) must be completed before yours
5. **Identify the report to fill in**: `.github/plans/<NO>_reports/PHASE_N_COMPLETION_REPORT.md`

---

## During execution

For each task T<N>.<M>:

1. **Read the task in detail** in the plan
   - Which file(s) to touch / test / document
   - What to cover / implement
   - Measurable acceptance criteria

2. **Execute the task** according to your role

3. **Document it in the phase report** in real time

**Documentation format per task:**
```markdown
### T<N>.<M> - [Titre de la tâche]

**Statut :** ✅ DONE (ou 🔄 IN_PROGRESS, ❌ BLOCKED)

**Fichiers Créés / Modifiés :**
- `path/to/file1.ts` — [Brève description]
- `path/to/file2.tsx` — [Brève description]

**Résultats :**
- Critère 1 : ✅ Atteint (ex: "Coverage 92% ≥90%")
- Critère 2 : ✅ Atteint

**Notes :**
[Décisions, problèmes rencontrés, hypothèses]
```

---

## After each task

- ✅ Update the status in the report (🔄 → ✅ or ❌)
- ✅ Check that the next task can start (internal dependencies)

---

## At the end of the phase

Fill in the **Phase Summary** in the report:

```markdown
## 📊 Synthèse de Phase

**Tâches Complétées :** X/Y ✅
**Critères de Réussite Atteints :**
- ✅ Critère 1
- ✅ Critère 2

**Bloqueurs :** Aucun ❌
**Prochaine Phase :** Phase X peut démarrer (toutes les dépendances ✅)
```

Then **notify the next agent** according to your delegation instructions.

---

## Mandatory rule — Plan index synchronisation

- `.github/plans/README.md` is the **plans + global status only** index (never phase details).
- If your updates cause a change to the plan's **global status**, update `.github/plans/README.md` in the **same change**.

---

## References

- 📋 Full guide: `.github/PLANS.md`
- 📋 Current plan: `.github/plans/<NO>_<nom>.plan.md`
- 📊 Existing reports: `.github/plans/<NO>_reports/`
- 📌 Plans index (summary): `.github/plans/README.md`