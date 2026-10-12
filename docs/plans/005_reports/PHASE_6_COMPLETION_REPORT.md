# Phase 6 : Copilot généré + docs + anti-dérive outillée

**Plan :** `.claude/plans/005_claude-first.plan.md`
**Responsable Agent :** 🟣 DOCly (T6.2) · 🔵 DEVon (T6.1, T6.3-T6.5)
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — validation 👤 en attente

---

## 📝 Tâches

### T6.1 - Régénérer `.github/`

**Statut :** ✅ DONE (vérif visuelle VS Code à faire par 👤)
- Régénéré à chaque étape ; `-Check` intégré à `check-harness` → exit 0, 0 orphelin.
- Fuites Claude → Copilot corrigées : section maintenance de `CLAUDE.md` (substitution `.claude/`→`.github/` rendait le texte absurde) et ligne `conventions-<rôle>` du tableau des skills, désormais en blocs `claude-only` / `copilot-only`.
- ⚠️ Chargement réel des agents/skills dans VS Code Copilot non vérifié (pas d'accès à l'IDE dans cette session).

### T6.2 - Documentation

**Statut :** ✅ DONE

| Fichier | Changement |
|---|---|
| `.claude/CLAUDE.md` | 299 → **163 lignes** : fiches agents → tableau + lien `agents/README.md`, versions retirées (source unique : corps de l'agent + CHANGELOG), workflow en 6 étapes à gates, commandes, section maintenance |
| `.claude/CLAUDE.template.md` | 319 → **162 lignes** : tableau agents, workflow, lancement, sections projet allégées (conventions détaillées → `conventions-<rôle>`), compact instructions, règles absolues |
| `QUICK_START_CLAUDE.md` | Lancement `claude --agent MAINa` (au lieu de `/plan` + `/agent MAINa`, commandes Copilot) ; avertissement : le **mode plan Claude Code interdit les écritures**, donc la persistance du Plan d'Action ; suivi des gates avec preuves ; checklist `/agents`, `/hooks` |
| `SETUP_CHECKLIST.md` | Réécrit : Claude-first + section Copilot, `/init-harness`, premiers tests (`/agents`, `/hooks`, garde-fou), tableau d'usage |
| `.claude/README.md` | Checklist de maintenance (version unique, `check-harness`) |
| `docs/ARCHITECTURE.md` | Section « Contrôles automatiques », lien diagrammes (m5), historique v5.0 complété |
| `docs/diagrams/*` | `/fleet` et « prompts » remplacés par `/maina`, `/init-harness`, `claude --agent MAINa` |

Écart : pas d'`@imports` dans le template — la doc Claude Code précise qu'ils **ne réduisent pas** le coût de contexte (chargés au lancement) ; l'allègement passe par le déplacement vers les conventions par rôle.

### T6.3 - `check-harness.ps1` + tests du générateur

**Statut :** ✅ DONE — écart : tests sans Pester

- `scripts/check-harness.ps1` : frontmatter agents (champs, modèle, couleur, outils, skills préchargés, pas de version dans la description) ; **version agent = CHANGELOG = `docs/ARCHITECTURE.md`** ; skills (champs, nom = dossier, fork → agent existant, tailles) ; artefacts Copilot dans `.claude/` (`applyTo`, `/fleet`, `.github/` dans agents/skills) hors blocs `copilot-only` ; **liens morts** ; **compteurs « N agents / N skills » ≠ réalité** ; `CLAUDE.md` ≤ 200 l. ; settings JSON + scripts de hook ; `.gitattributes` + absence de CRLF dans les `.sh` ; index des plans ; génération Copilot `-Check`. Inventaire affiché. Fichier en UTF-8 **avec BOM** (sinon PS 5.1 lit `→` en ANSI et la règle CHANGELOG échoue).
- `scripts/tests/sync.tests.ps1` : 31 assertions sur le générateur (tokens, noms de modèles, blocs plateforme inline/bloc, mapping outils, précédence des overrides, champs Claude-only retirés, spec skills, instructions `applyTo`, CRLF). Sans dépendance : Pester local = 3.4 (syntaxe incompatible avec Pester 5 des runners) → script autonome, exit code = échecs.

### T6.4 - GitHub Action

**Statut :** ✅ DONE (première exécution au prochain push)
- `.github/workflows/harness-check.yml` : `windows-latest`, `check-harness` sous PowerShell 5.1, tests du générateur sous PowerShell 7, tests du hook sous bash ; déclencheurs PR, push `main`, manuel ; `permissions: contents: read`.
- Hors périmètre du générateur (non scanné pour les orphelins), maintenu à la main.

### T6.5 - Packaging

**Statut :** ✅ DONE
- `scripts/Package.psm1` (nouveau) : liste déclarative d'éléments, exclusions, ZIP via `ZipArchive` avec entrées en **`/`** (corrige les `\` de `Compress-Archive` sous PS 5.1, illisibles proprement sur macOS/Linux).
- `package-claude.ps1` : livre `CLAUDE.template.md` (au lieu du `CLAUDE.md` du dépôt), `settings.template.json`, `hooks/`, `docs/adr/ADR-TEMPLATE.md`, `docs/diagrams/` ; exclut `SKILL.copilot.md`, `settings.json`, plans.
- `package-github.ps1` : mêmes templates `docs/`, `.github/README.md` ; `.agents/` optionnel.
- Dépendance optionnelle caveman documentée (`scripts/README.md`, en-tête du script).
- `.vscode/tasks.json` : tâche « Check harness » (test par défaut).

---

## 📊 Synthèse de Phase

**Tâches complétées :** 5/5
**Critères de réussite :**
- ✅ `check-harness` : 0 erreur, 0 avertissement (PowerShell 5.1 et 7)
- ⚠️ CI : workflow créé, verte localement à l'identique ; première exécution GitHub au push
- ✅ `CLAUDE.md` : 163 lignes (≤ 200)
- ✅ ZIP complets et portables

**Preuves :**
- `check-harness.ps1` → `0 erreur(s), 0 avertissement(s)` sous `powershell.exe` et `pwsh.exe` ; au premier passage il a détecté 3 dérives réelles (ADR 001 « 4 agents » → ADR exclus comme historique ; « 5 skills » dans `init-harness` ; `.github/` non régénéré).
- **Test de détection** sur une copie du dépôt avec 4 dérives injectées (version DEVon dans ARCHITECTURE, « 9 skills », lien mort, `applyTo` dans un agent) → **5 erreurs, exit 1**.
- `sync.tests.ps1` → 31/31 (PS 5.1 et 7) · `guard.tests.sh` → 55/55.
- ZIP Claude : 41 fichiers, 0 entrée avec `\`, ni `CLAUDE.md` du dépôt ni `SKILL.copilot.md` ; templates CLAUDE/ADR/settings/hooks présents. ZIP Copilot : 38 fichiers, 0 `\`.

**Bloqueurs :** Aucun
**Points d'attention :**
- Dossiers vides non suivis (`.claude/instructions/`, `.claude/prompts/`, `.github/prompts/`, `.github/plans/`) toujours présents sur disque — sans effet (git les ignore).
- Le `README.md` racine reste le profil GitHub de `vzwingma/vzwingma` (choix de dépôt, hors périmètre).

**❓ Questions pour 👤 :** aucune.
**Prochaine phase :** P7 (évaluation : projet fixture + scénarios headless) — après validation 👤.
