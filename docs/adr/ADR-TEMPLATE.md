# ADR NNN — [Short title of the decision]

> **Template** : Copy this file into `docs/adr/NNN-short-title.md`.  
> Naming format: `NNN` = 3-digit number (eg: `001`, `042`), title in kebab-case.

---

**Date :** [YYYY-MM-DD]  
**Status :** [Proposed / Accepted / Deprecated / Replaced by ADR-NNN]  
**Decision-makers :** [🟠 ARCos + 👤 Human developer]

---

## Context

> Describe the current situation and why a decision is needed.  
> Include the technical, business or team constraints that influence the choice.

[Description of the problem or need requiring this architectural decision.]

---

## Decision

> State the decision taken clearly, in one or two direct sentences.

**We have decided to** [DECISION].

---

## Alternatives Considered

> List the options that were evaluated before taking the decision.

### Option 1: [Name of the selected alternative] ✅ Selected

- **Advantages** : [...]
- **Disadvantages** : [...]

### Option 2: [Name of the alternative]

- **Advantages** : [...]
- **Disadvantages** : [...]
- **Reason for rejection** : [...]

### Option 3: [Name of the alternative]

- **Advantages** : [...]
- **Disadvantages** : [...]
- **Reason for rejection** : [...]

---

## Consequences

### Positive
- [eg: Simplifies state management in components]
- [eg: Reduces coupling between layers]

### Negative / Trade-offs
- [eg: Requires migration of existing components]
- [eg: Learning curve for the team]

### Neutral
- [eg: Involves updating the `docs/ARCHITECTURE.md` documentation]

---

## Implementation

> Describe how this decision is applied concretely in the project.

- **Impacted files** : [eg: `src/services/`, `src/contexts/`]
- **Follow-up tasks** : [eg: DEVon — refactor `ClientHTTP.service.ts`]
- **Effective date** : [eg: From version v2.0]

---

## References

- [Link to the official documentation, RFC, article, or related action plan]
- [Related Action Plan: `.github/plans/NNN_nom.plan.md`]
