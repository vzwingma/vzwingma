# AP 006 — Phase 2 : corriger source, projection et distribution
**Plan :** [006 — Compatibilité Copilot](../006_compatibilite-copilot.plan.md)
**Date de lancement :** 2026-10-15
**Responsable :** 🔵 DEVon ; synthèse et preuves contrôlées par ⚫ MAINa
**Branche :** `feat/copilot_compat`
**Statut :** ✅ Terminée côté code (2026-10-15, reprise avec terminal) — T2.1, T2.2, T2.3 exécutées et vérifiées ; en attente de la décision 👤 au Gate #2

## Entrées

- Contrat : [rapport Phase 1](PHASE_1_COMPLETION_REPORT.md), section « Revue ARCos de T1.2 » (décisions par champ, R1–R4, stratégie de projection 1–5).
- Décisions 👤 (Gate #1b) : D1 modèles = alias source (`opus` → `claude-opus-5.5`, `sonnet` → `claude-sonnet-5.5`), format CLI validé par un essai ; D3 report des modèles légitimes dans source/mapping, puis régénération.
- Contraintes : DEVon n'écrit ni tests ni documentation ; aucun fichier généré édité à la main ; aucune suppression ; aucun commit ; respect des exclusions (`/dist/`).

## Reprise (GO B, 2026-10-15) — exécution depuis une session avec terminal

Le code de T2.1 est repris tel quel (commit manuel 👤 `9c3b270`). T2.2 et T2.3 et toutes les exécutions ont été faites directement dans la session principale (terminal PowerShell), car les sous-agents n'ont pas de shell. Hors-rôle assumé : la correction `ModelMap`, T2.3 et le rapport ont été écrits par la session principale, pas par DEVon.

### Essai du format `model` (D1) — Copilot CLI 1.0.99-0, `-p --no-ask-user --log-level debug`, dépôt temporaire hors projet

| Valeur du champ `model` | Journal CLI | Résultat |
|---|---|---|
| `claude-opus-5.5` | `Using model "claude-opus-5.5" from custom agent "probe"` | Accepté, utilisé |
| `Claude Opus 5.5 (copilot)` | `Using model "claude-opus-5.5" ... (resolved from "Claude Opus 5.5 (copilot)")` | Accepté, résolu |
| `modele-inexistant-xyz` | Avertissement `not available; using "claude-sonnet-5.5" instead` | **Repli silencieux côté exit code (0)** |

Décision : `ModelMap` = `opus → claude-opus-5.5`, `sonnet → claude-sonnet-5.5` (identifiants de catalogue). Risque pour Phase 3 : un modèle invalide donne un succès (exit 0) avec un autre modèle ; le contrôle `check-harness` impose désormais un identifiant au format catalogue, mais n'interroge pas le catalogue.

### Essai de découverte des skills (R1) — `copilot skill list`, sans appel modèle, dépôt temporaire

La CLI liste `.github/skills/` **et** `.claude/skills/`. Sur un nom présent dans les deux, c'est la description de `.github/skills/` qui est retenue (`dup - DUP-FROM-GITHUB`). Les champs `user-invocable: false` et `disable-model-invocation: true` ne changent pas le listage ; leur effet réel n'est pas observable sans appel modèle.

## Avancement

| Tâche | Statut | Preuves |
|---|---|---|
| T2.1 — Profils et chargement par rôle | ✅ Exécutée | Génération : 5 profils régénérés ; `-Check` : 0 écart ; idempotence : 2e génération `Updated : 0` ; `check-harness` : 0 erreur. |
| T2.2 — Sémantique des skills et gardes | ✅ Décisions consignées, sans code supplémentaire | R1 levé par essai (`.github/skills` prioritaire, variantes `SKILL.copilot.md` utilisées). Rôles : routage `fork` remplacé par variantes `SKILL.copilot.md` (conception existante). Champs écartés (`user-invocable`, `disable-model-invocation`, `context`, `agent`, `background`) : aides d'invocation non vérifiables sans modèle, aucun invariant de gate. **Gardes : aucune garde par hook ajoutée** (`.github/hooks` non prouvé ; le plan exige un retour au Gate #1 pour toute nouvelle cible de hooks). |
| T2.3 — Contrôles et packages | ✅ Exécutée | Voir ci-dessous. |
| Revue automatique code + sécurité | ✅ | Code : 0 bloquant, 4 non bloquants corrigés. Sécurité : 0 vulnérabilité. |

## T2.3 — Implémentation

- **`scripts/Harness-Paths.psm1` (nouveau)** : exclusions appliquées **avant** descente (`**/.git`, `**/node_modules`, `dist`, `.claude/worktrees` + entrées dossier de `.copilotignore`, sémantique gitignore : `/x/` ancré, `x/` à toute profondeur). Les entrées non interprétables (globs, négations, fichiers) sont signalées en avertissement par `check-harness`, jamais supposées appliquées.
- **`scripts/check-harness.ps1`** : parcours via `Get-HarnessFiles` (le checkout externe `.claude/worktrees/gh-cli-install-70f67b` produisait 63 erreurs préexistantes ; désormais 0). Nouveau contrôle de la projection Copilot, **indépendant du générateur** : outils ⊂ `read, search, edit, execute, web, agent, todo` (sensible à la casse) ; `tools` absent ou vide = erreur (Copilot accorderait tous les outils) ; ARCos sans `edit`/`execute`/`agent` ; `agents` réservé à MAINa ; `model` = identifiant de catalogue ; consigne de chargement des skills présente ; « préchargé » interdit ; parité skills `.claude` ↔ `.github`.
- **`scripts/Package.psm1`** : élagage avant récursion ; refus explicite d'écraser une archive existante ; écriture dans un `.partial` puis renommage ; `Assert-HarnessCheck` (nouveau) : `check-harness` bloquant avant tout package ; `scripts/package-{github,claude}.ps1` l'appellent.
- **`.github/workflows/harness-check.yml`** : `actions/checkout` épinglé par SHA de commit (`11bd7190…` = v4.2.2, vérifié via `gh api`).

## Preuves d'exécution

| Contrôle | Commande | Résultat |
|---|---|---|
| Génération | `sync-claude-to-github.ps1` | 5 profils mis à jour ; `AVERTISSEMENT` visibles pour `Skill`, `AskUserQuestion`, `SendMessage` (non projetés, attendu) |
| Rendu à jour | `sync-claude-to-github.ps1 -Check` | `Updated : 0`, `Already in sync : 33`, exit 0 |
| Idempotence | 2e génération | `Updated : 0` |
| Contrôle harnais | `check-harness.ps1` en Windows PowerShell 5.1 **et** pwsh 7 | `0 erreur(s), 0 avertissement(s)`, exit 0 |
| Tests générateur | `scripts/tests/sync.tests.ps1` (5.1 et 7) | 31 passés, 0 échec |
| Tests gardes | `bash scripts/tests/guard.tests.sh` | 54 passés, 0 échec |
| Défaut injecté | `.github/agents/Arcos.agent.md` : `tools: [read, search, web, edit, vscode]` | `check-harness` : 3 erreurs (outil `vscode` hors contrat, ARCos avec `edit`, rendu non synchronisé), exit 1 ; restauré par génération |
| Package GitHub | `package-github.ps1 -OutputDir <tmp> -FileName t1` | 66 fichiers ; 0 entrée `worktrees`, `settings.local`, `dist/`, ni `.github/copilot-instructions.md` du dépôt |
| Package Claude | `package-claude.ps1 …` | 41 fichiers ; mêmes absences |
| Refus d'écrasement | 2e exécution avec le même `-FileName` | `Archive existante, écrasement refusé`, exit 1, aucune archive modifiée |

Profils générés (ARCos en lecture seule, modèles par alias source) :

| Agent | model | tools |
|---|---|---|
| MAINa | `claude-opus-5.5` | `[agent, read, search, edit, execute, todo]` + `agents` |
| ARCos | `claude-opus-5.5` | `[read, search, web]` |
| DEVon | `claude-sonnet-5.5` | `[read, edit, execute, search, todo]` |
| QALvin | `claude-sonnet-5.5` | `[read, edit, execute, search, todo]` |
| DOCly | `claude-sonnet-5.5` | `[read, edit, search]` |

`git diff --stat` (hors commit `9c3b270`, à valider) : `.github/workflows/harness-check.yml` (+1/−1), `scripts/Package.psm1`, `scripts/check-harness.ps1`, `scripts/package-claude.ps1`, `scripts/package-github.ps1`, nouveau `scripts/Harness-Paths.psm1`.

### Revues automatiques (T2.1 + T2.3)

| Revue | Résultat |
|---|---|
| Code (T2.1) | HIGH corrigé : consigne renvoyant à des skills `conventions-*` inexistantes côté Copilot. |
| Code (T2.3) | 0 bloquant ; 4 non bloquants corrigés : `tools` absent non détecté ; comparaisons insensibles à la casse et alias bruts acceptés pour `model` ; `name/` ancré à la racine seulement ; archive partielle bloquant les relances. |
| Sécurité (T2.1 + T2.3) | **0 vulnérabilité** (pas de zip-slip, exclusions respectées, aucun écrasement, SHA épinglé, ARCos en lecture seule). Observation sous seuil : `Get-HarnessFiles` suit les liens symboliques/jonctions. |

## Risques et limites ouverts

- **Non prouvé en Copilot CLI** : hooks `preToolUse`, exclusion `/dist/` par `.copilotignore`, précédence `git rm`, arrêt réel aux gates ; aucune garde déterministe côté Copilot (invariants portés par la prose et les scripts). À observer en Phase 3.
- **Repli de modèle silencieux** (exit 0) : à couvrir en Phase 3 par un scénario dédié.
- **Conventions `conventions-*`** rendues en `.github/instructions/*.template.md` : chargement par consigne explicite uniquement (non prouvé automatique).
- **Champ `agents` de MAINa** : non vérifié pour la CLI, purement informatif.
- **Écart de rôle** : T2.3 et la correction du mapping ont été faites hors DEVon (sous-agent sans shell).
- **Fichiers temporaires à supprimer par 👤** : `%TEMP%\cli-probe-006-model`, `%TEMP%\cli-probe-006-skills`, `%TEMP%\pkg-006-out`, `%TEMP%\pkg-006-out2`, ainsi que les deux répertoires de probes de Phase 1.

```yaml
handoff:
  plan: "006"
  phase: 2
  agent: "session principale (terminal) pour DEVon"
  date: "2026-10-15"
  status: "done"
  files_written:
    - "scripts/Harness-Paths.psm1"
    - "scripts/check-harness.ps1"
    - "scripts/Package.psm1"
    - "scripts/package-github.ps1"
    - "scripts/package-claude.ps1"
    - ".github/workflows/harness-check.yml"
    - "scripts/copilot-mapping.psd1"
    - ".github/agents/*.agent.md (générés)"
  generated_files_touched: [".github/agents/*.agent.md"]
  commands:
    - "sync-claude-to-github.ps1 (-WhatIf, génération, -Check, idempotence)"
    - "check-harness.ps1 (PS 5.1 et 7), sync.tests.ps1 (5.1 et 7), guard.tests.sh"
    - "package-github.ps1, package-claude.ps1 (dossier temporaire)"
    - "copilot --agent probe -p (3 appels modèle), copilot skill list (sans modèle)"
  reviews:
    code: "0 bloquant, 4 non bloquants corrigés"
    security: "0 vulnérabilité"
  risks:
    - "Gardes, exclusion /dist/, git rm, gates non prouvés en CLI"
    - "Repli de modèle silencieux (exit 0)"
  next_step: "Gate #2 : GO → Phase 3 (QALvin)."
```

## Historique — première tentative (bloquée, sans shell)

| Tâche | Statut à l'époque |
|---|---|
| T2.1 | Codée par DEVon, non exécutée |
| T2.2, T2.3 | Non démarrées (exécution impossible) |
| Revue automatique | Faite sur T2.1 : 1 bug HIGH corrigé ; 0 vulnérabilité |

Aucun shell n'était disponible pour DEVon ni pour les exécutants relancés par MAINa (profondeur maximale de sous-agents atteinte). Cet état est dépassé par la section « Reprise » ci-dessus.

## T2.1 — Implémentation (🔵 DEVon, 2026-10-15)

Fichiers modifiés : `scripts/copilot-mapping.psd1`, `scripts/Sync-Description.psm1`. `.claude/agents/*` (source Claude) inchangé ; `.github/agents/*` régénéré depuis la source à la reprise.

- **Mapping** : overrides `model` et `tools` par agent supprimés. `ToolMap` complet selon la stratégie ARCos n° 1. Nouvelle clé `DroppedTools` (`AskUserQuestion`, `SendMessage`, `Skill`) : ces outils sont signalés, jamais émis, et la clé active la dérivation stricte. Le champ `agents` n'est conservé que pour MAINa, à titre informatif : il ne sert jamais de garde.
- **Générateur** : tout nom d'outil non mappé déclenche un `Write-Warning` et n'est pas émis. `skills:` est remplacé par une consigne de chargement explicite en tête de profil Copilot. Les `conventions-*` en sont exclues, avec un renvoi vers `.github/instructions/<role>.instructions.template.md`. « préchargé / préchargée(s) / préchargement » est réécrit côté Copilot uniquement. Un avertissement est émis pour un agent sans `tools` ou avec `disallowedTools` / `permissionMode`.
- **Modèles (D1)** : fixés à la reprise (voir l'essai de format) : `opus → claude-opus-5.5`, `sonnet → claude-sonnet-5.5`.

### Inventaire de dérive (D3)

| Agent | Modèle du rendu édité à la main (avant) | Modèle généré (après) |
|---|---|---|
| MAINa, ARCos | Claude Opus 5.5 (copilot) | `claude-opus-5.5` |
| DEVon | Claude Sonnet 5.5 (copilot) | `claude-sonnet-5.5` |
| QALvin | GPT-5.6 Sol (copilot) | `claude-sonnet-5.5` (écarté par D1) |
| DOCly | GPT-5.6 Luna (copilot) | `claude-sonnet-5.5` (écarté par D1) |

Les outils du rendu édité à la main (`vscode`, `browser`, `vscjava.*`, `sonarsource.*`, `execute/*`, ARCos avec `edit`/`agent`) ont été remplacés par la dérivation.

### Revues automatiques (T2.1, première tentative)

Code : HIGH corrigé (consigne renvoyant à des skills `conventions-*` non projetées ; absence d'alias `opus`, réglée par D1). Sécurité : aucune vulnérabilité ; `description` réécrite telle quelle (un guillemet échappé pourrait casser le YAML : couvert par le contrôle de contrat de `check-harness`).
