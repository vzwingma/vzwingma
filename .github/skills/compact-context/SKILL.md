---
name: "compact-context"
description: "PreCompact instructions for plan/SDLC sessions. Preserves current state, removes outdated skill blobs. Automatically applied."
applyTo: "**"
---

# Skill: Contextual Compact — Plan / SDLC Sessions

> This skill provides optimised `/compact` instructions for sessions with Action Plans or multi-phase SDLC workflows.
> Goal: avoid accumulation of skill blobs (~4-8KB each) between successive phases.

---

## When to compact

Compact **before** moving to the next phase, in these situations:

- ✅ End of an Action Plan (AP) phase — before launching T<N+1>.x
- ✅ After injecting a workflow skill (sdlc-tech-design, sdlc-deliverable-validation, etc.)
- ✅ After creating/validating a complete plan
- ✅ After 8+ turns if no compact has been done

---

## PreCompact instruction — Action Plan Sessions

Use this instruction with `/compact`:

```
Summarise in max 200 words:
- Current plan: title, number, overall status
- Active phase: number, remaining tasks (T<N>.x to T<N>.y), assigned agent
- Key decisions made (architecture, technology, validated constraints)
- Next expected action

Remove entirely:
- Skill blobs from previous phases (<skill-context> content)
- Details of already completed tasks (✅)
- Short confirmations ("yes", "go", "ok", "continue")
- Navigation history (file reads, shell commands without lasting result)
```

---

## PreCompact instruction — SDLC Sessions

For multi-step SDLC workflows (design → implementation → validation):

```
Summarise in max 150 words:
- Current SDLC step and its objective
- Validated decisions (architecture, technology, constraints)
- Open questions/points not yet resolved
- Next triggered step

Remove: skill blobs from previous steps, validation exchanges ("yes detail", confirmations), file navigation history.
```

---

## Typical gains

| Situation | Context before compact | After compact |
|-----------|----------------------|---------------|
| 4 AP phases, 1 skill/phase (~5KB) | ~20KB accumulated skill blobs | ~400 chars summary |
| 20-turn session, 3 injected skills | ~15KB of outdated context | ~300 chars current state |

> 💡 Rule: if `usage_input_tokens` exceeds 30K in `/usage`, compact immediately.
