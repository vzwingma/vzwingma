# AP 006 — Phase 2 : corriger source, projection et distribution
**Plan :** [006 — Compatibilité Copilot](../006_compatibilite-copilot.plan.md)
**Date de lancement :** 2026-10-15
**Responsable :** 🔵 DEVon ; synthèse et preuves contrôlées par ⚫ MAINa
**Branche :** `feat/copilot_compat`
**Statut :** ⛔ Bloquée (exécution) — T2.1 codée, non exécutée ; Gate #2 non présentable en `GO` (preuves d'exécution manquantes)

## Entrées

- Contrat : [rapport Phase 1](PHASE_1_COMPLETION_REPORT.md), section « Revue ARCos de T1.2 » (décisions par champ, R1–R4, stratégie de projection 1–5).
- Décisions 👤 (Gate #1b) : D1 modèles = alias source (`opus` → `claude-opus-5.5`, `sonnet` → `claude-sonnet-5.5`), format CLI validé par un essai ; D3 report des modèles légitimes dans source/mapping, puis régénération.
- Contraintes : DEVon n'écrit ni tests ni documentation ; aucun fichier généré édité à la main ; aucune suppression ; aucun commit ; respect des exclusions (`/dist/`).

## Avancement

| Tâche | Statut | Preuves |
|---|---|---|
| T2.1 — Profils et chargement par rôle | 🟡 Codée, non exécutée | Relecture + revues automatiques (voir ci-dessous). Ni génération, ni `-Check`, ni tests lancés. |
| T2.2 — Sémantique des skills et gardes | ⏸️ Non démarrée | Exige un test observable (R1) : impossible sans exécution. |
| T2.3 — Contrôles et packages | ⏸️ Non démarrée | Exige l'exécution des scripts : impossible sans exécution. |
| Revue automatique code + sécurité | ✅ Faite sur T2.1 | 1 bug HIGH corrigé ; 0 vulnérabilité. |

## T2.1 — Implémentation (🔵 DEVon, 2026-10-15)

Fichiers modifiés : `scripts/copilot-mapping.psd1`, `scripts/Sync-Description.psm1`. Non modifiés : `.claude/agents/*` (rendu Claude inchangé), fichiers générés (`.github/**`, `QUICK_START_COPILOT.md`), jamais régénérés.

- **Mapping** : overrides `model` et `tools` par agent supprimés. `ToolMap` complet selon la stratégie ARCos n° 1. Nouvelle clé `DroppedTools` (`AskUserQuestion`, `SendMessage`, `Skill`) : ces outils sont signalés, jamais émis, et la clé active la dérivation stricte. Le champ `agents` n'est conservé que pour MAINa, à titre informatif : il ne sert jamais de garde.
- **Générateur** : tout nom d'outil non mappé déclenche un `Write-Warning` et n'est pas émis. `skills:` est remplacé par une consigne de chargement explicite en tête de profil Copilot. Les `conventions-*` en sont exclues, avec un renvoi vers `.github/instructions/<role>.instructions.template.md`. « préchargé / préchargée(s) / préchargement » est réécrit côté Copilot uniquement. Un avertissement est émis pour un agent sans `tools` ou avec `disallowedTools` / `permissionMode`.
- **Outils attendus (déduits du code, non générés)** :

  | Agent | tools |
  |---|---|
  | MAINa | `[agent, read, search, edit, execute, todo]` |
  | ARCos | `[read, search, web]` |
  | DEVon, QALvin | `[read, edit, execute, search, todo]` |
  | DOCly | `[read, edit, search]` |

- **Modèles (D1)** : **non fixés**. `ModelMap.sonnet` garde l'ancienne valeur `Claude Sonnet 4.6 (copilot)`, marquée PENDING. `opus` n'a pas d'entrée, donc MAINa et ARCos n'auraient pas de champ `model`. L'essai de format préalable exigé par D1 n'a pas pu être lancé. **Ne pas régénérer avant de fixer `ModelMap`.**

### Inventaire de dérive (D3) — statique, non mesuré

| Agent | Modèle du rendu actuel (édité à la main) | Classement |
|---|---|---|
| MAINa | Claude Opus 5.5 (copilot) | Légitime (alias `opus`) → `ModelMap.opus` |
| ARCos | Claude Opus 5.5 (copilot) | Légitime (alias `opus`) → `ModelMap.opus` |
| DEVon | Claude Sonnet 5.5 (copilot) | Légitime (alias `sonnet`) → `ModelMap.sonnet` |
| QALvin | GPT-5.6 Sol (copilot) | Non retenu (D1) → alias `sonnet` |
| DOCly | GPT-5.6 Luna (copilot) | Non retenu (D1) → alias `sonnet` |

Les outils du rendu actuel (`vscode`, `browser`, `vscjava.*`, `sonarsource.*`, `execute/*`, ARCos avec `edit`/`agent`) sont tous non conformes ; ils seront remplacés par la dérivation. La dérive des corps n'a pas été mesurée (`-Check` non lancé).

### Revues automatiques

| Revue | Résultat | Suite |
|---|---|---|
| Code | **HIGH** : la consigne imposait de charger des skills `conventions-*` qui ne sont pas projetées comme skills (le sync en fait des `.github/instructions/*.instructions.template.md`). Absence d'alias `opus` → pas de `model`, sans avertissement. Pas de conflit attendu avec `sync.tests.ps1`. | HIGH corrigé par DEVon. `opus` réglé par D1. |
| Sécurité | **Aucune vulnérabilité.** ARCos = `[read, search, web]` ; pas d'injection YAML pouvant élargir `tools` ; aucune suppression. Points faibles non exploitables : `description` réécrite telle quelle (un guillemet échappé pourrait casser le YAML) ; abandon silencieux de `disallowedTools` / `permissionMode`. | Avertissement ajouté pour le second point. Le premier est un risque ouvert pour T2.3/T3.1. |

### Blocage d'exécution

Aucun shell n'est disponible pour DEVon, ni pour les exécutants `general-purpose` / `task` relancés par MAINa : pas d'outil d'exécution, et la profondeur maximale de sous-agents est atteinte. Trois tentatives distinctes, 0 appel modèle consommé, aucun répertoire temporaire créé. Ce qui n'a pas été exécuté : contrôle de syntaxe, essai `model`, `-WhatIf` / `-Check`, génération, idempotence, `sync.tests.ps1`, `check-harness.ps1`, `git diff --stat`.

Risques ouverts : code PowerShell non exécuté (erreur de syntaxe possible) ; les conventions rendues en `.instructions.template.md` ne sont probablement pas chargées automatiquement par la CLI (le chargement repose sur la consigne) ; perte de `Skill` / `AskUserQuestion` / `SendMessage` côté Copilot (R1).

```yaml
handoff:
  plan: "006"
  phase: 2
  agent: "MAINa"
  date: "2026-10-15"
  status: "blocked-execution"
  files_written:
    - "scripts/copilot-mapping.psd1"
    - "scripts/Sync-Description.psm1"
  generated_files_touched: []
  commands: []
  reviews:
    code: "1 HIGH corrigé (conventions-* dans la consigne de skills)"
    security: "aucune vulnérabilité"
  missing:
    - "Essai du format du champ model (D1), puis ModelMap"
    - "Syntaxe, -WhatIf/-Check, génération, idempotence, sync.tests.ps1, check-harness.ps1, git diff --stat"
    - "T2.2 et T2.3"
  next_step: "Décision 👤 sur le mode d'exécution (voir Gate #2)."
```
