# ✅ Checklist: Initialise Copilot in a New Project

Use this checklist to **quickly initialise** this template repository in your project.

---

## 🚀 Step 1: Copy the Templates and Agents

- [ ] Copy `.github/agents/*.md` into your project
- [ ] Copy `.github/skills/` (3 skill folders) into your project
- [ ] Copy `.github/PLANS.md` into your project
- [ ] Copy `.github/copilot-instructions.template.md` into your project
- [ ] Copy `.github/instructions/*.instructions.md` into your project
- [ ] Create `.github/prompts/` if it does not exist
- [ ] Copy `.github/prompts/init-copilot-instructions.prompt.md` into your project
- [ ] Copy `docs/ARCHITECTURE.template.md` → `docs/ARCHITECTURE.md` into your project
- [ ] Create `docs/adr/` and copy `docs/adr/ADR-TEMPLATE.md` into it

---

## 🎯 Step 2: Initialise the Copilot Instructions

### Option A: Automatic (Recommended)
```bash
# Exécuter ce prompt
👤 "Initialise les instructions Copilot pour ce projet"
```

The prompt will:
1. ✅ Analyse your source code
2. ✅ Identify the technology stack
3. ✅ Fill `.github/copilot-instructions.md` automatically
4. ✅ Generate the files `.github/instructions/*.instructions.md`

### Option B: Manual
1. [ ] Copy `copilot-instructions.template.md` → `copilot-instructions.md`
2. [ ] Open and fill in the `[...]` sections:
   - [ ] `[PROJECT_NAME]`
   - [ ] **Project Overview**
   - [ ] **Commands**
   - [ ] **Architecture**
   - [ ] **Key Conventions**
   - [ ] **Project Status**
3. [ ] Fill in the placeholders in the 4 `instructions/` files:
   - [ ] `[PROJECT_NAME]` in each file
   - [ ] Technology stack in `dev.instructions.md`
   - [ ] Test commands in `qa.instructions.md`
   - [ ] docs/ files in `doc.instructions.md`

---

## 🔧 Step 3: Validate and Enrich

- [ ] Run this prompt to audit the code:
  ```
  👤 "Complète les instructions Copilot depuis le code source"
  ```

- [ ] Check that **NO** `[...]` placeholder remains
- [ ] Check that critical placeholders (`[PROJECT_NAME]`, stack) are filled in within the `instructions/` files
- [ ] Check that the sections are relevant for your project
- [ ] Remove sections that do not apply (e.g. mobile conventions for a backend project)

---

## 📋 Step 4: Configure Action Plans and Documentation

- [ ] Create `.github/plans/` if it does not exist
- [ ] Create `.github/plans/README.md` (or use the template)
- [ ] Add `.github/PLANS.md` as a reference guide
- [ ] Check that `docs/ARCHITECTURE.md` is initialised (otherwise: `cp docs/ARCHITECTURE.template.md docs/ARCHITECTURE.md`)
- [ ] Complete the **⚠️ TO COMPLETE** sections in `docs/ARCHITECTURE.md`

---

## ✨ Step 5: First Test

- [ ] Check that you can call the agents:
  ```
  👤 "Conçois une architecture pour une authentification JWT"
  ```
  → `Arcos (🟠 ARC)` should respond

- [ ] Test a prompt:
  ```
  👤 "Initialise les instructions Copilot pour ce projet"
  ```

---

## 📚 Step 6: Document

- [ ] Add a note in `README.md`:
  ```markdown
  ## 🤖 Copilot & Agents
  
  Ce projet utilise une architecture multi-agents orchestrée.
  Voir [`.github/copilot-instructions.md`](.github/copilot-instructions.md) pour les conventions et les instructions.
  ```

- [ ] Commit:
  ```bash
  git commit -m "chore: initialiser Copilot avec agents et templates transverses"
  ```

---

## 🎓 Usage After Configuration

### Start an Implementation
```
👤 "Implémente l'authentification JWT dans le service d'auth"
```
→ `Devon (🔵 DEV)` handles it

### Write Tests
```
👤 "Écris des tests pour le service d'authentification"
```
→ `Qalvin (🟢 QUAL)` handles it

### Plan a Large Task
```
👤 "Conçois une architecture pour refactoriser la base de données et crée un plan d'action"
```
→ `Arcos (🟠 ARC)` creates an Action Plan

### Update Documentation
```
👤 "Mets à jour la documentation après cette implémentation"
```
→ `Docly (🟣 DOC)` handles it

### Parallelise Independent Tasks
```
👤 "Lance DEVon sur le composant A et QUALvin sur le composant B en parallèle"
```
→ Use `/fleet`: tasks without dependencies run simultaneously

---

## 🔄 Ongoing Maintenance

- [ ] **Each month**: Run `update-copilot-instructions` to synchronise
- [ ] **After a major change**: Update `.github/copilot-instructions.md`
- [ ] **For a large initiative**: Create an Action Plan in `.github/plans/`
- [ ] **Parallel tasks**: Use `/fleet` when DEVon, QUALvin or DOCly have independent tasks

---

## ✅ Final Checklist

Before considering Copilot "ready":

- [ ] `.github/copilot-instructions.md` exists and is customised
- [ ] `.github/agents/*.md` (4 files) are present
- [ ] `.github/skills/*/SKILL.md` (3 skills) are present
- [ ] `.github/instructions/*.instructions.md` (4 files) are present and customised
- [ ] `.github/PLANS.md` is accessible
- [ ] `docs/ARCHITECTURE.md` exists and the ⚠️ sections are completed
- [ ] `docs/adr/` exists (with `ADR-TEMPLATE.md` as the template)
- [ ] No `[...]` placeholder remains in copilot-instructions.md
- [ ] First test with `Arcos (🟠 ARC)` successful ✅
- [ ] First test with `Devon (🔵 DEV)` successful ✅
- [ ] Team aware of the multi-agent workflow

---

**🎉 You are ready! Start collaborating with Copilot and the agents.**

To learn more, see:
- [`.github/README.md`](.github/README.md) — Complete guide
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — Project instructions
- [`.github/PLANS.md`](.github/PLANS.md) — Action Plan guide
