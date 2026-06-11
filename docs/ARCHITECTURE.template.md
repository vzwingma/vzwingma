# 🏗️ Architecture — [PROJECT_NAME]

> **Template**: This file is a template to copy into your project's `docs/ARCHITECTURE.md`.  
> Replace the `[...]` placeholders with the real values. Complete the sections progressively as development advances.  
> Sections marked **⚠️ TO COMPLETE** are the priority at start-up.

---

## 🎯 Overview

**[PROJECT_NAME]** is [SHORT_DESCRIPTION: 1-2 sentences describing what the project does and for whom].

| Property | Value |
|---|---|
| **Type** | [front-end / back-end / full-stack / mobile / CLI / lib / API] |
| **Main stack** | [eg: React 18 + TypeScript, Spring Boot 3, Python FastAPI, etc.] |
| **Target platform** | [web / iOS / Android / desktop / server / etc.] |
| **UI language** | [French / English / etc.] |
| **Status** | [In development / Stable / Legacy / In maintenance] |

---

## 🏢 Overall Architecture ⚠️ TO COMPLETE

> Describe the main layers and their role. Example below for a React + API project.

```
[PROJECT_NAME]
├── [UI_LAYER]           # [Description: eg. React components, pages, screens]
├── [STATE_LAYER]        # [Description: eg. Contexts, stores, global state]
├── [SERVICE_LAYER]      # [Description: eg. HTTP calls, business logic]
├── [MODELS_LAYER]       # [Description: eg. TypeScript interfaces, entities]
└── [UTILS_LAYER]        # [Description: eg. Helpers, constants, config]
```

### Main data flow

```
[INBOUND_ACTOR]
    → [LAYER_1: eg. UI component]
    → [LAYER_2: eg. HTTP service]  
    → [EXTERNAL_SYSTEM: eg. Backend API / DB]
    ← [return]
```

---

## 📂 Folder Structure ⚠️ TO COMPLETE

```
[PROJECT_ROOT]/
├── [MAIN_DIRECTORY]/              # [Description]
│   ├── [SUBDIRECTORY_1]/          # [Description]
│   ├── [SUBDIRECTORY_2]/          # [Description]
│   └── [SUBDIRECTORY_3]/          # [Description]
├── docs/                          # Versioned documentation
│   ├── ARCHITECTURE.md            # This file
│   └── adr/                       # Architecture Decision Records
├── [TESTS_DIRECTORY]/             # [Description]
└── [CONFIG_FILES]                 # [eg: package.json, pyproject.toml, etc.]
```

---

## 🔧 Technical Stack

### Main dependencies

| Category | Library / Framework | Version | Role |
|---|---|---|---|
| [eg: UI framework] | [eg: React] | [eg: 18.x] | [eg: Component rendering] |
| [eg: Language] | [eg: TypeScript] | [eg: 5.x] | [eg: Static typing] |
| [eg: Tests] | [eg: Jest] | [eg: 29.x] | [eg: Unit tests] |
| [eg: Build] | [eg: Vite] | [eg: 5.x] | [eg: Bundler] |

> ⚠️ Keep this table up to date with each major version upgrade.

### Environment variables

| Variable | Description | Example |
|---|---|---|
| `[VAR_NAME_1]` | [Description] | `[example_value]` |
| `[VAR_NAME_2]` | [Description] | `[example_value]` |

---

## 🔄 External Integrations

> List the external systems the project communicates with.

| System | Type | URL / Endpoint | Authentication |
|---|---|---|---|
| [eg: Backend API] | [REST / GraphQL / WebSocket] | `[BASE_URL]` | [eg: JWT Bearer] |
| [eg: DB] | [PostgreSQL / MongoDB / etc.] | `[connection]` | [eg: SSL + password] |

---

## 🔐 Security

> ⚠️ TO COMPLETE — Describe the security mechanisms in place.

- **Authentication** : [eg: OAuth2 via [PROVIDER], JWT tokens with refresh]
- **Authorisation** : [eg: RBAC with USER / ADMIN roles]
- **Sensitive data** : [eg: Never store tokens in localStorage, always use httpOnly cookies]
- **Input validation** : [eg: Zod on client side, Bean Validation on server side]

---

## 🧪 Tests

| Type | Framework | Location | Target coverage |
|---|---|---|---|
| Unit | [eg: Jest + RTL] | `[eg: src/**/*.test.ts]` | ≥80% |
| [Integration] | [eg: Supertest] | `[eg: tests/integration/]` | [eg: ≥60%] |
| [E2E] | [eg: Playwright] | `[eg: e2e/]` | [eg: Critical scenarios] |

Command to run tests: `[TEST_COMMAND]`  
Coverage report: `[COVERAGE_REPORT_PATH]`

---

## 📐 Conventions and Patterns

> Summary of key conventions — for details, see `.github/copilot-instructions.md`.

- **File naming** : [eg: `*.component.tsx`, `*.service.ts`, `*.test.ts`]
- **Variable naming** : [eg: camelCase for variables, PascalCase for components]
- **State management** : [eg: Context API only, no Redux]
- **HTTP calls** : [eg: Always via `ClientHTTP.service.ts`, never `fetch` directly]
- **Error handling** : [eg: Always catch HTTP errors, show a user toast]

---

## 🗺️ Architectural Decisions (ADR)

> Major architectural decisions are documented in `docs/adr/`.  
> Format: `docs/adr/NNN-short-title.md`

| # | Decision | Status | Date |
|---|---|---|---|
| [001] | [eg: Choosing React over Vue] | [Accepted / Deprecated / Replaced] | [YYYY-MM-DD] |
| [002] | [eg: OAuth2 authentication] | [Accepted] | [YYYY-MM-DD] |

> 💡 Each new major architectural decision must have an ADR. See `docs/adr/` for details.

---

## 📈 Performance

> ⚠️ TO COMPLETE if relevant — Document performance optimisations and constraints.

- [eg: Mandatory pagination on all lists > 50 items]
- [eg: `useMemo` for expensive derived calculations in components]
- [eg: Images optimised via [TOOL], WebP formats preferred]

---

## 🚀 Deployment

| Environment | URL | Trigger |
|---|---|---|
| Development | `[URL_DEV]` | [eg: Push to `develop`] |
| Staging | `[URL_STAGING]` | [eg: PR to `main`] |
| Production | `[URL_PROD]` | [eg: Tag `v*`] |

CI/CD pipeline: [eg: GitHub Actions — see `.github/workflows/`]

---

## 📝 Version History

> Add an entry for each delivered version (at the top of the list).

| Version | Date | Major changes |
|---|---|---|
| [eg: v1.0.0] | [YYYY-MM-DD] | [eg: Initial version] |

---

## 🔗 Resources

- **README** : [`README.md`](../README.md)
- **Copilot instructions** : [`.github/copilot-instructions.md`](../.github/copilot-instructions.md)
- **Action Plans** : [`.github/plans/`](../.github/plans/)
- **ADRs** : [`docs/adr/`](./adr/)
- [**[EXTERNAL_LINK_1]**]([URL]) : [Description]
