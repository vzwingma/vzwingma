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

## Nouvelle tentative — 2026-10-15

Relance de l'exécution du plan (T1.1 et T1.2 non complétées) :

| Démarche | Résultat | Preuve obtenue |
|---|---|---|
| Inventaire Git (`git ls-files`, `git status`, existences, versions CLI/VS Code/Git/gh/pwsh) | Bloqué : agent d'exécution sans shell exposé dans la session | Aucune |
| Revérification des 9 pages officielles (questions Q1–Q9 : découverte `.claude/agents/` et `.claude/skills/`, `CLAUDE.md`, `.copilotignore`, hooks, `tools`/`model`, subagents, versions) | Bloqué : aucun outil web opérationnel ; délégation de recherche refusée (profondeur maximale de sous-agents atteinte) | Aucune |

Conséquences :
- Les réponses Q1–Q9 restent **non vérifiées** ; la matrice documentaire ci-dessus repose sur la vérification du 2026-10-13 et n'est pas revalidée.
- Aucune ligne de la matrice ne passe de « non vérifié » à « native » ; aucun fichier source, projection ou règle n'a été modifié.
- Phase 1 reste **❌ BLOQUÉE**. Phase 2 ne peut pas démarrer : elle dépend d'un contrat vérifié.
- Déblocage requis (une des options) : session avec terminal PowerShell/Git et accès web (`curl`/`gh` ou navigateur), ou validation 👤 d'un `AJUSTER` au Gate #1 réduisant le périmètre de compatibilité annoncé.

```yaml
handoff:
  plan: "006"
  phase: 1
  agent: "MAINa"
  date: "2026-10-15"
  status: "blocked"
  tasks:
    T1.1:
      status: "blocked"
      evidence: []
      missing:
        - "Inventaire Git, versions installées, validation comportementale CLI/VS Code/cloud."
    T1.2:
      status: "incomplete"
      evidence: []
      missing:
        - "Revalidation des sources officielles ; validation runtime des permissions, gates, hooks et exclusions."
  files_written:
    - "docs/plans/006_reports/PHASE_1_COMPLETION_REPORT.md"
  commands: []
  excluded_paths_traversed: []
  next_step: "Terminal et accès web requis, ou AJUSTER au Gate #1 pour réduire le périmètre."
```

## Relance 2 — 2026-10-15 : terminal et accès web obtenus

Preuves obtenues via terminal (agent `general-purpose`) et `curl.exe` (HTTP 200 sur les 9 URLs de la matrice documentaire ; aucune date de révision affichée sur ces pages).

### Inventaire Git (lecture seule)

- Branche `main-ai` ; `git status` : 1 fichier modifié (ce rapport).
- `git ls-files` : 139 fichiers suivis — `.claude/` 41, `docs/` 35 (dont `docs/plans/` 24), `.github/` 33, `scripts/` 11, `tests/` 9, `.vscode/` 1, racine 9.
- `.claude/agents/` : Arcos, Devon, Docly, Maina, Qalvin + README. `.claude/skills/` : 25 fichiers SKILL/SKILL.copilot + 3 templates.
- `.github/agents/` : mêmes 5 agents + README. `.github/skills/` : 14 SKILL.md + 3 templates, sans `SKILL.copilot.md`. `.github/hooks/` : absent.
- Existence : `.copilotignore` oui ; `.github/copilot-instructions.md` oui ; `CLAUDE.md` racine non (seulement `.claude/CLAUDE.md`) ; `AGENTS.md` non ; `.claude/settings.json` et `settings.template.json` oui ; `.agents/` présent sur disque, 0 fichier suivi.
- `.copilotignore` : motif `/dist/`, aucun fichier suivi correspondant.

### Versions installées

Git 2.45.2 ; gh 2.102.0 ; PowerShell 7.6.6 ; VS Code 1.136.2 ; Copilot CLI 1.0.97-2.

### Réponses documentaires Q1–Q9 (sources officielles, 2026-10-15)

