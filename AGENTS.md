# AGENTS.md — vzwingma/vzwingma

Guide pour OpenCode lorsqu'on travaille sur du code dans le dépôt.

Dépôt transverse de templates multi-agents Copilot. Pas de code applicatif.

## Structure clé

| Path | Purpose |
|------|---------|
| `.github/agents/*.agent.md` | 4 agents génériques Copilot (ARCos v3.2, DEVon v3.1, QUALvin v3.1, DOCly v3.1) |
| `.opencode/agents/*.agent.md` | 4 agents OpenCode (ARCos v3.1, DEVon v3.1, QALvin v3.1, DOCly v3.1) |
| `.github/skills/` | Skills partagés (plan-phase-execution, plan-creation, fleet-guide, adr-writing, copilotignore, caveman-default) |
| `.github/instructions/*.instructions.md` | Templates à personnaliser par projet consommateur |
| `.github/prompts/*.prompt.md` | Prompts réutilisables (init/update/migrate) |
| `.github/plans/` | Plans d'Action multi-phases + rapports |
| `.agents/skills/` | Skills OpenCode (caveman family, cavecrew) |
| `docs/` | ARCHITECTURE.md, ADRs |

## Conventions fichier

- Agent: `*.agent.md` — frontmatter: `description`, `name`, optionnel `agents: ["*"]`
- Skill: `<skill>/SKILL.md` — frontmatter: `description`, `applyTo: "**"`
- Instructions: `*.instructions.md` — frontmatter: `description`, `applyTo: "**"`
- Prompt: `*.prompt.md`
- Plan: `NNN_<nom>.plan.md`
- Template placeholders: `[NOM_EN_MAJUSCULES]`
- Langue: FR contenu, EN code exemples

## Commandes

Aucune commande build/test/typecheck — dépôt documentation-only.

## Règles

- **Jamais** `rm`, `rmdir`, `git clean`, `git reset --hard`, `DROP TABLE` sans confirmation
- **Jamais** modifier fichiers hors périmètre tâche
- Lire `.copilotignore` au démarrage; ne jamais y accéder
- Validation humaine obligatoire avant chaque progression d'étape agent
- Version agent dans `description`; incrémenter à chaque modification

## Workflow agents

1. 👤 cadre besoin → 2. 🟠 ARCos crée Plan d'Action → ✅ humain
3. 🔵 DEVon implémente → ✅ humain → 4. 🟢 QUALvin tests → ✅ humain
5. 🟣 DOCly docs → ✅ humain

Parallélisation via `/fleet` quand tâches indépendantes.

## Références

- `CLAUDE.md` — instruction file legacy (Claude Code)
- `.github/copilot-instructions.md` — instruction file détaillé pour Copilot
- `.github/PLANS.md` — guide Plans d'Action
- `docs/ARCHITECTURE.md` — architecture dépôt

## Liens externes

- https://opencode.ai — OpenCode docs
