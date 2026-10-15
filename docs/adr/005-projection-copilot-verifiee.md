# ADR 005 — Projection Copilot ciblée et vérifiée

> **Template** : À partir de `docs/adr/ADR-TEMPLATE.md`.

---

**Date :** 2026-10-13
**Statut :** Acceptée (Gate #1 du Plan d'Action 006, 2026-10-13)
**Décideurs :** 🟠 ARCos + 👤 Développeur humain

---

## Contexte

Le projet maintient une source unique basée sur `.claude/` (voir ADR 003). La cible examinée par AP 006 est
GitHub Copilot CLI. VS Code et cloud agent sont hors périmètre ; aucune parité ni support n'est décidé pour
ces surfaces. Une projection non contrôlée peut perdre des champs, des rôles, des gardes et des hooks.
L'analyse initiale (AP 006 — PHASE_0_ANALYSIS_REPORT.md) identifie des transformations problématiques et
l'absence de preuve de parité native.

Une décision architecturale est nécessaire pour définir la stratégie de projection vers Copilot : conserver la source Claude comme vérité unique mais définir une stratégie contrôlée et vérifiée de projection afin d'éviter pertes silencieuses d'invariants et d'établir un contrat de compatibilité par cible.

---

## Décision

**Nous avons décidé de** maintenir `.claude/` comme source unique et d'adopter une projection minimale,
spécifique à GitHub Copilot CLI et vérifiée (Option B). La projection est générée à partir de la source Claude ;
aucune compatibilité VS Code ou cloud agent n'est annoncée.

---

## Alternatives Considérées

### Option A : Fichiers Claude seuls

- Avantages : minimise la duplication et évite la maintenance de deux sources.
- Inconvénients : l'équivalence native entre Claude et Copilot/targets n'est pas établie ; risque de perte fonctionnelle (roles, guards, hooks) si la projection ne correspond pas exactement.
- Raison du rejet : manque de preuves de parité native et risque trop élevé sans phase de vérification approfondie.

### Option B : Source Claude + projection vérifiée ✅ Retenue

- Avantages : préserve la source canonique (`.claude`), permet une projection minimale et contrôlée, réduit les copies uniquement après preuve ; aligné sur AP 006 et le Plan 006.
- Inconvénients : nécessite un contrat de compatibilité par cible, phases d'analyse et tests (Phase 1..3) et effort de mise en œuvre pour adapter profils/gardes.

### Option C : Socle neutre partagé (adaptateurs)

- Avantages : facilite partage inter-clients, potentiel d'unification.
- Inconvénients : refonte plus lourde, effort élevé, risque de divergence par rapport à l'approche Claude-first.
- Raison du rejet : effort et temps non compatibles avec priorité actuelle Claude-first ; peut rester une option d'évolution.

---

## Conséquences

### Positives
- Source unique (`.claude/`) préservée comme vérité.
- Projection Copilot CLI contrôlée minimise les pertes silencieuses d'invariants (rôles, skills, gardes,
  hooks).
- Parcours de preuve ciblé sur la CLI, avec limites explicites lorsque le comportement natif n'est pas prouvé.

### Négatives / Compromis
- Travail supplémentaire : définir contrat et réaliser vérifications (Phase 1) ; implémentation et tests (Phase 2–3).
- VS Code et cloud agent restent hors périmètre, sans statut de support ou de parité.
- Aucune suppression de copies par un agent ; les retraits identifiés sont exécutés par un humain conformément aux règles du dépôt.

### Neutres
- Documentation à jour requise : QUICK_START_COPILOT.md, docs/ARCHITECTURE.md et autres guides (Phase 4).

---

## Mise en œuvre

La mise en oeuvre suit l'AP 006 (Plan d'Action 006 — Compatibilité Copilot) et ses phases :

- Phase 1 (ARCos) — Établir le contrat de compatibilité Copilot CLI et produire
  `docs/plans/006_reports/PHASE_1_COMPLETION_REPORT.md`.
  - Inventaire, exclusions, matrice des champs transformés et décision par champ (conserver / adapter /
    partager / non supporté).
  - Rejet clair de toute assertion non sourcée.

