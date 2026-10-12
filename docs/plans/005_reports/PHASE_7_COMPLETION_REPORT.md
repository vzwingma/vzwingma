# Phase 7 : Évaluation du harnais

**Plan :** `.claude/plans/005_claude-first.plan.md`
**Responsable Agent :** 🟢 QALvin (T7.1, T7.2) · 🟣 DOCly (T7.3)
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — exécution réelle des scénarios en attente (CLI non authentifiée) ; validation 👤 en attente

---

## 📝 Tâches

### T7.1 - Projet fixture

**Statut :** ✅ DONE

`tests/fixtures/sample-app/`
- `app/` : projet Node.js sans dépendance (`src/math.js` + `src/math.test.js` en `node:test`, `package.json`
  avec `test` / `lint`, `docs/ARCHITECTURE.md`, `README.md`), `.copilotignore` (`/secrets/`) et
  `secrets/api-key.txt` contenant une valeur **factice** (`FAKE-SECRET-123`).
- `harness-overrides/skills/conventions-{dev,qa}/` : conventions **remplies** pour le fixture (montre un
  template instancié : commandes réelles, seuil de couverture, cas à couvrir).
- Preuve : `node --test` → 2 passed, 0 failed ; `node --check src/math.js` → OK.

### T7.2 - Scénarios headless

**Statut :** ✅ DONE (écrits et validés à vide) — ⚠️ **exécution réelle non faite** : `claude -p` →
« Failed to authenticate: OAuth session expired and could not be refreshed »

`scripts/tests/eval-scenarios.ps1`
- Par scénario : workdir jetable `%TEMP%\harness-eval-<horodatage>\<scénario>` = fixture + harnais installé
  depuis `.claude/` (agents, skills sans variantes Copilot, hooks, `settings.json` issu du template +
  `deny secrets/**`, `CLAUDE.md` depuis le template, index des plans) + dépôt git initialisé.
- Appels `claude -p` plafonnés (`--max-budget-usd`, défaut 1,50 $), assertions sur la réponse **et** sur
  l'état des fichiers (empreintes SHA-256), logs conservés, workdirs jamais supprimés.
- Scénarios : S1 `/maina-help` · S2 MAINa Gate #0 (≥ 2 options, code intact) puis, après `GO`
  (`--continue`), plan + index + journal créés et arrêt au Gate #1 · S3 ARCos lecture seule · S4 DEVon
  bloqué sur fichier de test · S5 `sh -c 'rm -f …'` bloqué · S6 secret `.copilotignore` jamais divulgué.
- Pré-contrôle d'authentification : exit 2 + consigne si la CLI n'est pas connectée (vérifié).
- Compatibilité Windows PowerShell 5.1 : appels natifs encapsulés (stderr natif fatal sous `Stop`), BOM UTF-8.

**Preuves (sans appel modèle) :**
- `-DryRun` → 6 workdirs préparés, exit 0 ; inspection S4 : 18 skills, aucune variante Copilot, deny
  `Read/Edit(./secrets/**)` ajoutés, `conventions-dev` remplie, commit git `fixture`.
- Hook du workdir S4, entrée « DEVon édite `src/math.test.js` » → **exit 2** (« frontière de rôle : `*.test.*` »).
- Exécution sans authentification → exit 2, message explicite, aucun appel lancé.

### T7.3 - Routine de maintenance

**Statut :** ✅ DONE
- `scripts/README.md` : section « Routine avant release ZIP » (sync → `check-harness` → tests générateur →
  tests hook → scénarios → packages) + `/doctor prompt-audit` en session.
- `docs/ARCHITECTURE.md` : fixture dans l'arborescence, scénarios et routine dans « Contrôles automatiques ».

---

## 🔎 Constat nouveau — `.claude/` est un chemin protégé

Doc Claude Code (« Protected paths ») : les écritures dans `.claude/` (hors `.claude/worktrees/` et fichiers de
plan de session) ne sont **jamais auto-approuvées** — confirmation en `default` / `acceptEdits`, refus en
`dontAsk` et en `-p`, et une règle `allow` (ex. `Edit(.claude/plans/**)`) **ne les pré-approuve pas**. Seuls
`bypassPermissions` ou l'option interactive « autoriser l'édition de `.claude` pour la session » les lèvent.

Conséquences :
- Chaque écriture de Plan d'Action, rapport de phase ou index (`.claude/plans/`) déclenche une confirmation
  — y compris pour DEVon / QALvin / DOCly (prompts relayés depuis les sous-agents).
- Automatisation headless de la création de plan impossible sans `bypassPermissions` (d'où son usage, limité
  au workdir jetable, dans S2 étape 2).

Options (décision 👤, ADR 004 si changement) :

| Critère | A — Garder `.claude/plans/` | B — Déplacer vers `docs/plans/` |
|---|---|---|
| Avantages | Aucun changement ; plans séparés de la doc projet | Aucune confirmation par écriture ; plans visibles et versionnés avec la doc ; headless possible en `acceptEdits` |
| Inconvénients | Confirmation à chaque écriture (atténuée par l'option « pour la session ») | Migration : skills, agents, `role-boundaries.conf`, `check-harness`, scénarios, docs, Copilot généré |
| Effort | Nul | Moyen |

Recommandation : **B**, la confirmation répétée allant à l'encontre d'un workflow où chaque phase écrit son rapport.

---

## 📊 Synthèse de Phase

**Tâches complétées :** 3/3
**Critères de réussite :**
- ⚠️ « Scénarios headless verts » : scénarios prêts et validés à vide ; exécution réelle à lancer par 👤

**Bloqueurs :** authentification de la CLI headless sur ce poste.

**❓ Questions pour 👤 :**
1. Emplacement des Plans d'Action : **A** (garder `.claude/plans/`) ou **B** (migrer vers `docs/plans/`, ADR 004) ?
2. Ouvrir une PR de la branche vers `main` pour déclencher la CI (`harness-check.yml` ne tourne que sur PR / push `main`) ?
3. Lancer les scénarios après `claude` (reconnexion) : `powershell -NoProfile -File scripts/tests/eval-scenarios.ps1` (≈ 7 appels, ≤ 1,50 $ chacun).

**Prochaine étape :** Gate de clôture de l'AP 005 après réponses 👤.
