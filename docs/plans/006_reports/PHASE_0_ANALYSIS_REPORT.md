# AP 006 — Analyse initiale et formalisation

**Date :** 2026-10-13
**Agent :** ⚫ MAINa sur analyse 🟠 ARCos
**Statut :** Analyse statique consignée ; Gate #0 GO ; Gate #1 en attente
**Plan :** [006 — Compatibilité Copilot](../006_compatibilite-copilot.plan.md)

## Résultat

Choix humain : source Claude unique, projection Copilot ciblée et vérifiée. Pas de suppression globale de `.github`. Composants partagés directement uniquement après preuve de compatibilité native.

## Constats principaux

| Référence | Constat statique | Impact |
|---|---|---|
| `scripts/copilot-mapping.psd1`, profil ARCos | Outils d'édition/exécution et délégation malgré rôle lecture seule | Invariant non protégé |
| `scripts/Sync-Description.psm1` | Champs agents et skills supprimés sans compensation systématique | Préchargement, fork, routage et invocation non garantis |
| `scripts/sync-claude-to-github.ps1` | Pas de projection des hooks/settings ; conventions vers templates globaux | Parité des gardes et du contexte par rôle non prouvée |
| Mapping outils/modèles | Dépendances VS Code Java/Sonar et choix modèles spécifiques | Support CLI/IDE/cloud à établir séparément |
| `.claude/settings.json` / template | Hooks du dépôt vides alors que template branche garde | Référence Claude effective à vérifier également |
| `scripts/tests/eval-scenarios.ps1` | Évaluations Claude seulement ; codes de sortie non vérifiés | Faux positifs possibles sur assertions négatives |
| `scripts/check-harness.ps1` | Récursions sans exclusions préalables | Contrôle incompatible avec politique d'accès actuelle |
| `scripts/Package.psm1` | Suppression d'archive existante ; contenu variable selon état local | Politique de suppression et reproductibilité |
| Quick Start Copilot / architecture | Références de conventions absentes et ancien emplacement des plans | Installation et compréhension incohérentes |

## Couverture et limites

Lecture des scripts, tests et fixture autorisée ; analyse ARCos des familles agents, skills, hooks, settings, workflows, documentation, ADR, plans, diagrammes et configurations racine. Aucun manifeste Git exhaustif obtenu. Contenus exclus, sensibles, autres checkouts et liens externes non inspectés.

Aucun outil shell/web exposé : documentation officielle actuelle non consultée, statut Git et tests non exécutés. Disponibilité des agents et skills observée dans cette session, sans certifier mécanisme de découverte ni enforcement. Les affirmations non sourcées d'impossibilité native ou d'absence de hooks Copilot ne sont pas retenues comme faits.

## Alternatives

| Option | Avantages | Limites / effort | Décision |
|---|---|---|---|
| Fichiers Claude seuls | Suppression des copies de harnais | Équivalence complète non établie ; risque de perte de fonctions | Non retenue actuellement |
| Source Claude + projection ciblée | Préserve ADR 003 et adaptations nécessaires | Contrat et adaptateurs à vérifier ; effort moyen à élevé | GO humain |
| Socle neutre + adaptateurs | Partage plus large possible | Refonte plus importante ; découverte à vérifier | Évolution limitée possible après preuve |

## Relais

Créer ADR 005 proposée puis conduire Gate #1. Phase 1 reste bloquée sans accès aux sources officielles et moyens de vérification. Aucune commande ni modification du harnais n'est présentée comme validée.