| Q | Réponse | Cible | Source (U1 à U9 = pages du plan) |
|---|---|---|---|
| Q1a `.claude/agents/` lu par CLI | **NON DOCUMENTÉ** | CLI | Absent de U1, U3, U7 |
| Q1b `.github/agents/` lu par CLI | **OUI** | CLI | U1 : `.github/agents/AGENT-NAME.md` |
| Q2a Skills `.claude/skills/` reconnus | **OUI** | CLI, VS Code, cloud | U4 : « load when relevant » |
| Q2b Chargement déterministe par agent | **NON** | tous | U4 : chargement selon pertinence |
| Q3a VS Code lit `AGENTS.md` | **OUI** | VS Code Chat | U6 |
| Q3b VS Code lit `CLAUDE.md` racine | **NON DOCUMENTÉ** | VS Code Chat | U6 ne liste que AGENTS.md |
| Q3c VS Code lit `.claude/CLAUDE.md` | **NON DOCUMENTÉ** | VS Code | Absent de U5, U6 |
| Q4a Cloud lit `CLAUDE.md` racine | **OUI** | cloud agent | U6 : AGENTS.md, CLAUDE.md, GEMINI.md |
| Q4b Cloud lit `.claude/CLAUDE.md` | **NON DOCUMENTÉ** | cloud agent | Absent de U6, U9 |
| Q5 `.copilotignore` | **NON DOCUMENTÉ** | CLI, VS Code, cloud | Aucune occurrence dans U1 à U9 |
| Q6a Chemin hooks | **OUI** | CLI, dépôt | U8 : `.github/hooks/*.json`, `~/.copilot/settings.json` |
| Q6b Statut hooks VS Code | **PREVIEW (déduit)** | VS Code | Légende « P » de U1 ; non écrit dans U8 |
| Q6c `preToolUse` en erreur | **FAIL-CLOSED** | CLI, cloud | U8 : « Denied by preToolUse hook (hook errored) » |
| Q6d `preToolUse` en timeout | **FAIL-OPEN** | CLI, cloud | U8 : timeout 30 s |
| Q6e `preToolUse` HTTP en erreur | **FAIL-OPEN** | hook HTTP | U8 (paraphrase) |
| Q6f Événements | **OUI** | hooks | U8 : SessionStart, PreToolUse, PostToolUse, SubagentStart, SubagentStop… |
| Q7a Champ `tools` | **OUI** | agents custom | U3 : absent = tous les outils ; `tools: []` = aucun |
| Q7b Champ `model` | **NON DOCUMENTÉ** (liste de valeurs) | agents custom | U3 : hérite du modèle par défaut si absent |
| Q8a Subagents VS Code | **OUI** | VS Code | U1 |
| Q8b Subagents CLI | **OUI** | CLI | U1, U7 : `subagents.maxDepth`, `subagents.maxConcurrency` |
| Q8c Subagents cloud | **NON** (cheat sheet) | cloud | U1 : colonne GitHub.com ✗ ; U9 silencieux |
| Q9a Versions VS Code | VS Code 1.97 à 1.108 listées | VS Code | U2 |
| Q9b Version Copilot CLI | **NON DOCUMENTÉ** | CLI | Aucune version dans U2 |

### Conséquences pour le contrat

- **Agents** : `.claude/agents/` n'est pas documenté pour Copilot CLI. La projection doit rester dans `.github/agents/` ; ne rien annoncer sur `.claude/agents/`.
- **Skills** : `.claude/skills/` est reconnu, mais le chargement est dynamique. Aucune garantie de préchargement par rôle.
- **Instructions** : `CLAUDE.md` n'est documenté que pour le cloud agent (racine uniquement). VS Code lit `AGENTS.md`, absent du dépôt.
- **Exclusions** : `.copilotignore` n'est documenté par aucune des trois cibles. L'invariant `/dist/` n'est donc pas garanti par Copilot.
- **Gardes** : les hooks `preToolUse` sont fail-open sur timeout. Une garde ne peut pas être présentée comme bloquante sans test.
- **Hooks VS Code** : statut preview, non confirmé par la page dédiée.

### Non vérifiable (reste bloquant)

- Dates de révision des pages : absentes.
- Version de Copilot CLI documentée : absente.
- Comportement réel (exécution dans CLI, VS Code, cloud) : non testé. La documentation ne suffit pas pour certifier un invariant.
- Valeurs de `model` : non documentées.

### Statut

- **T1.1** : documentaire complété (matrice vérifiée sur sources officielles). Validation comportementale toujours manquante.
- **T1.2** : incomplète. Les décisions candidates sont confirmées partiellement ; l'enforcement et les hooks restent à tester.
- **Phase 1** : toujours non close. Le contrat ne peut pas certifier la parité sans scénarios observables (Phase 3). Décision 👤 requise : `AJUSTER` au Gate #1 pour restreindre le périmètre (par exemple CLI seul, sans garantie sur `.copilotignore` ni sur les hooks VS Code), ou accepter la matrice documentaire comme contrat candidat et reporter la validation comportementale.

