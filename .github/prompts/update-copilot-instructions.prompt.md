---
name: update-copilot-instructions
description: >
  Audits the source code and best-practice files to complete and amend the
  copilot-instructions.md file. Use when: "update Copilot instructions", "complete
  copilot-instructions from the code", "synchronise instructions with the project",
  "add best practices to the Copilot instructions".
agent: agent
tools:
  - read_file
  - file_search
  - grep_search
  - semantic_search
  - replace_string_in_file
  - multi_replace_string_in_file
---

# Updating `copilot-instructions.md`

Mission: audit source code and reference files, then complete/amend `.github/copilot-instructions.md` so that it reflects the real state of the project and its best practices.

## Best-practice files to read (if present)

Read the following files if they exist:

| Relative root path | Expected role |
|---|---|
| `docs/BEST_PRACTICES.md` | Project development best practices |
| `docs/CODING_STANDARDS.md` | Code standards (naming, structure, patterns) |
| `docs/ARCHITECTURE.md` | Architecture decisions (ADR) |
| `docs/CONTRIBUTING.md` | Contribution guide / Git workflow |
| `CHANGELOG.md` | Change history (to detect recent developments) |
| `.eslintrc.json` / `eslint.config.*` | Active lint rules (enforced conventions) |

> If other reference files are provided in context, read those too.

## Source code audit steps

### 1. Read the existing instructions

Read `.github/copilot-instructions.md` in full to identify:
- Sections already present
- Information that may be obsolete or incomplete
- Conventions described but not verified in the code
- Chapters marked <em>to be completed</em> or <em>to be validated</em>

### 2. Explore the project structure

List `src/` to detect a new folder or domain that is not documented

### 3. Extract the real conventions from the code

For each layer, search for and note the patterns actually used:

**Interfaces**
- Interface naming
- Typical data interface structure

**Services**
- Injection pattern
- API call composition (error handling, use of service URL/config for endpoints, etc.)
- HTTP error handling

**Page components**
- Typical component structure

**Reusable components**
- Lifecycle pattern

**Utility functions**
- File naming conventions
- Pure function patterns

**Tests**
- Suite structure
- Mock tools used
- Setup pattern

**CSS / Styles**
- Defined CSS tokens
- Local class naming conventions

### 4. Check consistency with the existing instructions

For each convention documented in `copilot-instructions.md`:
- Confirm it is applied in the code
- Flag divergence between documentation and real code
- Identify conventions present in the code but absent from the instructions

### 5. Audit the agent instruction files

Read the following 4 files in `.github/instructions/`:
- `architect.instructions.md`
- `dev.instructions.md`
- `qa.instructions.md`
- `doc.instructions.md`

> If a file is missing, create it from the corresponding template in `.github/instructions/` from the transverse repository (`architect.instructions.template.md`, `dev.instructions.template.md`, `qa.instructions.template.md`, `doc.instructions.template.md`) and fill in the placeholders with project values.

For each file, check consistency with the source code:
- `dev.instructions.md`: library versions, constant file names, folder paths
- `qa.instructions.md`: test package versions, CI commands, coverage report paths
- `doc.instructions.md`: local docs/ paths, documentation file names, versions for `.puml` diagrams
- `architect.instructions.md`: layer names, state providers, HTTP service, routing strategy

In addition:
- Identify unfilled `[...]` placeholders and report them as required actions
- Identify obsolete values (for example: outdated library version)

### 6. Audit the shared skills

Read the following 4 skills in `.github/skills/` (if they exist):
- `plan-phase-execution/SKILL.md`
- `plan-creation/SKILL.md`
- `fleet-guide/SKILL.md`
- `adr-writing/SKILL.md`

For each skill, check:
- Frontmatter `applyTo: "**"` present (automatic inclusion in agent context)
- Content consistent with `.github/PLANS.md` (no format divergence)
- `.github/agents/*.agent.md` agents reference the skills in AP and /fleet sections (and do not repeat the content)
- Identify duplicated content between skill and agent (candidate for extraction)

> 💡 **Possible parallelisation**: Steps 2 (structure exploration), 3 (convention extraction), 5 (instructions/ audit) and 6 (skills/ audit) are **independent** and can be launched with `/fleet` to speed up the overall audit.

## Drafting rules for amendments

1. **Do not remove** existing sections without explicit reason — prefer amending or completing
2. **Verify in the code** each convention before adding it: do not document assumptions
3. **Stay concise**: Copilot instructions are read every session; avoid verbosity
4. **Keep French** for narrative text
5. **Use code examples** from the real source code when useful
6. **Structure additions** in the relevant existing section, or create a new titled section if necessary
7. **Do not duplicate** information already present in agent files (`.github/agents/`)

## Delivery format

Before applying modifications:

1. Present a **summary diff** of the proposed changes:
   - Sections to **add** (with justification and source in the code)
   - Sections to **amend** (with current value and corrected value)
   - Sections to **remove** (if obsolete — ask for confirmation)
   - Sections **validated** (consistent with the code, no change)
   - Verification of `.github/agents/*.agent.md` agents at the current version (v3.0+)
   - Verification of `.github/skills/*/SKILL.md` skills present and consistent with `PLANS.md`
   - Proposed modifications for each `.github/instructions/*.instructions.md` file (created from `*.instructions.template.md` if absent)
   - Separate report of unfilled placeholders vs obsolete values

2. Wait for **validation from the 👤 human Developer** before applying modifications.

3. Once validated, apply changes in `.github/copilot-instructions.md` and, if necessary, in `.github/instructions/*.instructions.md` files with `replace_string_in_file` or `multi_replace_string_in_file`.

4. Summarise the applied modifications as a bullet list.