# ADR 005 — Projection Copilot ciblée et vérifiée

> **Template** : À partir de `docs/adr/ADR-TEMPLATE.md`.

---

**Date :** 2026-10-13
**Statut :** Acceptée (Gate #1 du Plan d'Action 006, 2026-10-13)
**Décideurs :** 🟠 ARCos + 👤 Développeur humain

---

## Contexte

Le projet maintient une source unique basée sur `.claude/` (voir ADR 003). GitHub Copilot et autres cibles (CLI, VS Code, cloud) reçoivent aujourd'hui des projections "best-effort" qui peuvent perdre des champs, des rôles, des guards et des hooks. L'analyse initiale (AP 006 — PHASE_0_ANALYSIS_REPORT.md) identifie des transformations problématiques, l'absence de preuve de parité native et des scripts qui modifient/ignorent des invariants critiques.

Une décision architecturale est nécessaire pour définir la stratégie de projection vers Copilot : conserver la source Claude comme vérité unique mais définir une stratégie contrôlée et vérifiée de projection afin d'éviter pertes silencieuses d'invariants et d'établir un contrat de compatibilité par cible.

---

## Décision

**Nous avons décidé de** maintenir `.claude/` comme source unique et d'adopter une projection Copilot minimale, cible-spécifique et vérifiée (Option B). La projection sera générée à partir de la source Claude, mais toute réduction de copies ou partage direct ne sera réalisée que pour les composants dont la compatibilité native a été démontrée par des preuves et tests définis dans le contrat de compatibilité.

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
- Projection Copilot contrôlée minimise pertes silencieuses d'invariants (roles, skills, guards, hooks).
- Parcours clair de preuve et certification par cible (CLI, VS Code, cloud) imposant des tests réels et une matrice de compatibilité.

### Négatives / Compromis
- Travail supplémentaire : définir contrat et réaliser vérifications (Phase 1) ; implémentation et tests (Phase 2–3).
- Jusqu'à certification, certaines cibles resteront marquées « non certifiées » ou « partiellement supportées ».
- Aucune suppression de copies par un agent ; les retraits identifiés sont exécutés par un humain conformément aux règles du dépôt.

### Neutres
- Documentation à jour requise : QUICK_START_COPILOT.md, docs/ARCHITECTURE.md et autres guides (Phase 4).

---

## Mise en œuvre

La mise en oeuvre suit l'AP 006 (Plan d'Action 006 — Compatibilité Copilot) et ses phases :

- Phase 1 (ARCos) — Établir le contrat de compatibilité par cible (CLI, VS Code, cloud) et produire `docs/plans/006_reports/PHASE_1_COMPLETION_REPORT.md`.
  - Inventaire des fichiers suivis, exclusions, matrices des champs transformés et décision par champ (conserver / adapter / partager / non supporté).
  - Rejet clair de toute assertion non sourcée.

- Phase 2 (DEVon) — Implémenter adaptations et adaptateurs limités au contrat vérifié.
  - Corriger profils, préserver sémantique des skills et gardes, ajouter adaptateurs de hooks si supportés.
  - Fichiers impactés (exemples) : `scripts/copilot-mapping.psd1`, `scripts/Sync-Description.psm1`, `scripts/sync-claude-to-github.ps1`, `.claude/skills/*`, `.claude/settings{,.template}.json`, `.claude/hooks/*`.

- Phase 3 (QALvin) — Tests et validation par cible.
  - Tests unitaires/intégration, scénarios réels, couverture ≥ 80 % pour code modifié.

- Phase 4 (DOCly) — Documentation finale et clôture; cette ADR est proposée avant Gate #1 conformément au plan.

Contraintes d'exécution :
- Aucun agent n'est autorisé à supprimer ou à pousser des fichiers automatiquement ; toute suppression identifiée doit être effectuée par un humain.
- Aucune action d'exécution shell ou web non autorisée dans cette session.
- Les preuves de compatibilité requises sont des exécutions observables ou références officielles datées ; des copies textuelles seules ne suffisent pas.

---

## Références

- [AP 006 — Compatibilité Copilot](../plans/006_compatibilite-copilot.plan.md)
- [Rapport d'analyse initiale](../plans/006_reports/PHASE_0_ANALYSIS_REPORT.md)
- [ADR 003 — Source Claude unique](003-claude-first-copilot-genere.md)
- [ADR 004 — Emplacement des plans](004-plans-hors-chemin-protege.md)

---

## Notes et Limitations

- Cette ADR est **Acceptée** après `GO` humain au Gate #1 le 2026-10-13. Elle complète l'ADR 003 sans la remplacer globalement ; l'acceptation de la stratégie ne certifie pas la compatibilité des cibles.
- Documentation officielle actuelle non consultée et scénarios non exécutés dans cette session faute outils web/shell exposés. Aucun support natif ni impossibilité de support Copilot n'est présenté comme vérifié.
- Gate #1 valide le plan avant Phase 1. Si le contrat révèle une modification majeure du périmètre ou une impossibilité de parité, MAINa soumet un ajustement humain avant Phase 2.
- Une référence officielle établit un contrat annoncé, pas une certification comportementale. Qualification « 100 % » réservée aux cibles dont tous les invariants obligatoires ont été effectivement vérifiés.