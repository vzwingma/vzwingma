# Phase 1 : Source unique Claude + décommission OpenCode

**Responsable Agent :** 🔵 DEVon (T1.1-T1.3) · 🟠 ARCos (T1.4)
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — validation 👤 en attente

---

## 📝 Tâches

### T1.1 - Retirer OpenCode et scripts obsolètes

**Statut :** ✅ DONE (go explicite 👤 « GO P1 »)

**Fichiers retirés (`git rm`, récupérables via historique) :**
- `.opencode/` (31 fichiers) — sauf rapports plan 001 déplacés (T1.2)
- `QUICK_START_OPENCODE.md`
- `scripts/package-opencode.ps1`, `scripts/sync-github-to-opencode.ps1`, `scripts/sync-opencode-to-github.ps1`, `scripts/sync-opencode-to-claude.ps1`
- `scripts/sync-github-to-claude.ps1` (sens inversé, ADR 003)

**Fichiers modifiés :**
- `.vscode/tasks.json` — tâches OpenCode + `GitHub → Claude` retirées ; ajout `Sync: Check (Claude → GitHub)`
- `scripts/package-claude.ps1`, `scripts/package-github.ps1` — commentaires d'exclusion sans `.opencode/`

### T1.2 - Consolider les plans

**Statut :** ✅ DONE

- `.github/plans/001-003*` + `002_reports/` → `.claude/plans/archive/` (`git mv`, historique conservé)
- `.opencode/plans/001_reports/` → `.claude/plans/archive/OC-001_reports/`
- Ancien index `.github/plans/README.md` → `.claude/plans/archive/README.github-index.md` (déplacé, non supprimé)
- `.claude/plans/README.md` : index unique, liens archive, OC-001 ajouté

### T1.3 - Réécrire le sync `claude → github`

**Statut :** ✅ DONE

**Fichiers :**
- `scripts/Sync-Description.psm1` — réécrit en générateur unidirectionnel :
  - frontmatter agent Copilot **généré** (override mapping > dérivé Claude > omis) ; champs Claude-only retirés
  - frontmatter skill réduit à la spec Agent Skills (`name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`)
  - substitution par tokens délimités, ordre long→court (`QUICK_START_CLAUDE` / `CLAUDE.template.md` avant `CLAUDE.md`) ; `Claude` → `Copilot` sauf noms de modèles
  - blocs `<!-- claude-only -->…<!-- /claude-only -->` (retirés) et `<!-- copilot-only … -->` (déballés)
- `scripts/copilot-mapping.psd1` — nouveau ; seedé avec le frontmatter Copilot existant (model/tools/agents) → génération sans régression
- `scripts/sync-claude-to-github.ps1` — réécrit : + `agents/README.md`, fichiers support des skills, `CLAUDE.md → copilot-instructions.md` ; détection **orphelins** (jamais supprimés) ; mode `-Check` (exit 1 si divergence)
- `scripts/README.md` — réécrit (modèle ADR 003, substitution, mapping, workflow)
- `docs/ARCHITECTURE.md` — section modèle → Claude-first ; maintenance agents → `.claude/` + sync ; ligne OpenCode retirée ; table ADR (002 remplacée, 003 acceptée)
- `.claude/CLAUDE.md` l.3 — mention `claude.ai/code` neutralisée (fuyait dans `copilot-instructions.md`)

**Résultats :**
- 1ʳᵉ exécution : 17 fichiers `.github/` régénérés, 16 déjà conformes. **Agents régénérés identiques à l'octet** (mapping fidèle).
- Diffs `.github/` attendus : `applyTo` retiré des 14 `SKILL.md` (champ invalide pour un skill) ; `CHANGELOG.md` corrige l'ancien bug « Copilot Sonnet 4.6 » → « Claude Sonnet 4.6 » ; `copilot-instructions.md` désormais généré depuis `CLAUDE.md` ; `agents/README.md` créé.
- 2ᵉ exécution `-Check` : **0 changement, 0 orphelin, exit 0** (idempotence).
- `.github/` : 0 occurrence `.claude/`, `Claude Code`, `CLAUDE.md`, ni `Claude` hors noms de modèles.
- Test cas limites (`QUICK_START_CLAUDE.md`, `Claude Sonnet`, `ClaudeX`, `claude --agent`, blocs plateforme, mapping outils) : ✅.
- Testé sous Windows PowerShell 5.1 (moteur des tâches VS Code).

### T1.4 - Spike skills partagés Copilot

**Statut :** ✅ DONE — décision : **conserver `.github/skills/` généré** (frontmatter épuré)

**Constats (docs GitHub, 2026-10-12) :**
- Copilot CLI charge les skills projet depuis `.github/skills`, `.claude/skills` **ou** `.agents/skills`.
- Champs SKILL.md documentés : `name`, `description`, `license`, `allowed-tools`. Tolérance aux champs inconnus **non documentée**.
- Précédence en cas de doublon de nom entre emplacements **non documentée**.
- Agents Copilot : Copilot accepte les noms d'outils Claude comme alias (`Read`, `Edit`, `Write`, `Bash`, `Grep`, `Glob`, `WebFetch`, `WebSearch`, `Task`, `TodoWrite`) ; supporte `disable-model-invocation` / `user-invocable`.

**Raisons :** le ZIP Copilot ne livre que `.github/` ; champs Claude-only à venir (P3 : `context: fork`, `agent:`) potentiellement rejetés ; doublons non spécifiés. Réévaluer quand la doc précisera précédence et tolérance.

---

## 📊 Synthèse de Phase

**Tâches Complétées :** 4/4 ✅
**Critères de Réussite Atteints :**
- ✅ 1 seul script de sync (`claude → github`)
- ✅ Sync idempotent (`-Check` exit 0)
- ✅ 0 réf OpenCode hors archive / ADR / historique (CHANGELOG, plans 004-005)

**Bloqueurs :** Aucun
**Points d'attention pour la suite :**
- Dossier `.github/plans/` vide laissé sur disque (non suivi par git) — à retirer manuellement si souhaité.
- `.github/` contient encore la prose Claude-spécifique des agents/skills (`Agent tool`, `subagent_type`, `/fleet`) → traitée en P2/P3 via blocs `claude-only` / `copilot-only`.
- Mapping Copilot conserve modèles/outils actuels (dont outils `vscjava` Java-spécifiques de DEVon, m4) → à revoir en P2/P6.
- Tests Pester du module et CI → P6 (T6.3, T6.4).

**Prochaine Phase :** P2 (agents natifs) et P3 (skills/instructions), parallélisables — après validation 👤.
