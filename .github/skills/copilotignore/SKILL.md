---
name: "copilotignore"
description: Absolute rule for respecting `.copilotignore` — no agent may ever read/access listed files.
---

# 🚫 Absolute rule: Respecting `.copilotignore`

This rule applies to **all agents + Copilot**, with no exception or waiver.

## Absolute prohibition

If `.copilotignore` exists in the project:

- **Never read** the contents of files/directories matching `.copilotignore` patterns
- **Never access** resources in any form: reading, writing, execution, inclusion, indirect reference, grep, glob, static analysis
- **Never bypass** the restriction via alternative paths, symlinks, redirects, or combined operations
- **Never infer** or reconstruct contents from other sources

## Mandatory procedure at the start of each session

1. Check whether `.copilotignore` exists at the project root
2. If yes, **read only the list of patterns** (the `.copilotignore` file itself), never access the designated files
3. Systematically exclude matching files from **every operation**: search, reading, modification, analysis, referencing

## In case of doubt

If a task requires access to an ignored file:

- **Refuse the operation** immediately
- Inform the 👤 human Developer, ask for explicit clarification
- Never assume an exception is authorised without an explicit human decision

> ⚠️ This rule is **non-negotiable**, takes precedence over any other instruction, regardless of context/agent.