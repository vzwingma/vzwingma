# Phase 4 : Garde-fous déterministes

**Plan :** `.claude/plans/005_claude-first.plan.md`
**Responsable Agent :** 🔵 DEVon
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — validation 👤 en attente

---

## 📝 Tâches

### T4.1 - Settings

**Statut :** ✅ DONE

**Fichiers créés :** `.claude/settings.json` (ce dépôt), `.claude/settings.template.json` (distribué, fusionné par `/init-harness`)

| Bloc | Contenu |
|---|---|
| `permissions.deny` — Bash | `rm`, `rmdir`, `git clean`, `git reset --hard`, `git push --force` / `-f`, `git branch -D`, `git stash drop` / `clear`, `git checkout --` |
| `permissions.deny` — PowerShell | `Remove-Item` (alias `rm`, `del`, `rd`… canonicalisés), `git clean`, `git reset --hard`, `git push --force` / `-f` |
| `permissions.deny` — fichiers | `Read`/`Edit` de `.env`, `.env.local`, `.env.*.local` ; dépôt : `dist/**` (depuis `.copilotignore`) |
| `permissions.ask` | `git rm` (suppression récupérable via git → confirmation 👤) |
| `hooks.PreToolUse` | `Bash\|PowerShell\|Edit\|Write\|NotebookEdit` → `bash "${CLAUDE_PROJECT_DIR}/.claude/hooks/guard.sh"` (`shell: bash`, timeout 10 s) |

