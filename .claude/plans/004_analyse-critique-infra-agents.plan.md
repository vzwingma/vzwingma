# Plan d'Action 004 — Analyse critique & remédiation de l'infrastructure multi-agents (périmètre Claude)

**Document :** `.claude/plans/004_analyse-critique-infra-agents.plan.md`
**Date de création :** 2026-06-29
**Statut :** 🔄 En cours — Phase 1 (tooling) ✅ terminée + synchronisée (2026-06-29) ; Phases 2-6 en attente de gate 👤
**Objectif Prioritaire :** HIGH

> Ce document est **double** : (1) une **analyse critique** de l'existant, (2) un **plan de remédiation**
> structuré en phases. Les phases ne sont **pas** exécutées tant que l'analyse n'est pas validée.

---

## 🎯 Objectif Global

Analyse critique approfondie des **descriptions d'agents, skills, prompts, instructions, docs et scripts**
utilisés par Claude (`.claude/`, `docs/`, `scripts/`, `.md` racine). Évaluer **complétude, pertinence,
efficacité, cohérence**. Relever les écarts, en identifier la **cause racine**, proposer des améliorations
concrètes et priorisées sous forme de phases exécutables.

**Périmètre analysé** (24 fichiers) : 5 `*.agent.md` + `agents/README.md` · 8 `skills/*/SKILL.md` ·
4 `instructions/*.template.md` · `CLAUDE.md` · `.claude/README.md` · `.claude/PLANS.md` ·
`.claude/CHANGELOG.md` · `.claude/plans/README.md` · `docs/ARCHITECTURE(.template).md` · 2 ADR ·
`README.md`/`QUICK_START.md`/`SETUP_CHECKLIST.md` racine · `scripts/` (sync, package, module).
**Hors périmètre** (demande) : `.github/`, `.opencode/`.

---

## 📊 Synthèse exécutive

État global : **infrastructure riche et bien pensée, mais désynchronisée**. Le squelette (workflow MAINa,
skills `applyTo:**`, format AP) est solide. Mais une **dette de cohérence** importante existe entre la
vision cible (MAINa v1.2 crée le plan) et de nombreux fichiers restés sur le modèle antérieur (ARCos crée
le plan). La majorité des défauts ont une **cause technique unique** : `.claude/` est un **miroir généré**
de `.github/` par un script de sync dont la substitution est **incomplète**.

| Sévérité | Nb | Nature dominante |
|---|---|---|
| 🔴 Critique | 3 | Références mortes structurelles, doc d'architecture fausse |
| 🟠 Majeur | 13 | Incohérence workflow/rôles, généricité, duplication, chemins |
| 🟡 Mineur | 11 | Typos, dates manuelles, liens isolés, nommage |

**Note de cadrage importante** : `.claude/` étant généré depuis `.github/`, les corrections **durables**
doivent se faire dans la **source `.github/` + le tooling `scripts/`**, puis re-synchroniser. Corriger
seulement `.claude/` serait écrasé au prochain sync. (Voir §Causes racines et Phase 1.)

---

## 🔍 Causes racines (chaîne de génération)

`scripts/sync-github-to-claude.ps1` + `scripts/Sync-Description.psm1` génèrent `.claude/` depuis `.github/`.
4 défauts de tooling expliquent ~70 % des findings :

