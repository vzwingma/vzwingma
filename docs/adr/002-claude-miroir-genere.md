# ADR 002 — `.claude/` est un miroir généré de `.github/` (source unique + tooling de sync)

**Date :** 2026-06-29  
**Statut :** Acceptée  
**Décideurs :** ⚫ MAINa (orchestration) + 👤 Développeur humain (décisions A1 / B1-bis / C-ok)

---

## Contexte

Les sous-arbres `.claude/` et `.opencode/` étaient perçus comme des copies jumelles de `.github/`
maintenues à la main, d'où une dérive : terminologie « Copilot » résiduelle, chemins `.github/`
injectés, inventaires obsolètes.

En réalité, `.claude/` est **généré** depuis `.github/` par `scripts/sync-github-to-claude.ps1`
(+ module `scripts/Sync-Description.psm1`). L'analyse du Plan d'Action 004 a identifié que la
substitution était **incomplète** (causes racines RC1-RC4) :

- RC1 — seul `.github/`→`.claude/` était traduit, **pas** la terminologie (`Copilot`, `GitHub Copilot`).
- RC2 — `CLAUDE.md` hors couverture de substitution → chemins `.github/` persistants.
- RC3 — templates d'instructions copiés bruts (`Copy-Item`, sans substitution).
- RC4 — prompts exclus du sync mais référencés en aval.

Une décision d'architecture explicite était nécessaire pour fixer le modèle (source unique + miroirs)
et trancher le cas particulier de `CLAUDE.md`.

---

## Décision

**Nous avons décidé d'**acter `.github/` comme **source de vérité unique**, `.claude/` (et `.opencode/`)
étant des **miroirs générés** par le tooling de sync. Les corrections durables se font dans la **source
`.github/` + le tooling `scripts/`**, suivies d'un re-sync — jamais directement dans `.claude/`.

La substitution est étendue à la **terminologie** (`GitHub Copilot`→`Claude Code`, `Copilot`→`Claude`,
`copilot-instructions(.template).md`→`CLAUDE(.template).md`), la casse protégeant `.copilotignore`
et les références lowercase.

**Exception (B1-bis) :** `.claude/CLAUDE.md` reste **maintenu à la main** (curé, agnostique-projet)
et **n'est pas** régénéré ; sa source naturelle (`copilot-instructions.md`) est un document de
**maintenance du dépôt transverse**, inadapté à une distribution. En revanche `CLAUDE.template.md`
**est** généré depuis `copilot-instructions.template.md`.

---

## Alternatives Considérées

### Option 1 : Miroir généré + `CLAUDE.md` hand-maintained (B1-bis) ✅ Retenue

- **Avantages** : source unique, cohérence terminologique automatique, RC1-RC4 corrigés, `CLAUDE.md`
  conserve sa curation orientée distribution.
- **Inconvénients** : `CLAUDE.md` devient une exception au modèle (discipline manuelle à surveiller).

### Option 2 : Tout générer, y compris `CLAUDE.md` depuis `copilot-instructions.md` (B1)

- **Avantages** : cohérence totale, zéro fichier hand-maintained.
- **Inconvénients** : `CLAUDE.md` régresse en doc « maintenance du dépôt » (arbre d'archi, section
  maintenance), perd sa curation, pollue le package distribué.
- **Raison du rejet** : dégrade l'artefact le plus visible côté utilisateur.

### Option 3 : Maintenir `.claude/` entièrement à la main

- **Avantages** : aucune contrainte de tooling.
- **Inconvénients** : duplication, dérive garantie.
- **Raison du rejet** : c'est précisément la cause racine des findings du plan 004.

---

## Conséquences

### Positives
- Une **source unique** (`.github/`) ; `.claude/` régénérable et fiable.
- Substitution terminologique automatique → 0 « Copilot » / chemin `.github/` résiduel injecté.
- Causes racines RC1-RC4 traitées au niveau du tooling.

### Négatives / Compromis
- `CLAUDE.md` est une **exception** : éditer le reste de `.claude/` directement est écrasé au sync.
- Discipline manuelle requise pour `CLAUDE.md` (risque de dérive ciblé, à surveiller).

### Neutres
- `docs/ARCHITECTURE.md` devra décrire ce modèle (source/miroir, fichiers générés vs hand-maintained).

---

## Mise en œuvre

- **Fichiers impactés** :
  - `scripts/Sync-Description.psm1` — substitution terminologie + `copilot-instructions`→`CLAUDE`.
  - `scripts/sync-github-to-claude.ps1` — sync des prompts, génération `CLAUDE.template.md`,
    substitution des templates d'instructions ; `CLAUDE.md` explicitement exclu.
  - `.github/copilot-instructions.md` — ligne parasite (`Compressing markdown…`) retirée.
  - `.claude/CLAUDE.md` — fuites `.github/`→`.claude/` + référence ARCos obsolète corrigées à la main.
- **Tâches de suivi** : Phases 2-6 du Plan d'Action 004 (corriger la source `.github/` puis re-sync) ;
  Phase 6 — trancher le nommage des fichiers prompts (`init-copilot-*`) et leur référencement dans le package.
- **Date d'effet** : immédiate (2026-06-29).

---

## Références

- Plan d'Action associé : `.claude/plans/004_analyse-critique-infra-agents.plan.md`
- Tooling : `scripts/sync-github-to-claude.ps1`, `scripts/Sync-Description.psm1`
- ADR liée : `docs/adr/001-maina-orchestrateur.md`
