# AP 006 — Phase 1 : contrat de compatibilité
**Plan :** [006 — Compatibilité Copilot](../006_compatibilite-copilot.plan.md)
**Date de vérification :** 2026-10-13
**Responsable :** 🟠 ARCos ; synthèse persistée par ⚫ MAINa
**Statut :** ❌ BLOQUÉE — phase non complétée
**Prérequis humain :** Gate #1 `GO` le 2026-10-13 ; ADR 005 Acceptée

## Tâches et preuves

| Tâche | Statut | Preuves disponibles | Preuves manquantes |
|---|---|---|---|
| T1.1 — Découverte et schémas par cible | Bloquée | Pages officielles GitHub recoupées ci-dessous ; exclusion racine `.copilotignore` lue (`/dist/`) | Inventaire Git ; versions installées CLI/VS Code/extension ; validation comportementale |
| T1.2 — Invariants et stratégie de projection | Incomplète | Settings effectifs accessibles, template et profils des cinq agents comparés en lecture seule, sans secrets | Enforcement et comportements non vérifiés ; hooks VS Code en preview |

## Matrice documentaire

Vérification des sources officielles le 2026-10-13. « Native » signifie documentée pour la cible, pas validée dans ce dépôt. Les pages ne présentaient généralement pas de date de révision. La matrice des fonctionnalités liste VS Code 1.108.0 comme version récente; ce n'est pas la version installée ici.

| Capacité | Copilot CLI | VS Code | GitHub.com / cloud agent |
|---|---|---|---|
| Agents | Native via `.github/agents/*.agent.md`; découverte directe de `.claude/agents/` non vérifiée. | Native via profils; `.claude/agents/` non vérifié. | Native via `.github/agents/*.agent.md`; `.claude/agents/` non vérifié. |
| Skills | Native; `.claude/skills/` reconnu, chargement selon pertinence. | Native; `.claude/skills/` reconnu, chargement selon pertinence. | Native; `.claude/skills/` reconnu, chargement selon pertinence. |
| Instructions | Native : dépôt, chemin et instructions agent; CLI documente aussi `CLAUDE.md`. | Native : dépôt, chemin et `AGENTS.md`; `CLAUDE.md` non confirmé pour VS Code. | Native : dépôt, chemin et instructions agent; `CLAUDE.md` racine documenté, pas `.claude/CLAUDE.md`. |
| Invocation / subagents | Agents et subagents documentés. | Agents et subagents documentés. | Agents sélectionnables; subagents non supportés sur cette surface. Délégation d'une tâche entière au cloud agent distincte. |
| Modèle et outils | Profil configurable; sans `tools`, tous les outils sont autorisés. Permissions propres au CLI. | `model` et `tools` documentés; équivalence des règles de permissions non établie. | Modèle dépend du plan/mode; outils configurables, préautorisés pendant le job. |
| Hooks | Natif via `.github/hooks/*.json` et config CLI. | Preview dans le cheat sheet; référence technique limitée à CLI et cloud. Exécution non certifiée. | Natif, avec événements/environnement limités; `ask` refusé sans utilisateur. |
| Exclusions | `.copilotignore` non documenté comme mécanisme Copilot. | `.copilotignore` non vérifié; listes d'outils ne prouvent pas les exclusions de chemins. | `.copilotignore` non vérifié; sandbox/hooks ne prouvent pas la préservation des règles du dépôt. |

Les skills chargées selon pertinence ne prouvent pas un préchargement déterministe par agent. Aucune source consultée ne garantit l'arrêt à chaque gate humain. Les timeouts `preToolUse` sont fail-open et ne garantissent donc pas à eux seuls l'application d'une politique.

## T1.2 — Décisions candidates