```yaml
handoff:
  plan: "006"
  phase: 1
  agent: "MAINa"
  date: "2026-10-15"
  status: "partial"
  tasks:
    T1.1:
      status: "partial"
      evidence:
        - "git ls-files : 139 fichiers ; versions Git/gh/pwsh/VS Code/Copilot CLI relevées."
        - "Q1–Q9 vérifiées sur U1–U9 (HTTP 200), citations consignées."
      missing:
        - "Validation comportementale CLI, VS Code et cloud."
        - "Dates de révision et version Copilot CLI documentée."
    T1.2:
      status: "incomplete"
      evidence:
        - "Décisions candidates confirmées par la documentation (agents, skills, hooks, exclusions)."
      missing:
        - "Enforcement des exclusions et gardes ; statut preview des hooks VS Code."
  files_written:
    - "docs/plans/006_reports/PHASE_1_COMPLETION_REPORT.md"
  commands:
    - "git rev-parse, git branch, git status, git ls-files, Test-Path, versions CLI (sous-agent general-purpose)"
    - "curl.exe sur U1 à U9 (HTTP 200)"
  excluded_paths_traversed: []
  next_step: "Décision 👤 au Gate #1 : AJUSTER (périmètre réduit) ou validation de la matrice documentaire avec tests comportementaux reportés en Phase 3."
```

## Décision Gate #1 — AJUSTER (2026-10-15)

- Décision 👤 : **AJUSTER**, cible unique **GitHub Copilot CLI** (version relevée : 1.0.97-2).
- VS Code et cloud agent : hors périmètre. Leurs constats (hooks VS Code en preview, `CLAUDE.md` cloud, subagents cloud) ne sont pas à certifier.
- Reste à faire pour Phase 1 (CLI) : validation comportementale des points suivants, qui n'ont pas été testés dans le client :
  - chargement effectif des agents `.github/agents/*.agent.md` et des skills `.claude/skills/` ;
  - comportement réel de `preToolUse` (hooks `.github/hooks/*.json`, fail-open sur timeout) ;
  - exclusion `/dist/` : `.copilotignore` non documenté pour CLI, donc à traiter comme non garanti ;
  - permission `git rm` face au `ask` du dépôt (conflit non vérifié).
- Limite : la validation comportementale nécessite de lancer le client CLI sur le dépôt. Si l'environnement ne le permet pas, Phase 1 reste partielle et le contrat CLI est candidat, pas certifié.

## Validation comportementale CLI — sans appel modèle (2026-10-15)

Client : GitHub Copilot CLI 1.0.97-2. Aucun prompt envoyé au modèle, aucun fichier du dépôt modifié, aucun secret lu.

| Point | Méthode | Résultat | Statut |
|---|---|---|---|
| (a) Agents `.github/agents/*.agent.md` | `copilot --help`, `copilot help agent` | Pas de sous-commande de listage (`help agent` : sujet inconnu, exit 1). Visibles seulement via `/agent` interactif. | NON VÉRIFIABLE SANS MODÈLE |
| (b) Skills `.claude/skills/` | `copilot skill list` | 18 skills projet reconnus (maina, arcos, devon, qalvin, docly, …). `.github/skills/` absent de la liste, cause non identifiée. | VALIDÉ pour `.claude/skills/` ; ÉCART pour `.github/skills/` |
| (c) Hooks `.github/hooks/*.json` | `Test-Path`, `copilot help config` | Dossier `.github/hooks/` absent. La config documente une clé `hooks` inline (même schéma) et `disableAllHooks`. Exécution non testable. | ÉCHEC de présence ; comportement NON VÉRIFIABLE SANS MODÈLE |
| (d) Exclusion `/dist/` via `.copilotignore` | `copilot help ignore` | Sujet inexistant (exit 1). Aucun moyen non-modèle. | NON APPLICABLE (non garanti) |
| (e) `git rm` : allow local vs ask dépôt | Lecture des clés seulement | Overlay local : `allow` contient `Bash(git rm`. Dépôt `.claude/settings.json` : `ask` contient `git rm`. Précédence non documentée. | NON VÉRIFIABLE SANS MODÈLE (statique) |

Commandes : `copilot --version`, `--help`, `help config`, `skill --help`, `plugin --help`, `lsp --help`, `help permissions`, `help commands`, `skill list`, `plugin list` (exit 0) ; `help agent`, `help hooks`, `help ignore` (exit 1). `git status --short` vide.

Conséquences pour le contrat CLI :
- Skills `.claude/skills/` : validés comme reconnus par la CLI.
- `.github/skills/` : non listés par la CLI ; ne pas s'appuyer dessus tant que la cause n'est pas identifiée. Hypothèse à tester en Phase 2.
- Hooks : aucune garde de sécurité ne doit être annoncée comme active. Le dossier `.github/hooks/` n'existe pas encore.
- Exclusion `/dist/` et précédence `git rm` : non garanties ; à traiter comme risques.

