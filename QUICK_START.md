# 🚀 Quick Guide: Using This Template Repository

Welcome! This repository contains the **reusable templates and agents** for orchestrating development with Copilot.

---

## ⚡ TL;DR — 3 Quick Steps

If you have a **new project** and want to initialise Copilot quickly:

### 1️⃣ Copy the Essential Files

```bash
# Depuis ce dépôt vers votre projet
cp -r .github/agents <votre_projet>/.github/
cp -r .github/instructions <votre_projet>/.github/
cp -r .github/skills <votre_projet>/.github/
cp .github/PLANS.md <votre_projet>/.github/
cp .github/copilot-instructions.template.md <votre_projet>/.github/copilot-instructions.md
mkdir -p <votre_projet>/.github/prompts
cp .github/prompts/*.prompt.md <votre_projet>/.github/prompts/
```

### 2️⃣ Initialise the Instructions

Open Copilot in your project and run:

```
👤 "Initialise les instructions Copilot pour ce projet"
```

✅ This will analyse your code and generate the instructions automatically.

### 3️⃣ Validate

```
👤 "Complète les instructions Copilot depuis le code source"
```

✅ Your project is ready! Start using the agents.

---

## 📚 Contents of This Repository

### 🤖 Agents (4)
Ready-to-use models for different roles:
- **🔵 DEVon** — Implements code
- **🟢 QUALvin** — Writes tests
- **🟠 ARCos** — Plans and creates Action Plans
- **🟣 DOCly** — Maintains documentation

### 📋 Templates
- **`copilot-instructions.template.md`** — Generic template to customise
- **`instructions/`** — 4 agent instruction templates to customise per project
- **`PLANS.md`** — Guide for orchestrating multi-phase work
- **Prompts** — To initialise instructions automatically

### 📖 Documentation
- **`.github/README.md`** — Complete repository guide
- **`SETUP_CHECKLIST.md`** — Checklist for initialising a project
- **`.github/examples/`** — Practical examples (Domoticz, etc.)

---

## 🎯 Typical Workflow

Once Copilot is configured, here is how to collaborate:

```
1️⃣ Vous décrivez le besoin
   ↓
2️⃣ 🟠 ARCos crée un Plan d'Action
   ↓
3️⃣ 🔵 DEVon implémente les tâches
   ↓
4️⃣ 🟢 QUALvin écrit les tests
   ↓
5️⃣ 🟣 DOCly met à jour la documentation
```

> 💡 **Parallelisation**: Use `/fleet` when QUALvin and DOCly can work in parallel after DEVon, or when several DEVon tasks are independent.

---

## ❓ FAQ

### Q: How do I quickly copy this repository into my project?
A: 
```bash
git clone <ce_repo> copilot-templates
cp -r copilot-templates/.github/* mon-projet/.github/
```

### Q: Do I need to copy everything?
A: No! Minimum required:
- `.github/agents/` (4 files)
- `.github/skills/` (3 skills — one folder per skill with `SKILL.md`)
- `.github/instructions/` (4 files — to customise)
- `.github/copilot-instructions.template.md` (rename to `copilot-instructions.md`)
- `.github/PLANS.md`

### Q: How do I initialise quickly?
A: Once the files are copied, run in your project:
```
👤 "Initialise les instructions Copilot pour ce projet"
```

### Q: Are the agents customisable?
A: The agents are **generic**; customisation happens in two places: `.github/copilot-instructions.md` (global context) and `.github/instructions/*.instructions.md` (specifics per agent).

### Q: How do I parallelise tasks between agents?
A: Use `/fleet` when several agents have independent tasks (e.g. QUALvin + DOCly after DEVon, or several components to implement without dependencies). `/fleet` dispatches the sub-agents simultaneously.

### Q: Where should I store my Action Plans?
A: In `.github/plans/` — use the format `XXX_<nom>.plan.md`.

### Q: What is the licence?
A: Free to use — this is a cross-cutting template repository.

---

## 📞 Need Help?

1. **Read** [`.github/README.md`](.github/README.md) — Complete guide
2. **See** [`.github/PLANS.md`](.github/PLANS.md) — Action Plan guide
3. **Look at** [`.github/examples/`](.github/examples/) — Practical examples
4. **Follow** [`SETUP_CHECKLIST.md`](SETUP_CHECKLIST.md) — Step by step

---

## ✅ Quick Check

After configuration, check that:

- [ ] `.github/agents/` has 4 files ✅
- [ ] `.github/skills/` has 3 skills (folders with `SKILL.md`) ✅
- [ ] `.github/instructions/` has 4 files with `[PROJECT_NAME]` filled in ✅
- [ ] `.github/copilot-instructions.md` exists and is customised ✅
- [ ] `.github/PLANS.md` is accessible ✅
- [ ] Calling `Arcos` (🟠 ARC) works ✅
- [ ] Calling `Devon` (🔵 DEV) works ✅

---

**That's it! You are ready to collaborate with Copilot. 🚀**

Read [`.github/README.md`](.github/README.md) for more details about each agent and prompt.