Choix : `.env.*` non bloqué en bloc pour ne pas interdire `.env.example` (deny prime sur allow, pas d'exception possible).
`PowerShell(git branch -D *)` volontairement absent (règles PowerShell insensibles à la casse → bloquerait `-d`) ; couvert par le hook.

### T4.2 - Hook PreToolUse de garde

**Statut :** ✅ DONE — **écart** : un seul script **bash** au lieu de `guard.ps1` + `.sh`

**Fichier :** `.claude/hooks/guard.sh`

- **Commandes** (Bash/PowerShell) : suppression (`rm`, `rmdir`, `unlink`, `shred`, `del`, `erase`, `Remove-Item`, `Clear-Content`, y compris `sh -c "…"`, `/bin/rm`, `xargs rm`) ; git irréversible (`clean`, `reset --hard|--merge|--keep`, `push --force|-f|--mirror|--delete|+ref|:ref`, `branch -D`, `stash drop|clear`, `checkout --`, `restore` sans `--staged`, `filter-branch`, `reflog expire`, `update-ref -d`, y compris `git -C …`) ; SQL (`DROP TABLE|DATABASE|SCHEMA|VIEW|INDEX`, `TRUNCATE`, `DELETE FROM` sans `WHERE`, `mkfs`, `format X:`) ; mention d'un chemin `.copilotignore` (y compris chemins à antislashs).
- **Écritures** (Edit/Write/NotebookEdit) : fichier listé dans `.copilotignore` (approximation gitignore, sans négation) ; frontières de rôle (T4.3).
- `git rm` laissé à la règle `ask` ; blocage = exit 2 + message (règle, conduite à tenir).

**Raisons de l'écart :**
- Mesures sur ce poste : PowerShell 5.1 ≈ 850 ms / appel, pwsh 7 ≈ 880 ms, bash avec `sed`/`grep` ≈ 800 ms (forks MSYS) → **bash pur** (builtins `[[ =~ ]]`, `read`, aucune substitution de commande) ≈ **230 ms** sous Git Bash, négligeable sur macOS/Linux. Portable bash ≥ 3.2, sans jq.
- Une seule implémentation = une seule logique à maintenir et tester.
- `Read`/`Grep`/`Glob` **non hookés** (fréquence élevée) : couverts par les règles `Read()` statiques (best-effort sur Grep/Glob selon la doc).

### T4.3 - Frontières de rôle

**Statut :** ✅ DONE — **écart** : hook global piloté par config au lieu de hooks dans le frontmatter de chaque agent

**Fichier :** `.claude/hooks/role-boundaries.conf` (format `<agent> <allow|deny> <glob>`)

| Agent | Règle |
|---|---|
| ⚫ MAINa | allow `.claude/plans/*` |
| 🔵 DEVon | deny `*.test.*`, `*.spec.*`, `*__tests__/*`, `docs/*`, `README.md` |
| 🟢 QALvin | allow fichiers de test, `*tests/*`, `*test/*`, `*fixtures/*`, `*__mocks__/*`, `.claude/plans/*` |
| 🟣 DOCly | allow `*.md`, `docs/*`, `.claude/plans/*` |
| 🟠 ARCos | — (lecture seule par ses outils) |

Raison : le hook reçoit `agent_type` (sous-agent **et** session `claude --agent <nom>`) → une seule config lisible et adaptable par projet (`/init-harness`) ; fichiers hors projet (scratchpad) non contrôlés.

### Associés

- **Skills `safety-rules` et `copilotignore` retirés** (`git rm`, Claude + Copilot — prévu T3.3) ; leur contenu (détails SQL/git, non-contournement de `.copilotignore`) fusionné dans `CLAUDE.md` § Règles absolues, désormais aussi présent dans `CLAUDE.template.md` (il en était absent) et donc dans `copilot-instructions*.md`.
- `.gitattributes` créé : `*.sh` et `.claude/hooks/*.conf` en LF (bash refuse CRLF ; dépôt en `core.autocrlf=true`).
- `init-harness` : étape « Garde-fous » (fusion settings, `.copilotignore` → `Read()`/`Edit()` deny, adaptation `role-boundaries.conf`, `.gitattributes`, prérequis bash).
- `package-claude.ps1` : livre `.claude/hooks/` et `settings.template.json`.
- Docs : `CLAUDE.md`, `CLAUDE.template.md`, `docs/ARCHITECTURE.md` (section « Garde-fous déterministes »), `.claude/README.md`, `agents/README.md`, `scripts/README.md`, `QUICK_START_CLAUDE.md` — mentions `hooks/`/`settings` en blocs `claude-only` (Copilot n'a pas d'équivalent).

---

## 📊 Synthèse de Phase

**Tâches complétées :** 3/3
**Critères de réussite :**
- ✅ Blocages `rm -rf`, `git reset --hard`, `git clean`, écriture `dist/**` démontrés par tests du hook
- ⚠️ Refus « en session réelle » non démontré dans cette session (voir ci-dessous)

**Preuves :**
- `bash scripts/tests/guard.tests.sh` → **54 passed, 0 failed** : 22 commandes destructives bloquées (dont `sh -c`, `/bin/rm`, `git -C . reset --hard`, `push origin :branch`, SQL), 10 commandes saines autorisées (dont `git rm`, `branch -d`, `restore --staged`, `docker run --rm`, `DELETE … WHERE`), `.copilotignore` en écriture, 16 cas de frontières de rôle, chemins Windows (`C:\…`).
- Appel réel via Git Bash avec `CLAUDE_PROJECT_DIR` au format Windows : blocage exit 2 + message ; commande saine exit 0.
- `settings.json` / `settings.template.json` : JSON valides (schéma schemastore non téléchargeable via le proxy).
- `git check-attr eol` : `lf` pour les scripts bash.
- `package-claude.ps1` : ZIP contient `.claude/hooks/guard.sh`, `role-boundaries.conf`, `settings.template.json`.
- `sync-claude-to-github.ps1 -Check` : exit 0, 0 orphelin ; aucune mention `hooks/`/`settings` côté `.github/`.

**Non vérifié — à faire par 👤 après redémarrage de session** (les settings projet sont lus au démarrage ;
test ici : `rm -f` sur fichier inexistant **non bloqué**, la session ayant démarré avant la création de
`settings.json` ; CLI headless non authentifiée) :

```bash
claude
```
puis demander : `lance rm -f /tmp/inexistant` (refus attendu par règle deny),
`lance sh -c "rm -f /tmp/inexistant"` (refus attendu par le hook), et `/devon` sur une tâche touchant un
`*.test.*` (refus attendu par frontière de rôle). Vérifier aussi `/hooks` (hook listé).

**Bloqueurs :** Aucun
**Points d'attention :**
- Faux positifs possibles du hook : commande contenant `dist/` dans une URL, `npm rm` (désinstallation) → bloqués avec message explicite.
- Hook en échec (bash absent, timeout) → non bloquant ; les règles `deny` restent actives.
- ZIP créés par `Compress-Archive` (PS 5.1) avec séparateurs `\` → à vérifier en P6 (T6.5) pour les consommateurs macOS/Linux.

**❓ Questions pour 👤 :** aucune.
**Prochaine phase :** P5 (workflow strict fiabilisé : protocole de gate, revue pré-Gate #2, contrat de handoff) — après validation 👤.
