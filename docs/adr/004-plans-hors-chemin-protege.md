# ADR 004 — Plans d'Action dans `docs/plans/` (hors du chemin protégé `.claude/`)

**Date :** 2026-10-12  
**Statut :** Acceptée (Gate #1 de la Phase 8 du Plan d'Action 005, 2026-10-12)  
**Décideurs :** ⚫ MAINa (orchestration) + 🟠 ARCos (analyse) + 👤 Développeur humain (option B)

---

## Contexte

Les Plans d'Action, rapports de phase et index sont écrits dans `.claude/plans/` par ⚫ MAINa et par les
agents exécutants (rapports). La documentation Claude Code classe `.claude/` parmi les **chemins protégés** :

- les écritures n'y sont **jamais auto-approuvées** (confirmation en `default` et `acceptEdits`, refus en
  `dontAsk` et en exécution non interactive `-p`) ;
- une règle `permissions.allow` (ex. `Edit(.claude/plans/**)`) ne les pré-approuve pas ;
- seules `bypassPermissions` ou l'option interactive « autoriser l'édition de `.claude` pour la session » les lèvent.

Le workflow strict produit au moins une écriture par phase (rapport, journal des gates, index) : la
confirmation répétée alourdit chaque phase, et l'évaluation headless de la création de plan exige
`bypassPermissions` (constat de la Phase 7 du Plan d'Action 005).

---

## Décision

**Nous avons décidé de** stocker les Plans d'Action, rapports de phase, archive et index dans
**`docs/plans/`**, chemin non protégé et commun aux plateformes, et de garder `.claude/` pour la
configuration du harnais (agents, skills, hooks, settings) et le guide `PLANS.md`.

---

## Alternatives Considérées

### Option B : `docs/plans/` ✅ Retenue

- **Avantages** : aucune confirmation par écriture ; création de plan testable en headless (`acceptEdits`) ;
  plans versionnés et lisibles avec la documentation projet ; même chemin pour Claude et Copilot (plus de
  substitution `.claude/plans/` → `.github/plans/`).
- **Inconvénients** : migration (skills, agents, frontières de rôle, outillage, docs) ; DEVon et QALvin écrivent
  désormais dans `docs/` → frontières de rôle à affiner (règles ordonnées).

### Option A : garder `.claude/plans/`

- **Avantages** : aucun changement ; plans séparés de la documentation projet.
- **Inconvénients** : confirmation à chaque écriture de plan/rapport (atténuée par l'option de session) ;
  automatisation impossible sans `bypassPermissions`.
- **Raison du rejet** : contraire à un workflow où chaque phase écrit son rapport.

### Option C : `plansDirectory`

- **Avantages** : réglage natif.
- **Inconvénients** : l'exception de chemin protégé ne couvre que les fichiers de plan **de la session**
  (mode plan), pas les Plans d'Action du harnais.
- **Raison du rejet** : ne résout pas le problème.

---

## Conséquences

### Positives
- Écritures de plans et rapports sans confirmation en `acceptEdits` ; scénario S2 sans `bypassPermissions`.
- Chemin identique côté Copilot.

### Négatives / Compromis
- `docs/` contient désormais des artefacts de pilotage (plans) en plus de la documentation produit.
- Frontières de rôle : passage à des règles **ordonnées** (première correspondance l'emporte).

### Neutres
- `docs/ARCHITECTURE.md`, guides et skills à mettre à jour ; historique git conservé (`git mv`).

---

## Mise en œuvre

- **Fichiers impactés** : `.claude/plans/**` → `docs/plans/**` ; skills `plan-creation`, `plan-phase-execution`,
  `gate-protocol`, `adr-writing`, `init-harness` ; agents ; `CLAUDE.md`, `CLAUDE.template.md`, `PLANS.md` ;
  `.claude/hooks/guard.sh`, `role-boundaries.conf` ; `scripts/check-harness.ps1`, `scripts/tests/*`.
- **Tâches de suivi** : Phase 8 du Plan d'Action 005 (T8.1 → T8.5).
- **Date d'effet** : Gate #1 de la Phase 8.

---

## Références

- Plan d'Action associé : `docs/plans/005_claude-first.plan.md` (anciennement `.claude/plans/`)
- Constat : `005_reports/PHASE_7_COMPLETION_REPORT.md` § « `.claude/` est un chemin protégé »
- [Claude Code — Permission modes, Protected paths](https://code.claude.com/docs/en/permission-modes)