```yaml
handoff:
  plan: "006"
  phase: 1
  agent: "MAINa"
  date: "2026-10-15"
  status: "partial"
  evidence:
    - "copilot skill list : 18 skills .claude/skills reconnus"
    - ".github/hooks absent ; aucun appel modèle"
    - "git status --short vide"
  missing:
    - "Listage agents (a) et exécution hooks (c) sans modèle"
    - "Précédence allow local vs ask dépôt (e)"
    - "Exclusion /dist/ (d)"
    - "Cause de l'absence de .github/skills dans copilot skill list"
  next_step: "Gate #2 de Phase 1 : décider d'accepter la validation partielle (limites explicites) ou d'autoriser des tests avec appel modèle pour (a), (c), (e)."
```

## Gate #2 Phase 1 — tests CLI avec appels modèle (2026-10-15)

Décision 👤 : **GO** sur la validation, avec autorisation explicite des appels modèle. Résultats (Copilot CLI 1.0.97-2, 7 appels modèle, dépôt réel inchangé) :

| Point | Commande | Code | Observation | Statut |
|---|---|---|---|---|
| (a) MAINa | `copilot --agent MAINa -p "..."` | 0 | Répond en orchestrateur MAINa | VALIDÉ (contrôle sans `--agent` : réponse générique) |
| (a) ARCos | `copilot --agent ARCos -p "..."` | 0 | Répond « architecte en lecture seule » | VALIDÉ (idem) |
| (a) DEVon, QALvin, DOCly | non testés | — | — | NON TESTÉ |
| (c) hook `preToolUse` (OK) | `copilot -p "... echo hello-probe"` dans un dépôt temporaire avec `.github/hooks/probe.json` | 0 | Commande exécutée ; journal du hook absent | NON CONCLUANT : hook probablement non chargé, schéma non confirmé sur 1.0.97-2 |
| (c) hook en erreur | non effectué | — | — | NON CONCLUANT (dépend du point précédent) |
| (e) `git rm --dry-run` (dépôt réel) | `copilot -p "..."` sans drapeau d'allow | 0 | « Denied, no one to approve » | NON CONCLUANT : défaut non interactif, pas le conflit allow local / ask dépôt |
| (e) `git rm dummy.txt` (temporaire) | idem | 0 | Refusé ; fichier intact | NON CONCLUANT (idem) |

Points à noter :
- Le sous-agent a signalé une branche courante `feat/copilot_compat` alors que ce plan indique `main-ai`. À vérifier avant tout commit.
- Les agents déclarent le modèle `Claude Sonnet 4.6`, indisponible : la CLI bascule sur `claude-sonnet-5.5`. Effet sur la fidélité du comportement à vérifier en Phase 3.
- Dépôt réel : état git inchangé par les tests (les 3 fichiers modifiés sont ceux de cette session).
- Répertoire temporaire créé, non supprimé (règle : aucun agent ne supprime de fichier) : `C:\Users\vzwingma\AppData\Local\Temp\cli-probe-006-20261015-163434`. À supprimer par 👤.

Conclusion : Phase 1 reste **partielle**. Seul le chargement de MAINa et ARCos est prouvé. Les hooks et la précédence `git rm` ne sont pas tranchés en mode non interactif. Ces points ne peuvent pas être certifiés sans session interactive.

```yaml
handoff:
  plan: "006"
  phase: 1
  agent: "MAINa"
  date: "2026-10-15"
  gate: "#2 GO avec appels modèle autorisés"
  status: "partial"
  evidence:
    - "copilot --agent MAINa et ARCos : chargement vérifié par contrôle"
    - "dépôt réel inchangé"
  missing:
    - "Chargement DEVon, QALvin, DOCly"
    - "Schéma et exécution des hooks preToolUse (fail-open / fail-closed)"
    - "Précédence allow local vs ask dépôt pour git rm"
  risks:
    - "Hooks possiblement inactifs : aucune garde ne doit être annoncée"
    - "Modèle de remplacement claude-sonnet-5.5 au lieu de Sonnet 4.6"
    - "Branche relevée feat/copilot_compat : écart à vérifier"
  next_step: "Décision 👤 : accepter les limites (contrat CLI candidat, hooks et git rm non garantis) ou organiser un test en session CLI interactive pour hooks et git rm."
```

## Décision 👤 — test interactif (2026-10-15)

