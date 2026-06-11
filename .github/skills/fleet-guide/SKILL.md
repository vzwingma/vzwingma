---
name: "fleet-guide"
description: "Skill — Guide to `/fleet` parallelisation for all agents. Automatically applied."
---

# Skill: Parallelisation with /fleet

> `/fleet` = Copilot CLI parallel execution mode. Dispatches several sub-agents simultaneously, reducing total time.

---

## When to use /fleet

- **Independent tasks for the same agent**: Several components/services/files with no dependency
- **Parallel multi-agent delegation**: Two agents start simultaneously (for example: QUALvin + DOCly on the same feature after DEVon)
- **Parallel phases of an Action Plan**: Two phases run simultaneously

---

## When NOT to use /fleet

- Task B **depends on the result** of task A
- Two sub-tasks **modify the same file** (conflict risk)
- A shared setup file must be created first

---

## How to indicate the use of /fleet

In a plan or delegation, explicitly indicate parallelisable tasks:

```
💡 Ces tâches sont indépendantes → lancer en /fleet :
- Tâche A (Agent X)
- Tâche B (Agent Y)
```

---

## Decision rule

| Situation | Recommended mode |
|---|---|
| Task B depends on task A | Sequential |
| Tasks A and B unrelated | `/fleet` |
| DEVon finished → QUALvin + DOCly | `/fleet` for QUALvin + DOCly |
| Several independent items | `/fleet` |