| Sujet | Décision | Limite / état |
|---|---|---|
| Source et profils | **Conserver** `.claude/` comme source; **adapter** les profils Copilot à leurs schémas/emplacements documentés. | Profils actuels utilisent `model`, `tools`, `skills`; transformation Copilot pas certifiée par inspection seule. |
| MAINa et gates | **Adapter** l'orchestration aux mécanismes par cible; garder les gates humains comme exigence. | `AskUserQuestion` et le texte seul ne prouvent pas le comportement; MAINa a des outils d'édition/Bash à encadrer. |
| ARCos et rôles | **Adapter** les listes d'outils au moindre privilège; ARCos Claude limité à lecture/recherche/web/skills. | Les restrictions Copilot et frontières DEVon/QALvin/DOCly restent à tester. |
| Settings / hooks | **Adapter** séparément par cible; ne pas transposer les hooks Claude comme preuve. | `.claude/settings.json` a `deny`/`ask` et `hooks` vide; le template définit `PreToolUse`. L'overlay local contient des autorisations, dont `Bash(git rm *)`, en tension avec le `ask` du réglage dépôt; priorité effective non vérifiée. |
| Skills / conventions | **Partager** les skills où le format est reconnu; considérer leur chargement comme dynamique. | Préchargement des conventions par rôle et initialisation non testé. |
| Exclusions | **Non vérifié** pour `.copilotignore`; conserver `/dist/` comme invariant sans prétendre Copilot l'applique. | Essai requis pour chaque cible; aucun chemin exclu parcouru. |
| Plans / packaging | **Conserver** comme exigences de processus, pas comme capacité native annoncée. | Scripts et packages non exécutés; inventaire Git absent. |
| Commandes interdites / initialisation | **Conserver** les interdictions comme invariants; **adapter** leur application par cible et vérifier les parcours d'initialisation. | Aucune équivalence Copilot ou résultat d'initialisation démontré. Le conflit `git rm` / `ask` n'a pas été vérifié en runtime. |

## Sources officielles consultées

- [Copilot customization cheat sheet](https://docs.github.com/en/copilot/reference/customization-cheat-sheet) — emplacements et matrice; hooks VS Code en preview.
- [Copilot feature matrix](https://docs.github.com/en/copilot/reference/copilot-feature-matrix) — matrice en public preview; VS Code 1.108.0 listé.
- [Custom agents configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration) — schéma `model`, `tools`, `target`, différences cloud/IDE.
- [About agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills) — emplacements dont `.claude/skills/`, chargement selon pertinence.
- [Adding repository custom instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot) — types et fichiers d'instructions.
- [Support for different types of custom instructions](https://docs.github.com/en/copilot/reference/custom-instructions-support) — matrice par surface.
- [Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference) — configuration et permissions CLI.
- [Copilot hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference) — CLI/cloud, événements, limites et timeouts.
- [Copilot on GitHub.com](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) — cloud agent, modèles et limites.

Le terminal n'est pas disponible : `git ls-files`, versions installées, tests, scripts et `-Check` n'ont pas été exécutés. Aucun outil ne permet d'observer les effets dans les clients Copilot. L'overlay local a été lu en lecture seule sans secrets; le comportement effectif de la permission `git rm` face au `ask` dépôt reste à vérifier. Aucun transfert à DEVon tant que T1.1/T1.2 ne sont pas réglées.

Le `GO` du Gate #1 valide le plan et l'ADR, pas une dérogation aux preuves. Ces sources permettent une stratégie candidate, mais ne certifient aucune parité « 100 % ».

## Handoff

```yaml
handoff:
  plan: "006"
  phase: 1
  agent: "MAINa"
  status: "blocked"
  tasks:
    T1.1:
      status: "blocked"
      evidence:
        - "Neuf pages officielles GitHub recoupées le 2026-10-13; URLs consignées ci-dessus."
        - "Exclusion racine .copilotignore lue: /dist/."
      missing:
        - "Inventaire Git et versions installées des cibles."
        - "Validation comportementale CLI, VS Code et cloud."
    T1.2:
      status: "incomplete"
      evidence:
        - "Profils et settings effectifs/template dépôt comparés en lecture seule, sans secrets."
      missing:
        - "Validation runtime des permissions et frontières de rôle."
        - "Validation des gates, hooks, exclusions et initialization."
  files_written:
    - "docs/plans/006_reports/PHASE_1_COMPLETION_REPORT.md"
    - "docs/plans/006_compatibilite-copilot.plan.md"
  commands: []
  excluded_paths_traversed: []
  risks:
    - "Aucune parité des gardes et gates démontrée par la documentation seule."
    - "Hooks VS Code en preview; référence technique limitée à CLI et cloud."
    - "Permission locale git rm et ask dépôt en conflit apparent; priorité runtime inconnue."
  next_step: "Rétablir un terminal pour inventaire/version; finaliser T1.2 avant Phase 2."
```
