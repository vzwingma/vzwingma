# 📋 Action Plans (AP)

Welcome to the project's Action Plans (AP) directory.

Each plan orchestrates a multi-phase initiative co-ordinated between several agents (Devon (🔵 DEV), Qalvin (🟢 QUAL), ARCos (🟠 ARC), Docly (🟣 DOC)) and produces tracking reports documenting execution.

This index lists only the plans and their **overall status**.

> **Indexing rule:** do not detail the phases in this file.  
> Phase details stay in the `*.plan.md` files and the `*_reports/` reports.

---

## 📂 Active / In-Progress Plans

_(No plans in progress for now)_

---

## 📋 Archived / Completed Plans

| # | Name | Status | Date |
|---|------|--------|------|
| 001 | [Copilot CLI token optimisation](001_token-optimisation.plan.md) | ✅ Completed | 2026-06-23 |

---

## 🚀 How to Create a New Plan

1. **Create the plan file**: `.github/plans/<NO>_<name>.plan.md`
   - Use the next sequential number (for example: 002 after 001)
   - Follow the format defined in [`.github/PLANS.md`](../PLANS.md)

2. **Create the reporting folder**: `.github/plans/<NO>_reports/`
   - It will contain the completed phase reports

3. **Submit for validation** to the 👤 Human developer or project lead

**Complete guide:** 📖 [`.github/PLANS.md`](../PLANS.md)

---

## 📚 Related Documentation

- **Complete Action Plans guide**: [`.github/PLANS.md`](../PLANS.md)
- **Devon (🔵 DEV) agent instructions**: [`.github/agents/Devon.agent.md`](../agents/Devon.agent.md)
- **Qalvin (🟢 QUAL) agent instructions**: [`.github/agents/Qalvin.agent.md`](../agents/Qalvin.agent.md)
- **Docly (🟣 DOC) agent instructions**: [`.github/agents/Docly.agent.md`](../agents/Docly.agent.md)
- **ARCos (🟠 ARC) agent instructions**: [`.github/agents/Arcos.agent.md`](../agents/Arcos.agent.md)
- **Global Copilot instructions**: [`.github/copilot-instructions.md`](../copilot-instructions.md)

---

## ✅ Checklist for a Well-Structured Plan

Before creating a new plan, check:

- [ ] Explicit title and clear overall objective
- [ ] Well-separated phases (3-6 phases generally)
- [ ] Each phase has context, success criteria, tasks
- [ ] Each task is numbered T<N>.<M> with:
  - [ ] Action verb + object
  - [ ] Precise files
  - [ ] Explicit scope
  - [ ] Measurable acceptance criteria
  - [ ] Assigned agent
- [ ] Explicit dependencies and diagram
- [ ] Overall success criteria (5-7 items)
- [ ] Execution plan with triggers

---

## 🤝 Contributing to Plans

To contribute to or modify an existing plan:

1. **Do not modify the plan file after it has started** — create a new plan for major changes
2. **Document in the report**: any scope change or newly discovered task
3. **Notify the team**: if a blocker or risk is identified
4. **Update this README**: reflect the current status of the phases

---

**Last updated:** 2026-04-24  
**Plans manager:** ARCos (🟠 ARC) & 👤 Human developer