| # | Cause racine | Effet observé dans `.claude/` |
|---|---|---|
| **RC1** | `Apply-PathSubstitution` direction `github-to-claude` ne substitue **que** `.github/`→`.claude/` (asymétrie : `github-to-opencode` traduit aussi `Copilot`→`OpenCode`, `.copilotignore`→`.gitignore`) | « GitHub Copilot », « Copilot », « instructions Copilot » persistent dans `.claude/README.md`, agents, instructions |
| **RC2** | `CLAUDE.md` **absent** de la liste standalone sync (`@('CHANGELOG.md','PLANS.md','README.md')`) → jamais path-substitué | `CLAUDE.md` truffé de chemins `.github/plans/`, `.github/instructions/`, `.github/PLANS.md` |
| **RC3** | Templates instructions copiés **bruts** (`Copy-Item`, sans substitution) | `.claude/instructions/*.template.md` gardent `.github/plans/README.md` |
| **RC4** | Prompts **exclus volontairement** du sync, mais référencés en aval | `.claude/prompts/` absent mais cité par CLAUDE.md, README, package |
| **RC5** | `agents/README.md` et `docs/ARCHITECTURE.md` **non synchronisés** (hors filtres) → maintenus à la main, dérivent | Modèle ARCos-crée-plan + inventaires obsolètes |

---

## 🧭 Analyse par critère

### 1. Complétude