- Phase 2 (DEVon) — Implémenter adaptations et contrôles limités au contrat CLI vérifié.
  - Corriger profils, préserver sémantique des skills et contrôler les gardes sans annoncer d'équivalent
    natif non prouvé.
  - Fichiers impactés (exemples) : `scripts/copilot-mapping.psd1`, `scripts/Sync-Description.psm1`, `scripts/sync-claude-to-github.ps1`, `.claude/skills/*`, `.claude/settings{,.template}.json`, `.claude/hooks/*`.

- Phase 3 (QALvin) — Tests et validation Copilot CLI.
  - Tests unitaires/intégration, scénarios réels, mesure de couverture et limites documentées.

- Phase 4 (DOCly) — Documentation finale et préparation de clôture ; Gate #4 reste une validation humaine.

Contraintes d'exécution :
- Aucun agent n'est autorisé à supprimer ou à pousser des fichiers automatiquement ; toute suppression identifiée doit être effectuée par un humain.
- Aucune action d'exécution shell ou web non autorisée dans cette session.
- Les preuves de compatibilité requises sont des exécutions observables ou références officielles datées ; des
copies textuelles seules ne suffisent pas.

## Résultats de vérification

La vérification AP 006 porte uniquement sur GitHub Copilot CLI.

- **Versions** : `1.0.99-0`, puis `1.0.99-1` relevées dans les campagnes Phase 1–3.
- **Projection** : génération, `-Check` et idempotence validés en Phase 2 ; `check-harness` validé sous
  Windows PowerShell 5.1 et PowerShell 7.
- **Contrat indépendant** : outils autorisés, ARCos `[read, search, web]`, modèle en identifiant de catalogue,
  parité des skills, consigne explicite de chargement et interdiction de `tools` absent contrôlés par
  `scripts/check-harness.ps1`.
- **Tests** : `sync.tests.ps1` 31/31, `compatibility.tests.ps1` 68/68 et `guard.tests.sh` 54/54 ; défaut
  injecté détecté. La matrice fonctionnelle 17/17 est déclarative et non instrumentée.
- **Scénarios S1–S7** : cinq profils chargés en S1 ; arrêt au Gate #0 observé en `-p` ; ARCos lecture seule ;
  refus destructif et cible intacte ; abstention S6 après lecture de l'ignore ; repli S7 détecté malgré un
  code CLI nul.
- **Skills** : 18 skills reconnues ; la CLI lit `.github/skills/` et `.claude/skills/`, avec priorité `.github/`
  à nom identique et chargement selon pertinence.

Preuves détaillées : [rapport Phase 1](../plans/006_reports/PHASE_1_COMPLETION_REPORT.md), [rapport Phase 2](../plans/006_reports/PHASE_2_COMPLETION_REPORT.md) et [rapport Phase 3](../plans/006_reports/PHASE_3_COMPLETION_REPORT.md).

Ces résultats ne constituent pas des garanties natives générales. Hooks `.github/hooks`, mécanisme CLI de
`.copilotignore`, exclusion `/dist/`, précédence `git rm`, frontières DEVon/QALvin/DOCly et arrêt effectif à
tous les gates restent non déterministes ou non tranchés selon le scénario. VS Code et cloud agent n'ont pas
été vérifiés et restent hors périmètre.

---

## Références

- [AP 006 — Compatibilité Copilot](../plans/006_compatibilite-copilot.plan.md)
- [Rapport d'analyse initiale](../plans/006_reports/PHASE_0_ANALYSIS_REPORT.md)
- [ADR 003 — Source Claude unique](003-claude-first-copilot-genere.md)
- [ADR 004 — Emplacement des plans](004-plans-hors-chemin-protege.md)

---

## Notes et Limitations

- Cette ADR est **Acceptée** après `GO` humain au Gate #1 le 2026-10-13. Elle complète l'ADR 003 sans la
  remplacer globalement ; l'acceptation de la stratégie ne certifie que le périmètre explicitement vérifié.
- Les rapports Phase 1–3 consignent les sources, versions, campagnes et limites. Les résultats runtime
  concernent uniquement Copilot CLI.
- Gate #1 valide le plan avant Phase 1. Le périmètre a ensuite été ajusté humainement : VS Code et cloud
  agent sont hors périmètre.
- Une référence officielle établit un contrat annoncé, pas une certification comportementale. Les garanties
  CLI sont limitées aux comportements et contrôles effectivement observés.