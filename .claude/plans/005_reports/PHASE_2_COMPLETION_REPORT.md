# Phase 2 : Agents natifs Claude Code

**Responsable Agent :** 🟠 ARCos (conception, cf. tableau AP 005 T2.1) → 🔵 DEVon (implémentation)
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — validation 👤 en attente

---

## 📝 Tâches

### T2.1 - Frontmatter natif par agent

**Statut :** ✅ DONE

**Fichiers modifiés :** `.claude/agents/{Maina,Arcos,Devon,Qalvin,Docly}.agent.md`

| Agent | Version | model | tools | skills | color |
|---|---|---|---|---|---|
| ⚫ MAINa | v1.4 → **v1.5** | `opus` | AskUserQuestion, Agent, SendMessage, Read, Grep, Glob, Edit, Write, Bash, TodoWrite, Skill | `plan-creation` | cyan |
| 🟠 ARCos | v4.7 → **v4.8** | `opus` + `effort: high` | Read, Grep, Glob, WebFetch, WebSearch, Skill | `adr-writing`, `plan-phase-execution` | orange |
| 🔵 DEVon | v4.3 → **v4.4** | `sonnet` | Read, Edit, Write, Bash, Grep, Glob, TodoWrite, Skill | `plan-phase-execution` | blue |
| 🟢 QALvin | v4.4 → **v4.5** | `sonnet` | Read, Edit, Write, Bash, Grep, Glob, TodoWrite, Skill | `plan-phase-execution` | green |
| 🟣 DOCly | v4.3 → **v4.4** | `sonnet` | Read, Edit, Write, Grep, Glob, Skill | `plan-phase-execution`, `adr-writing` | purple |

- `applyTo` et `agents` (champs Copilot) retirés ; version sortie de la description (ligne `> **Version**` du corps + CHANGELOG).
- Descriptions réécrites, accentuées, orientées routage (quand utiliser, ce que l'agent ne fait pas, déclencheurs).
- `agents:` côté Copilot conservé via `scripts/copilot-mapping.psd1`.

**Écarts vs plan (justifiés) :**
- **ARCos sans `memory: project`** — la doc indique que `memory` active automatiquement Read/Write/Edit → casserait la lecture seule (C1). Historique des décisions = ADR.
- **MAINa garde `Bash`** — en agent principal, ses outils sont ceux de toute la session ; requis pour les preuves de gate et `/code-review` (T5.3). Usage borné par le corps : lecture/preuves, jamais modifier le code.
- **Hooks de frontière de rôle** (DEVon ≠ tests/docs, QALvin ≠ prod, DOCly ≠ code) → reportés en **T4.3** avec les scripts de garde (P4), pour ne pas référencer des scripts inexistants.

### T2.2 - Préchargement des procédures

**Statut :** ✅ DONE (partiel prévu)
- `skills:` en place (voir tableau). Les skills `conventions-<rôle>` n'existent pas encore → préchargement ajouté en **T3.4**.

### T2.3 - Nettoyage des corps

**Statut :** ✅ DONE
- **MAINa** : section « Mode d'exécution » (agent principal, `AskUserQuestion` pour gates, `Agent`/`SendMessage` pour délégation et reprise) en bloc `claude-only` + équivalent `copilot-only` ; gates numérotés #0→#4 ; journal des gates ; questions des sous-agents relayées ; aide via skill `maina-help` (plus de « applyTo »).
- **Sous-agents** : section « Communication » — pas d'échange direct avec 👤 (outil `AskUserQuestion` retiré des sous-agents) → section `❓ Questions pour 👤`, puis arrêt.
- **ARCos** : lecture seule explicite ; point de décision rendu à MAINa ; rapport de phase rendu à MAINa qui l'écrit.
- **DEVon** : « tâches du Plan d'Action (MAINa) » (F-m2 AP 004 enfin corrigé) ; preuve build + lint + tests existants ; relais DOCly après Gate #3 uniquement.
- **QALvin** : séparateur `-- ` retiré (F-m4 AP 004 enfin corrigé) ; relais DOCly après Gate #3.
- **Tous** : pointeur sécurité honnête → `CLAUDE.md` § Règles absolues (au lieu de « skills auto via applyTo ») ; accents rétablis.
- **M10 (parallélisme vs gates stricts)** corrigé aussi dans `.claude/CLAUDE.md`, `CLAUDE.template.md`, `QUICK_START_CLAUDE.md`, `skills/fleet-guide/SKILL.md`.

**Cascade :** `.claude/CHANGELOG.md` (5 entrées), versions dans `.claude/CLAUDE.md`, `CLAUDE.template.md`, `docs/ARCHITECTURE.md` (arbre + table), `.claude/agents/README.md` (table de configuration + lancement MAINa), `.claude/README.md`.

### Correctif tooling (hors tâche)

- `scripts/Sync-Description.psm1` : un bloc `claude-only` **inline** en fin de ligne fusionnait deux lignes côté Copilot. Regex scindée en forme bloc (lignes entières supprimées) et forme inline (span seul). Testé sur 4 cas.

---

## 📊 Synthèse de Phase

**Tâches Complétées :** 3/3 ✅
**Critères de Réussite Atteints :**
- ✅ 0 `applyTo` / `agents:` dans `.claude/agents/`
- ✅ Chaque agent a `tools` + `model` (validation : champs ⊂ champs documentés, couleurs valides, skills préchargés existants, pas de version dans la description)
- ✅ MAINa conçu pour l'agent principal

**Vérifications :**
- `sync-claude-to-github.ps1 -Check` : exit 0 après régénération. `.github/` : 0 fuite `claude-only`/`copilot-only`/`claude --agent`.
- Copilot : frontmatter agents conservé via mapping (model/tools/agents) ; descriptions mises à jour ; section « Mode d'exécution » Copilot-spécifique.
- ⚠️ **Smoke test runtime non effectué** : `claude -p --agent ARCos` → « Failed to authenticate: OAuth session expired » (CLI headless de la machine). À faire par 👤 : `claude --agent MAINa` puis `/agents`.

**Bloqueurs :** Aucun
**Points d'attention :**
- En `claude --agent MAINa`, le corps de MAINa **remplace** le prompt système par défaut de Claude Code (CLAUDE.md reste chargé). Alternative sans remplacement : `/maina` inline (T3.1).
- `/maina` lance encore MAINa en sous-agent (corrigé en T3.1).
- Sections `/fleet` des agents conservées → renommage `parallel-guide` en T3.3.

**Prochaine Phase :** P3 (skills & instructions natifs) — après validation 👤.