| ID | Sév | Constat | Fichier(s) | Proposition |
|---|---|---|---|---|
| F-C1 | 🔴 | `.claude/prompts/` **absent** (sync l'exclut) mais référencé partout en aval → ZIP Claude omet les prompts silencieusement | `CLAUDE.md`, `.claude/README.md` (l.20,84-90), `package-claude.ps1` (l.13,84-88), `SETUP_CHECKLIST.md` | Décider : (a) inclure prompts dans le sync claude, ou (b) **retirer toutes les références** prompts du périmètre Claude. Cohérence à imposer dans les 2 cas |
| F-M11 | 🟠 | `.claude/plans/README.md` indexe `001-003_*.plan.md` **absents** de `.claude/plans/` (liens morts) ; section « Comment créer » en chemins `.github/` + lien `.github/copilot-instructions.md` | `.claude/plans/README.md` | Sync/générer les fichiers plans, ou retirer du tableau ; corriger chemins `.github/`→`.claude/` |
| F-M12 | 🟠 | `package-claude.ps1` n'inclut **pas** `.claude/README.md` (que tous les agents citent comme source workflow) | `package-claude.ps1` | Ajouter `.claude/README.md` au staging |
| F-m1 | 🟡 | `.github/examples/` référencé mais probablement inexistant (`ARCHITECTURE.md` « Exemples \| 1 ») | `QUICK_START.md` l.135, `docs/ARCHITECTURE.md` l.251,294 | Vérifier ; créer le dossier ou retirer les liens |
| F-m11 | 🟡 | `doc.instructions` template liste seulement **3** skills sous `.github/skills/` | `doc.instructions.template.md` l.32-37 | Lister les 8 skills (ou renvoyer à l'index) |

### 2. Pertinence

| ID | Sév | Constat | Fichier(s) | Proposition |
|---|---|---|---|---|
| F-M5 | 🟠 | Agents/templates censés **génériques** mais **verrouillés React/TS/Jest** (`React.FC`, JSX, `@testing-library/react`, `jest.fn()`, `useContext`) — contredit le principe « agents génériques » d'`ARCHITECTURE.md` | `Qalvin.agent.md` (massif), `qa/dev/architect.instructions.template.md` | Rendre **QALvin agent** stack-neutre ; déplacer le React/Jest concret dans `qa.instructions` (en **placeholders**) ; neutraliser les hypothèses SPA dans dev/architect templates |
| F-m2 | 🟡 | DEVon « reçois specs de ARCos » — légèrement obsolète (specs viennent du Plan d'Action créé par MAINa) | `Devon.agent.md` l.25 | Reformuler « reçois tâches du Plan d'Action (MAINa) » |
| F-m8 | 🟡 | `compact-context` cite des skills `sdlc-*` non présents dans le repo | `compact-context/SKILL.md` l.19 | Retirer ou marquer « si présents » |
| F-m9 | 🟡 | ADR 001 décrit `ARCos→DEVon→…` sans le raffinement v1.2 (MAINa crée le plan) | `docs/adr/001-maina-orchestrateur.md` | Acceptable (historique) ; éventuel ADR de suivi v1.2 |

### 3. Efficacité

| ID | Sév | Constat | Fichier(s) | Proposition |
|---|---|---|---|---|
| F-M6 | 🟠 | Blocs « Opérations destructives interdites » + « Règle absolue `.copilotignore` » **dupliqués inline dans les 5 agents** (~25-30 l. ×5) alors que le skill `copilotignore` (`applyTo:**`) est **déjà auto-injecté** + règles dans README/CLAUDE | 5 `*.agent.md` | Externaliser « opérations destructives » en **skill** (`applyTo:**`) ; **retirer** les blocs inline des agents ; s'appuyer sur le skill `copilotignore` |
| F-m7 | 🟡 | Dates « Dernière mise à jour : 2026-06-25 » saisies **à la main** → dérive garantie | `scripts/README.md`, `.claude/plans/README.md`, `.claude/README.md` | Générer la date ou retirer |

> Note efficacité positive ✅ : les skills `compact-context`, `caveman-default`, `plan-phase-execution`
> documentent explicitement l'anti-accumulation de skill blobs — bonne hygiène de contexte.

### 4. Cohérence

| ID | Sév | Constat | Fichier(s) | Proposition |
|---|---|---|---|---|
| F-C2 | 🔴 | `docs/ARCHITECTURE.md` **largement faux** : inventaire « Agents \| 4 » (réel 5, contredit sa propre table l.128) ; ARCos **v4.3** (réel v4.4), MAINa v1.0 (réel v1.2) ; **6 skills** listés (réel 8, manquent `compact-context`, `maina-help`) ; **index ADR faux** (liste 001 Wiki + 002 ARCos-lit-ARCHITECTURE, or `docs/adr/` ne contient que `001-maina-orchestrateur`) ; historique s'arrête v3.1 | `docs/ARCHITECTURE.md` | Réécrire l'inventaire, versions, liste skills, table ADR, historique pour refléter le réel |
| F-C3 | 🔴 | `CLAUDE.md` référence `.github/plans/`, `.github/instructions/`, `.github/PLANS.md` (cause RC2) alors que c'est la config **Claude** | `CLAUDE.md` (Règle MAINa, §Plans, §Instructions) | Substituer en `.claude/` (corriger via tooling RC2) |
| F-M1 | 🟠 | `agents/README.md` décrit **ARCos créateur du plan + orchestrateur** (modèle pré-MAINa) ; 4 gates sans Gate #0 ; invocation `Invoke-AIAgent` | `.claude/agents/README.md` l.26-38,158-164 | Réaligner sur MAINa v1.2 (MAINa crée le plan, Gate #0 choix solution, 5 gates) ; harmoniser invocation |
| F-M2 | 🟠 | **Incohérence interne `Arcos.agent.md`** : frontmatter + « Coordination transverse » + « Séquencement » disent *MAINa crée le plan* ; mais « Méthodologie » (ét. 4-6 : créer WBS, orchestrer entre agents, déléguer DEVon/QALvin/DOCly) + « Format sortie » (produire plan complet avec tâches par agent) décrivent encore *ARCos créateur/orchestrateur* | `Arcos.agent.md` l.80-97,116-156 | Retirer/atténuer les sections WBS+orchestration+plan complet ; ARCos = analyse comparative + reco + exécution de tâches assignées |
| F-M3 | 🟠 | `maina-help/SKILL.md` (**aide officielle**) dit « ARCos crée Plans d'Action détaillés » + workflow 6 étapes sans Gate #0 | `maina-help/SKILL.md` l.26,42-49 | Corriger : MAINa crée le plan après consultation ARCos ; workflow aligné CLAUDE.md |
| F-M4 | 🟠 | `.claude/PLANS.md` : exemple « AP-001 Modernisation / Phase 1 en cours » **contredit** l'index (001 = Optimisation tokens, ✅ Complété) ; chaîne délégation « ARCos (plan) » | `.claude/PLANS.md` l.308,427,476-480 | Aligner l'exemple sur l'index réel ; chaîne `MAINa (plan)` |
| F-M7 | 🟠 | Chemins `.github/plans/README.md` dans les 4 `instructions/*.template.md` (cause RC3) | 4 templates instructions | Substituer chemins via tooling (RC3) |
| F-M8 | 🟠 | « **3 skills** » répété alors que réel = **8** | `QUICK_START.md` l.107,145-146,163 ; `SETUP_CHECKLIST.md` l.10,163 | Mettre « 8 skills » + liste à jour |
| F-M9 | 🟠 | Commande `/help` obsolète (renommée `/maina-help` en v1.1) | `QUICK_START.md` l.149 ; `SETUP_CHECKLIST.md` l.81 | Remplacer par `/maina-help` |
| F-M10 | 🟠 | Terminologie « GitHub Copilot »/« Copilot » dans un sous-arbre **Claude** (cause RC1) | `.claude/README.md` titre+corps, agents (« instructions Copilot »), templates | Étendre la substitution `Copilot`→`Claude` (RC1) |
| F-M13 | 🟠 | `caveman-default/SKILL.md` cite `.claude/copilot-instructions.md` (**inexistant** ; règles réellement dans `CLAUDE.md`) + `.agents/skills/caveman/SKILL.md` (hors `.claude/`) | `caveman-default/SKILL.md` l.7,13,26 | Pointer `CLAUDE.md` (§Mode communication) ; corriger le chemin du skill caveman |
| F-m3 | 🟡 | Exemple /fleet DOCly référence `.claude/copilot-instructions.md` (inexistant) | `Docly.agent.md` l.147 | Remplacer par `CLAUDE.md` |
| F-m4 | 🟡 | Séparateur parasite `-- ` | `Qalvin.agent.md` l.181 | Supprimer |
| F-m5 | 🟡 | Nommage agents hétérogène : `DEVon`/`Dev`/`DEV`, `QALvin`/`Qa`/`QUAL`, typo **« Arkos »** | `Arcos.agent.md` l.87 ; `.claude/PLANS.md` l.207,237 | Convention unique (Nom + icône) |
| F-m6 | 🟡 | Typo « orchester » | `maina-help/SKILL.md` l.56 | « orchestre » |
| F-m10 | 🟡 | Versions stales (MAINa v1.0, ARCos v4.3) + inventaire skills 6/8 | `docs/ARCHITECTURE.md` l.89-101,128-132 | Couvert par F-C2 |

---

## 🗂️ Vue par zone (récap)

- **Agents (5)** : structure homogène, bon découpage. Points durs : ARCos schizophrène (F-M2), QALvin React-locked (F-M5), duplication blocs sécurité ×5 (F-M6), micro-références mortes (F-m3/4). MAINa, DEVon, DOCly : sains.
- **Skills (8)** : `plan-creation`, `plan-phase-execution`, `adr-writing`, `fleet-guide`, `copilotignore`, `compact-context` = **solides, chemins `.claude/` corrects**. `maina-help` (F-M3) et `caveman-default` (F-M13) = à corriger.
- **Instructions (4 templates)** : utiles mais React-biaisés (F-M5) + chemins `.github/` (F-M7).
- **Docs/ADR** : ADR-TEMPLATE + ADR 001 = bonne qualité. `ARCHITECTURE.md` = **point noir** (F-C2). Numérotation ADR à réconcilier.
- **Scripts** : module sync **bien conçu** (frontmatter préservé, dry-run). Défauts = substitution incomplète (RC1) + couverture (RC2/RC3) + package (F-M12, F-C1).
- **Racine + CLAUDE.md** : `README.md` racine quasi vide (profil GitHub). `QUICK_START`/`SETUP` = orientés `.github`, comptes/commandes obsolètes (F-M8/9). `CLAUDE.md` chemins `.github/` (F-C3).

---

## 🛠️ Phases de remédiation (proposées — ⏳ Planifié)

> Ordre conçu pour traiter d'abord les **causes racines** (tooling), sinon les corrections `.claude/`
> seraient écrasées au prochain sync. Agents indicatifs — MAINa orchestrera après validation.

### Phase 1 — Corriger la chaîne de génération (tooling) — ✅ TERMINÉE (2026-06-29)
**Contexte :** RC1-RC4. Source de la majorité des incohérences.
**Décisions 👤 :** **A1** (prompts inclus au sync) · **B1-bis** (CLAUDE.md reste hand-maintained/curé, **non** régénéré ; seul `CLAUDE.template.md` est généré) · **C-ok** (corrections en source `.github/` + 1 sync réel). ADR : `docs/adr/002-claude-miroir-genere.md`.
**Résultat (sync réel exécuté) :** 0 chemin `.github/` ni terme « Copilot » résiduel injecté ; `CLAUDE.md` préservé ; 10 fichiers régénérés, 9 déjà en sync, 0 erreur.
- **T1.1** — ✅ `Apply-PathSubstitution` (`github-to-claude`) étendu : `GitHub Copilot`→`Claude Code`, `Copilot`→`Claude`, `copilot-instructions(.template).md`→`CLAUDE(.template).md` ; miroir inverse `claude-to-github`. Casse respectée → `.copilotignore` / `copilot-instructions` lowercase intacts. `scripts/Sync-Description.psm1`.
- **T1.2** — ✅ (B1-bis) `CLAUDE.md` **exclu** du sync (curé, agnostique-projet) ; fuites `.github/`→`.claude/` (×10) + réf ARCos obsolète corrigées **à la main**. `CLAUDE.template.md` **généré** depuis `copilot-instructions.template.md`. `scripts/sync-github-to-claude.ps1`.
- **T1.3** — ✅ Templates d'instructions passés en `Sync-StandaloneFile` (substitution) au lieu de `Copy-Item` brut. `scripts/sync-github-to-claude.ps1`.
- **T1.4** — ✅ (A1) Prompts inclus au sync `github→claude` avec substitution → `.claude/prompts/` peuplé (2 fichiers). **Reste Phase 6** : nommage fichiers (`init-copilot-*` conservé) + référencement package.
- **Bonus** — Ligne parasite (`Compressing markdown to caveman format…`) retirée de `.github/copilot-instructions.md`.

### Phase 2 — Réaligner workflow & rôles sur MAINa v1.2 (source `.github/`) — ✅ TERMINÉE (2026-06-29)
**Contexte :** F-M1/M2/M3/M4. Corriger dans `.github/` (source) puis re-sync.
**Critères :** ✅ aucun fichier ne dit « ARCos crée le Plan d'Action » ✅ Gate #0 présent partout.
**Résultat (sync réel) :** 6 fichiers régénérés, 13 en sync, 0 erreur. Vérif `.claude/` : 0 occurrence « Architecte & Planificateur » / « Invoke-AIAgent » / « Planificateur » hors doc d'audit 004 (qui les cite comme findings). ARCos bumpé **v4.5** partout (agent, CLAUDE, CLAUDE.template, CHANGELOG). `CLAUDE.md` + `agents/README.md` (hand-maintained) préservés.
- **T2.1** — ✅ `.claude/agents/README.md` réécrit (Claude-only, hors sync) : MAINa crée le plan, Gate #0 + 5 gates, ARCos = architecte consulté, invocation `@MAINa`/`@ARCos`.
- **T2.2** — ✅ `Arcos.agent.md` nettoyé (v4.4→**v4.5**) : retrait « créer WBS / orchestrer entre agents / format sortie = plan ». Recentré analyse & conception ; découpage = entrée pour MAINa.
- **T2.3** — ✅ `maina-help/SKILL.md` corrigé : rôle ARCos (analyse/reco), MAINa crée le plan, workflow 7 étapes avec Gate #0→#4, typo « orchester »→« orchestre ».
- **T2.4** — ✅ `.github/PLANS.md` corrigé : « Créer le Plan » = MAINa, chaîne de délégation (ARCos = input analyse), typo « Arkos »→« ARCos » (×2).
- **Bonus** — `.github/README.md` l.15 (arbre) recadré. Cascade version : `copilot-instructions(.template).md` + `CLAUDE.md` + `CHANGELOG.md` (entrée v4.5). Typos « Arkos »/« orchester » de T6.2 traités ici.

### Phase 3 — Rafraîchir doc d'architecture & index — ✅ TERMINÉE (2026-06-29)
**Contexte :** F-C2, F-M11, F-M8, F-M9, F-m1.
**Critères :** ✅ `ARCHITECTURE.md` reflète 5 agents / versions réelles / 8 skills / ADR réels ✅ guides à jour.
**Résultat (vérif sous-agent, 5/7 PASS, 2 faux positifs) :** aucun fichier `.github/` source touché → **pas de re-sync** (cibles = `docs/`, racine, `.claude/` direct). Faux positifs écartés : `compact-context/SKILL.md:66` (« 3 skills injectés » = exemple de compaction, pas l'inventaire) ; `CHANGELOG.md:10` (historique v1.0 exact, renommage `/maina-help` documenté en v1.1).
- **T3.1** — ✅ `docs/ARCHITECTURE.md` réécrit : MAINa v1.2 / ARCos v4.5 / 5 agents ; section + inventaire **8 skills** ; **modèle miroir** (`.github/`→`.claude/`, sync, ADR 002) ; table ADR réelle (001 MAINa, 002 miroir) ; historique v3.2/v4.0 ; liens morts `examples/` retirés ; changelog externalisé.
- **T3.2** — ✅ `.claude/plans/README.md` : nom projet vide corrigé, 004 statut « en cours », archives 001-003 repointées vers `.github/plans/` (réelles), chemins `.github/`→`.claude/` + `copilot-instructions.md`→`CLAUDE.md`, date + gestionnaire (ARCos retiré).
- **T3.3** — ✅ `QUICK_START.md` + `SETUP_CHECKLIST.md` : **8 skills** (×4), workflow Gate #0→#4, rôle ARCos (analyse/conception), `/help`→`/maina-help`, lien mort `examples/` retiré.
- **T3.4** — ✅ Table ADR réconciliée dans `ARCHITECTURE.md` (001-maina-orchestrateur, 002-claude-miroir-genere) ; anciens sujets supprimés.

### Phase 4 — Réduire la duplication (efficacité) — ✅ TERMINÉE (2026-06-29)
**Contexte :** F-M6, F-M13, F-m3/4.
**Critères :** ✅ blocs sécurité externalisés ✅ agents allégés sans perte de règle.
**Résultat (re-sync exit 0 ; 9/9 checks PASS) :** sécurité unifiée via 2 skills `applyTo:**` (`safety-rules` + `copilotignore`) — aucune perte comportementale. Cascade version + compteur 8→9 propagée. Bug latent du moteur de sync corrigé (voir Bonus 2).
- **T4.1** — ✅ Skill `safety-rules` créé (`applyTo:**`, opérations destructives) + miroir `.claude/skills/`.
- **T4.2** — ✅ Blocs inline « destructives » + « copilotignore » retirés des 5 agents → pointeur 1 ligne. MAINa garde sa règle propre (pas de clôture sans validations 👤). Versions bumpées : MAINa v1.3, ARCos v4.6, DEVon/QALvin/DOCly v4.3 (frontmatter + CHANGELOG + copilot-instructions(.template).md + CLAUDE.md + ARCHITECTURE.md).
- **T4.3** — ✅ `caveman-default` : chemin mort `.agents/skills/caveman/SKILL.md` corrigé (→ « invoquer le skill caveman »).
- **Bonus 1** — Compteur skills 8→9 propagé partout : ARCHITECTURE (arbre+table+inventaire), copilot-instructions.md (table+arbre), template, CLAUDE.md, QUICK_START (×2), SETUP_CHECKLIST (×2). Ajout `maina-help` (manquant) + `caveman-default` dans l'arbre copilot-instructions.md ; versions/desc obsolètes de cet arbre corrigées (ARCos « planificateur »→« consulté par MAINa », MAINa v1.0→v1.3) ; template `plan-creation` « ARCos+orchestrateurs »→« MAINa ».
- **Bonus 2** — 🐛 `Sync-Description.psm1` : `Sync-StructuredFile` ne gérait pas une cible inexistante (crash `Get-Content` sous `ErrorActionPreference=Stop` au 1er nouveau skill). Ajout d'un bootstrap (création depuis source + substitution), aligné sur `Sync-StandaloneFile`. Re-sync end-to-end OK.

### Phase 5 — Neutraliser la stack dans les artefacts génériques (pertinence) — ✅ TERMINÉE (2026-06-30)
**Contexte :** F-M5.
**Critères :** ✅ `Qalvin.agent.md` sans techno spécifique ✅ React/Jest concret en placeholders dans `qa.instructions`.
**Résultat (re-sync exit 0 ; vérif sous-agent : 0 occurrence React/jest/hooks dans l'agent miroir) :** corps générique de QALvin rendu framework-agnostique ; le concret React/Testing Library demeure (encadré « exemple ») dans les templates d'instructions. QALvin v4.3 → v4.4.
- **T5.1** — ✅ `Qalvin.agent.md` neutralisé : « composants React » → « composants UI (selon framework) » ; « React Testing Library »/`act()`/`useContext`/`useReducer` → utilitaires de test du framework ; `jest.mock()`/`jest.fn()` → mécanisme de mock du framework ; « Hooks React »/« Context et Redux »/« APIs navigateur »/« Hooks personnalisés » → libellés génériques ; nommage `*.test.tsx` → « convention du projet ». Version + cascade (CHANGELOG, copilot-instructions(.template).md, CLAUDE.md, ARCHITECTURE.md).
- **T5.2** — ✅ `qa.instructions.template.md` conserve le concret React/Testing Library + `jest`/`fetch` mock comme **exemple encadré** (« 💡 Exemple React / Testing Library — adapter à `[FRAMEWORK_TEST]` »). Placeholders déjà présents.
- **T5.3** — ✅ `dev.instructions.template.md` : bloc composant React + `useMemo`/`useCallback` + `useContext`/`useState` encadrés « exemple, adapter au framework ». `architect.instructions.template.md` : « nouveau Context » → « nouveau conteneur d'état global (ex: React Context, store) ».

### Phase 6 — Finitions packaging & cosmétique — ✅ TERMINÉE (2026-06-30)
**Contexte :** F-M12, F-C1 (volet package), F-m5/6/7.
**Critères :** ✅ package Claude inclut `README.md` ✅ typos résolues ✅ footers de date manuels retirés.
**Résultat :** aucun fichier `.github/` *synchronisé* touché (cibles = `scripts/`, `*/plans/README.md`, `CLAUDE.md` hand-maintained) → **pas de re-sync**. Edits cosmétiques + alignements de cohérence opportunistes.
- **T6.1** — ✅ `package-claude.ps1` : staging `.claude/README.md` ajouté (garde `Test-Path`, calqué sur le bloc prompts) ; `.DESCRIPTION` corrigée (README listé ; « (everything) » → liste curée ; prompts déjà OK).
- **T6.2** — ✅ Déjà traité en Phase 2 (typos « Arkos »→« ARCos » ×2 + « orchester »→« orchestre » corrigés en source). Seules subsistent les **citations descriptives** dans ce plan 004 (findings F-m5/F-m6) — volontairement conservées.
- **T6.3** — ✅ Footers manuels « Dernière mise à jour » retirés (4) : `.claude/CLAUDE.md`, `.claude/plans/README.md`, `.github/plans/README.md`, `scripts/README.md`. Option retenue = **retrait** (pas de build step pour automatiser ; l'historique git couvre les dates).
- **Bonus** — Cohérence opportuniste : `.github/plans/README.md` (nom de projet vide « du projet . » → « de ce dépôt transverse » ; gestionnaire « ARCos » pré-MAINa retiré, aligné sur `.claude/`) ; `.claude/plans/README.md` statut 004 rafraîchi (Phases 1-5 ✅, Phase 6 ✅).

---

## 📍 Dépendances entre phases

```
Phase 1 (tooling)  ← prérequis de tout
    ↓
Phase 2 (workflow/rôles, source .github)  ←─┐
Phase 3 (doc/index)                          │ (re-sync après P1)
Phase 5 (généricité)                         │
    ↓                                        │
Phase 4 (duplication)  ← indépendante ───────┘
    ↓
Phase 6 (finitions) ← après P1-P5
```

Phase 1 **bloque** la valeur durable des autres (sinon écrasement au sync). Phases 2/3/5 parallélisables
après P1 (`/fleet`). Phase 4 quasi indépendante. Phase 6 en dernier.

---

## ✅ Critères de Succès Globaux

1. **0 chemin `.github/`** résiduel injecté dans `.claude/` après sync (hors source volontaire).
2. **0 occurrence** « ARCos crée le Plan d'Action » dans tout le périmètre.
3. `docs/ARCHITECTURE.md` exact : **5 agents, versions réelles, 8 skills, ADR réels**.
4. **0 référence morte** (prompts, plans 001-003, copilot-instructions, examples).
5. Blocs sécurité **externalisés** (agents allégés, règle préservée via skills).
6. `Qalvin.agent.md` **stack-neutre** ; React/Jest en placeholders d'instructions.
7. `package-claude.ps1` produit un ZIP **complet** (README inclus) et conforme à sa `.DESCRIPTION`.

---

## ⚡ Quick wins vs chantiers de fond

| Quick wins (faible effort, fort signal) | Chantiers de fond |
|---|---|
| F-M8 (« 3 skills »→8), F-M9 (`/help`→`/maina-help`) | F-C2 réécriture `ARCHITECTURE.md` |
| F-m4/5/6 (typos, « Arkos », séparateur) | F-M5 dégénéricisation QALvin/instructions |
| F-M12 (README dans package) | F-M2 refonte cohérence `Arcos.agent.md` |
| F-m3, F-M13 (refs `copilot-instructions.md`) | RC1-RC4 tooling sync (Phase 1) |

---

## 🚀 Plan d'Exécution (post-validation)

1. **Gate #0** — ✅ 👤 a validé l'analyse + priorisation.
2. **Phase 1** (tooling) — ✅ implémentée (`Sync-Description.psm1`, `sync-github-to-claude.ps1`) + dry-run de contrôle.
3. **Re-sync** `.github/`→`.claude/` — ✅ exécuté ; critères 1-2 vérifiés (0 `.github/` injecté, `CLAUDE.md` préservé).
4. **Phases 2/3/5 en `/fleet`** (après P1) ; **Phase 4** en parallèle.
5. **Phase 6** — ✅ finitions packaging + cosmétique (README dans package, footers de date retirés, typos déjà traitées en P2).
6. **Gate final** — ⏳ en attente validation 👤 (clôture initiative + bascule `.claude/plans/README.md` → ✅ Complété).

> ✅ **ADR créé** : `docs/adr/002-claude-miroir-genere.md` — décision « `.claude/` = miroir généré,
> source unique `.github/` + tooling ; `CLAUDE.md` hand-maintained (B1-bis) » (règle MAINa plan+ADR).

---

## 📚 Références

- Guide format AP : `.claude/PLANS.md`
- Index plans : `.claude/plans/README.md`
- Vue agents : `.claude/README.md` · CHANGELOG : `.claude/CHANGELOG.md`
- Tooling : `scripts/Sync-Description.psm1`, `scripts/sync-github-to-claude.ps1`, `scripts/package-claude.ps1`