Choix 👤 : **option 2**, test des hooks et de `git rm` en session CLI interactive lancée par 👤. Aucune session interactive n'est pilotée par un agent. Protocole à exécuter par 👤 :

1. **Hooks (dépôt temporaire, jamais le dépôt réel)** : créer `.github/hooks/probe.json` avec un hook `preToolUse` qui ajoute une ligne horodatée à `probe.log` (schéma : `copilot help config`). Lancer `copilot` en interactif dans ce dépôt, demander `echo hello-probe`. Consigner : `probe.log` présent ou non, et si l'outil s'exécute.
2. **Hooks en erreur** : même dépôt, hook qui retourne `exit 1`. Consigner : l'outil est-il bloqué (fail-closed) ou exécuté (fail-open) ?
3. **`git rm` (dépôt réel en lecture)** : session interactive, demander `git rm --dry-run docs/plans/README.md`. Consigner la question d'approbation, la règle invoquée si affichée, et la décision prise. Ne pas choisir « toujours autoriser » (cela modifie la configuration).
4. **`git rm` (dépôt temporaire)** : demander `git rm dummy.txt`, répondre « non ». Vérifier que `dummy.txt` est intact.

Résultat à transmettre à MAINa : pour chaque point, observation brute (≤ 5 lignes) et statut VALIDÉ / ÉCHEC / NON CONCLUANT. Phase 1 ne passera à `complete` qu'après ce résultat ou une acceptation explicite des limites.

Répertoire temporaire à supprimer par 👤 : `C:\Users\vzwingma\AppData\Local\Temp\cli-probe-006-20261015-163434`.

### Résultats des probes (validation 👤 « toutes les actions sont validées », mode `-p --no-ask-user`)

Copilot CLI relevé : **1.0.99-0** (la note précédente indiquait 1.0.97-2 : écart à traiter).

| Point | Commande | Observation brute | Statut |
|---|---|---|---|
| 1. Hook `preToolUse` nominal | `copilot -p "... echo hello-probe" --allow-tool "shell(echo)" --no-ask-user` (dépôt temporaire, puis `--log-level debug`) | `hello-probe` affiché, outil exécuté. `probe.log` absent. Log debug sans trace de chargement ou d'exécution du hook. | NON CONCLUANT |
| 2. Hook en erreur (`exit 1`) | même commande, copie `cli-probe-006-fail` | `hello-probe` affiché, aucun message d'erreur de hook, `probe.log` absent. | NON CONCLUANT : fail-open / fail-closed non démontré |
| 3. `git rm --dry-run docs/plans/README.md` (dépôt réel) | `copilot -p ... --no-ask-user` | Permission refusée automatiquement (« no interactive user response »), commande non exécutée. `git status --short` identique avant / après (3 fichiers M préexistants). | VALIDÉ (refus observé) |
| 4. `git rm dummy.txt` (dépôt temporaire) | `copilot -p ... --no-ask-user`, sans `--allow-tool` | Refus « Denied, no one to approve ». `dummy.txt` présent (7 octets). | VALIDÉ (refus observé) |

Note de représentativité : **partielle**. Le refus en `-p --no-ask-user` est cohérent avec le mode interactif, mais les hooks n'ont été observés dans aucun run `-p`. Le comportement des hooks reste à confirmer en session interactive.

Copie `C:\Users\vzwingma\AppData\Local\Temp\cli-probe-006-fail` créée, non supprimée. À supprimer par 👤 avec le dossier `cli-probe-006-20261015-163434`.

```yaml
handoff:
  plan: "006"
  phase: 1
  agent: "MAINa"
  date: "2026-10-15"
  gate: "#2 GO avec appels modèle autorisés ; probes validés"
  status: "partial"
  evidence:
    - "git rm refusé en dépôt réel (dry-run) et en dépôt temporaire, dépôt réel inchangé"
    - "copilot --agent MAINa et ARCos : chargement vérifié par contrôle"
  missing:
    - "Exécution des hooks preToolUse (points 1 et 2 non concluants en -p)"
    - "Chargement DEVon, QALvin, DOCly"
    - "Précédence allow local vs ask dépôt pour git rm"
  risks:
    - "Hooks possiblement inactifs : aucune garde ne doit être annoncée"
    - "Version CLI 1.0.99-0 relevée, différente de 1.0.97-2 consignée précédemment"
    - "Modèle de remplacement claude-sonnet-5.5 au lieu de Sonnet 4.6"
    - "Branche relevée feat/copilot_compat : écart à vérifier"
  next_step: "Décision 👤 : accepter les limites (hooks non garantis, git rm refusé par défaut) ou tester les hooks en session interactive."
```

