---
description: Project-specific details for [PROJECT_NAME] for the 🟢 QUALvin (qa) agent
applyTo: "**"
---

# Project-specific details — [PROJECT_NAME] (QA)

> File automatically read by 🟢 QUALvin at start-up.
> Contains project-specific details for `[PROJECT_NAME]` (`[SHORT_PROJECT_DESCRIPTION]`, for example: React/TypeScript frontend).

## Workflow

1. Check the SQL `todos` table for `*-qa` tasks whose dependencies are `done`.
2. Move the todo to `in_progress`.
3. Write tests, run them, verify coverage.
4. Move to `done` if tests pass, `blocked` + description if there is a blocking failure.

## Test stack

- **[TEST_FRAMEWORK]** + **[COMPONENT_TEST_LIBRARY]** (`[COMPONENT_TEST_PACKAGE]@[VERSION]`, `[USER_EVENTS_PACKAGE]@[VERSION]`)
- **[DOM_ASSERTIONS_LIBRARY]** for DOM assertions (`[DOM_ASSERTIONS_PACKAGE]@[VERSION]`)
- Test files: `*.test.[tsx|ts]` co-located with the file under test

## Commands

```bash
# Tous les tests (mode watch)
[COMMANDE_TEST_WATCH]

# Tous les tests en CI (sans watch, avec coverage)
[COMMANDE_TEST_CI]

# Un seul fichier de test
[COMMANDE_TEST_FICHIER] [CHEMIN_EXEMPLE_TEST]

# Un seul test par nom
[COMMANDE_TEST_NOM_PATTERN] "[NOM_EXEMPLE_TEST]"
```

Coverage report generated in `[COVERAGE_REPORT_PATH]` (read by [QUALITY_TOOL, e.g. SonarCloud]).

## What to test

### [MAIN_FRAMEWORK] components

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { [NOM_CONTEXT] } from '[CHEMIN_CONTEXT_PROVIDER]';

// Toujours mocker le Context si le composant l'utilise
const mockContext = { [CLE_CONTEXTE]: ..., [SETTER_CONTEXTE]: jest.fn(), ... };

test('doit afficher le libellé de l\'opération', () => {
  render(
    <[NOM_CONTEXT].Provider value={mockContext}>
      <MonComposant ... />
    </[NOM_CONTEXT].Provider>
  );
  expect(screen.getByText('Libellé attendu')).toBeInTheDocument();
});
```

### Services

```typescript
// Mocker fetch pour [SERVICE_HTTP]
global.fetch = jest.fn(() => Promise.resolve({ status: 200, json: () => Promise.resolve(data) }));
```

## Cases to cover systematically

- **Nominal case**: correct rendering with valid data.
- **Empty / null case**: behaviour when data is missing.
- **HTTP error case**: 403 ([ACTION_403, e.g. logout]), 404, 500.
- **User interactions**: clicks, input (via `userEvent`).
- **Responsive**: if `[RESPONSIVE_HOOK]` is used, mock `[THEME_PROVIDER]`.

## What you do NOT do

- Do not modify production files (`*.[tsx|ts]` outside `*.test.*`).
- Do not update docs (🟣 DOCly's role).
- Do not make testing architecture decisions without 🟠 ARCos validation.

## Plan index rule (mandatory)

- `.github/plans/README.md` is an index of **plans + overall status** only (no phases).
- If delivered QA work changes a plan's overall status, synchronise `.github/plans/README.md` in the same change.
