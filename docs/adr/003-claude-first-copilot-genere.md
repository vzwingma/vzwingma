# ADR 003 — Claude-first : `.claude/` source unique, Copilot généré, OpenCode retiré

**Date :** 2026-10-12  
**Statut :** Acceptée (Gate P0 du Plan d'Action 005, 2026-10-12)  
**Décideurs :** ⚫ MAINa (orchestration) + 🟠 ARCos (analyse) + 👤 Développeur humain

---

## Contexte

L'ADR 002 a fait de `.github/` (Copilot) la source unique, `.claude/` et `.opencode/` étant des
miroirs générés. Dans les faits :

- 5 scripts de sync coexistent, dans tous les sens (`github→claude`, `claude→github`,
  `opencode→claude`, `opencode→github`, `github→opencode`), et les commits récents synchronisent
  depuis `.claude/` → la source réelle est ambiguë.
- Le harnais Claude reste un portage de conventions Copilot ignorées par Claude Code : `applyTo`,
  `agents:` dans le frontmatter des agents, `/fleet`, prompts `.prompt.md`, `.copilotignore`. Les
  agents Claude n'ont ni `tools` ni `model`, et les règles de sécurité ne sont pas appliquées de
  façon déterministe.
- OpenCode n'est plus utilisé.

La revue du Plan d'Action 005 conclut qu'il faut optimiser pour Claude Code et générer les autres
plateformes depuis cette base, plutôt que l'inverse.

---

## Décision

**Nous avons décidé de** faire de `.claude/` la **source de vérité unique**, optimisée pour les
mécanismes natifs de Claude Code (frontmatter `tools`/`model`/`skills`, skills `context: fork`,
`settings.json`, hooks), de **générer `.github/` (Copilot)** depuis `.claude/` par un sync
unidirectionnel avec mapping de frontmatter, et de **retirer OpenCode** du dépôt.

---

## Alternatives Considérées

### Option 1 : Claude-first, Copilot généré, OpenCode retiré ✅ Retenue

- **Avantages** : une source, une direction de sync ; accès complet aux fonctionnalités Claude Code ;
  moins de fichiers à maintenir ; Copilot lit nativement `.claude/skills/` (à confirmer, T1.4).
- **Inconvénients** : réécriture du tooling de sync ; mapping de frontmatter Claude → Copilot à
  maintenir ; parité Copilot non garantie pour les fonctionnalités propres à Claude (hooks, `context: fork`).

### Option 2 : Socle commun neutre + adaptateurs par plateforme

- **Avantages** : parité multi-plateforme maximale.
- **Inconvénients** : contraint au plus petit dénominateur commun ; complexité d'outillage élevée.
- **Raison du rejet** : la priorité est d'optimiser Claude Code ; OpenCode est abandonné.

### Option 3 : Conserver l'ADR 002 (`.github/` source)

- **Avantages** : peu de refonte.
- **Inconvénients** : Claude reste dégradé (champs ignorés, garde-fous déclaratifs) ; le sync
  bidirectionnel entretient la dérive.
- **Raison du rejet** : cause racine des constats critiques C1-C4 du Plan d'Action 005.

---

## Conséquences

### Positives
- Agents et skills Claude réellement configurés (outils, modèle, préchargement, hooks).
- Sync unidirectionnel idempotent, contrôlable en CI.
- Suppression d'un miroir complet (`.opencode/`) et de 4 scripts.

### Négatives / Compromis
- Copilot devient une cible générée « best-effort » : certaines fonctionnalités Claude n'ont pas
  d'équivalent (hooks, fork de contexte).
- Suppression de fichiers (OpenCode) : exception explicite à la règle « jamais supprimer »,
  exécutée par `git rm` après validation 👤 au gate de la Phase 1 (réversible via l'historique git).

### Neutres
- `docs/ARCHITECTURE.md`, les QUICK_START et `scripts/README.md` doivent décrire le nouveau modèle.
- `.claude/CLAUDE.md` reste maintenu à la main (B1-bis de l'ADR 002 conservé).

---

## Mise en œuvre

- **Fichiers impactés** : `scripts/Sync-Description.psm1`, `scripts/sync-claude-to-github.ps1`,
  `.claude/agents/`, `.claude/skills/`, `.claude/settings.json`, `.claude/hooks/`, `.opencode/` (retiré),
  `scripts/*opencode*`, `scripts/sync-github-to-claude.ps1` (retiré).
- **Tâches de suivi** : Phases 1 à 7 du Plan d'Action 005.
- **Date d'effet** : à partir de la Phase 1 du Plan d'Action 005.

---

## Références

- Plan d'Action associé : `.claude/plans/005_claude-first.plan.md`
- ADR remplacée : `docs/adr/002-claude-miroir-genere.md`
- [Claude Code — Subagents](https://code.claude.com/docs/en/sub-agents),
  [Skills](https://code.claude.com/docs/en/skills), [Settings](https://code.claude.com/docs/en/settings)
- [GitHub Copilot — Create skills](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-skills)
