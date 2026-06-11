---
description: Project-specific details for [PROJECT_NAME] for the ARCos (architect) agent
applyTo: "**"
---

# Project-specific details — [PROJECT_NAME]

> File automatically read by 🟠 ARCos at start-up.
> Contains project-specific details for `[PROJECT_NAME]` (`[SHORT_PROJECT_DESCRIPTION]`, for example: React/TypeScript frontend).

## Reading the architecture document

**At start-up**, read `docs/ARCHITECTURE.md` if it exists in the current project:
- Understand the technical stack, application layers, key components
- Ensure planning decisions remain consistent with the existing architecture
- If absent, suggest that 🟣 DOCly create it at the end of the initiative

## Architectural conventions

- **Layers**: `[UI_LAYER]/` (UI) → `[STATE_LAYER]/` (global state) → `[HTTP_LAYER]/` (HTTP) → `[UTILS_LAYER]/` (constants, helpers).
- **Global state**: only via `[GLOBAL_STATE_PROVIDER]`. Do not create a new Context without validation.
- **HTTP**: always via `[HTTP_SERVICE]`. Do not use `fetch` directly in a component.
- **Routing**: `[ROUTING_STRATEGY]`. New routes are added in `[ROUTES_FILE]`.
- **No external state management library** without an explicit architectural decision.
- **UI**: `[UI_LIBRARY]` only. Do not introduce another UI library.

## Documenting architectural decisions (ADR)

Each major architectural decision must produce an ADR file in `docs/adr/`:

- **Naming**: `docs/adr/NNN-titre-court.md` (for example: `docs/adr/001-choix-framework-ui.md`)
- **Minimum content**: context, decision made, alternatives considered, consequences
- **When to create an ADR**: new framework, architectural pattern change, security decision, major structural choice
- Delegate ADR creation to 🟣 DOCly after the decision is validated

## SQL handoff protocol

When a task is ready to be carried out, insert todos into the SQL table with this format:

```sql
INSERT INTO todos (id, title, description, status) VALUES
  ('feat-xxx-dev', 'Titre dev',  'Description précise : fichiers à créer/modifier, interfaces à respecter', 'pending'),
  ('feat-xxx-qa',  'Titre QA',   'Tests à écrire : cas nominaux, cas d''erreur, composants à tester',       'pending'),
  ('feat-xxx-doc', 'Titre Doc',  'Documentation à mettre à jour : README, docs/ARCHITECTURE.md, docs/adr/, copilot-instructions.md', 'pending');

INSERT INTO todo_deps (todo_id, depends_on) VALUES
  ('feat-xxx-qa',  'feat-xxx-dev'),
  ('feat-xxx-doc', 'feat-xxx-dev');
```

ID naming convention: `feat-<name>-dev` / `feat-<name>-qa` / `feat-<name>-doc`.

## Interactions with the partner agent ([PARTNER_PROJECT_NAME])

- API contracts (URL, parameters, return codes) are defined in co-ordination with the Architect [PARTNER_ROLE, e.g. backend].
- µServices URLs are configured in `[TECHNICAL_CONSTANTS_FILE]` and `.env.*` files.
- Any new [PARTNER] endpoint must be reflected in `[HTTP_SERVICE]` before the Dev agent can use it.

## Project agents

| Icon | Name    | Agent file        | Role                          |
|------|---------|-------------------|-------------------------------|
| 🔵   | DEVon   | `Devon.agent.md`  | [MAIN_STACK] implementation   |
| 🟢   | QUALvin | `Qalvin.agent.md` | Unit tests ([TEST_FRAMEWORK]) |
| 🟣   | DOCly   | `Docly.agent.md`  | Documentation (README, /docs) |


## Plan index rule (mandatory)

- File `.github/plans/README.md` is a **summary index**: it must contain only the list of plans and their **overall status**.
- Do not display phase statuses.
- Any plan creation or overall status change must include, in the same change, an update to `.github/plans/README.md`.
