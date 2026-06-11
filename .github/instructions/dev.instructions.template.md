---
description: Project-specific details for [PROJECT_NAME] for the 🔵 DEVon (dev) agent
applyTo: "**"
---

# Project-specific details — [PROJECT_NAME] (Dev)

> File automatically read by the 🔵 DEVon agent at start-up. Contains project-specific details for `[PROJECT_NAME]` (`[SHORT_PROJECT_DESCRIPTION]`, for example: React/TypeScript frontend).

## Workflow

1. Check the SQL `todos` table for `owner = 'dev'` tasks with status `pending` and no blocking dependencies.
2. Move the todo to `in_progress` before starting.
3. Implement the feature according to the conventions below.
4. Move the todo to `done` when the code is ready.

```sql
-- Trouver les tâches dev disponibles
SELECT t.* FROM todos t
WHERE t.status = 'pending'
AND (t.id LIKE '%-dev' OR t.description LIKE '%owner: dev%')
AND NOT EXISTS (
  SELECT 1 FROM todo_deps td
  JOIN todos dep ON td.depends_on = dep.id
  WHERE td.todo_id = t.id AND dep.status != 'done'
);
```

## Technical stack

- **[MAIN_FRAMEWORK] [VERSION]** – [PARADIGM, e.g. strict TypeScript, functional components only]
- **[UI_LIBRARY] [VERSION]** (`[UI_PACKAGE]`) – the only authorised UI library
- **[ROUTING_LIBRARY] [VERSION]** – `[ROUTING_STRATEGY]`, routes in `[ROUTES_FILE]`
- **[AUTH_LIBRARY] [VERSION]** – [AUTH_GUIDELINE, e.g. do not handle OAuth tokens directly]
- **[CHARTS_LIBRARY] [VERSION]** – for visualisations ([CHART_TYPES])

## Code conventions

### Components

```typescript
// Toujours : composant fonctionnel typé
export const MonComposant: React.FC<MonComposantProps> = ({ prop1, prop2 }): JSX.Element => {
  // ...
};
```

- Props interfaces in `[PROPS_FILE]`.
- Page sub-components in `[SUBCOMPONENTS_FOLDER]/`, action buttons in `[ACTIONS_FOLDER]/`.
- Use `useMemo` for expensive derived calculations, `useCallback` for handlers passed as props.
- Responsive behaviour via `[RESPONSIVE_METHOD]`.

### HTTP calls

```typescript
// Toujours passer par [SERVICE_HTTP]
import { call } from '../Services/[SERVICE_HTTP]';
// URL avec {{}} comme marqueur positionnel
call('GET', [CONFIG_URL_VARIABLE], '/[CHEMIN_API]/{{}}/[RESSOURCE]', [paramId]);
```

### Models and state

- Data classes in `[MODELS_FOLDER]`.
- Global state via `useContext([CONTEXT_NAME])`.
- Local UI state via `useState`.

### Enums and constants

- Technical constants in `[TECHNICAL_CONSTANTS_FILE]`.
- Business enums in `[BUSINESS_ENUMS_FILE]`.
- Do not hardcode URLs or API keys in components.

## What you do NOT do

- Do not modify `*.test.[tsx|ts]` files (🟢 QUALvin's role).
- Do not update `README.md`, `docs/`, or `copilot-instructions.md` (🟣 DOCly's role).
- Do not make architectural decisions (new Context, new library) without a todo from 🟠 ARCos.


## Plan index rule (mandatory)

- `.github/plans/README.md` is limited to **plans + overall status** (without phase details).
- If your work changes a plan's overall status, update `.github/plans/README.md` in the same change.
