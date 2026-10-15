# Plan d'Action 006 — Compatibilité Copilot du harnais Claude-first

**Document :** `docs/plans/006_compatibilite-copilot.plan.md`
**Date de création :** 2026-10-13
**Statut :** 🔄 Ajusté au Gate #1 (2026-10-15) — périmètre réduit à Copilot CLI ; Phase 1 à reprendre sur la cible CLI (validation comportementale en attente)
**Objectif Prioritaire :** HIGH
**ADR associé :** [ADR 005 — Projection Copilot ciblée et vérifiée](../adr/005-projection-copilot-verifiee.md) — Acceptée (Gate #1, 2026-10-13)
**Rapports :** [`006_reports/`](006_reports/)

---

## 🎯 Objectif Global

Rendre le harnais Claude-first utilisable dans GitHub Copilot sans maintenir une seconde source de contenu, en préservant les rôles, skills, activités et gates définis pour Claude. Remplacer la projection « best-effort » non vérifiée par un contrat de compatibilité explicite et des preuves indépendantes du générateur.

La compatibilité « 100 % » signifie que tous les invariants obligatoires passent sur chaque cible annoncée. Une fonctionnalité indisponible, une approximation déclarative ou un scénario non exécuté interdit cette qualification pour la cible concernée.

### Solution retenue (Gate #0)

**Option B**, validée par 👤 le 2026-10-13 : `.claude/` reste source unique ; projection Copilot ciblée et corrigée ; partage direct et réduction des copies uniquement après preuve de compatibilité native. Ni suppression globale de `.github/`, ni duplication de contenu maintenu manuellement.

Alternatives : fichiers Claude seuls (moins de duplication, équivalence native non établie) ; socle neutre partagé avec adaptateurs (refonte plus importante, contraire à la priorité Claude-first si appliquée intégralement).

### Périmètre ajusté (Gate #1 — AJUSTER, 2026-10-15)

- **Cible unique : GitHub Copilot CLI.** VS Code et cloud agent sortent du périmètre de cette qualification ; leurs lignes de matrice restent documentaires et ne sont annoncées nulle part.
- Conséquences : pas de profil VS Code/cloud à produire en Phase 2 ; pas de test de parité VS Code/cloud en Phase 3 ; documentation Phase 4 limitée à Copilot CLI.
- Le `GO` précédent valide l'ADR 005 ; la portée de l'ADR doit être alignée sur ce périmètre par DOCly en Phase 4.

### État des preuves et contraintes

- Audit statique disponible ; aucune documentation officielle actuelle consultée, aucun test ni commande Git exécuté dans cette session faute outils web/shell exposés.
- Agents et skills exposés par l'hôte actuel : disponibilité observée, pas certification CLI/IDE/cloud.
- Inventaire exhaustif des fichiers suivis à établir en Phase 1 ; les affirmations natives non sourcées de l'analyse ne sont pas considérées comme preuves.
- AP 005 reste en cours, scénarios réels et clôture en attente. AP 006 le complète sans modifier son statut ni présumer ses preuves obtenues.
- Respecter les exclusions avant toute recherche, lecture, copie et exécution ; ne pas parcourir métadonnées Git, autres checkouts ou liens externes.
- Aucun fichier généré édité manuellement. Modifier source, variantes et adaptateurs, puis régénérer.
- Aucune suppression de fichier par un agent. Si une copie devient inutile, identifier les chemins concernés et faire exécuter son retrait par 👤 ; `GO` sur ce plan n'autorise pas cette opération.
- Aucun commit, push, changement de branche, appel modèle payant ou modification de configuration personnelle sans demande spécifique.

---

## 🛠️ Phases

### Phase 1 — Établir le contrat de compatibilité — 🔄 Reprise sur Copilot CLI

**Contexte :** les différences natives entre Copilot CLI, VS Code et cloud ne sont pas vérifiées. Cette phase précède toute implémentation ; elle ne modifie ni source du harnais ni rendu.

**Rapport :** [Phase 1 — vérification partielle et blocages](006_reports/PHASE_1_COMPLETION_REPORT.md). Gate #1 validé le 2026-10-13 ; les sources officielles GitHub ont été consultées et recoupées, mais aucun terminal n'est disponible pour l'inventaire Git, les versions installées ou les tests. T1.1 reste bloquée ; T1.2 reste incomplète (configuration effective et comportements non vérifiés). Ce blocage technique n'est pas une décision `STOP` et ne rejette pas l'ADR.

**Critères de réussite :**
- Inventaire des fichiers suivis dans le périmètre autorisé, avec exclusions et omissions explicites.
- Trois cibles étudiées séparément : CLI, VS Code et cloud ; versions, sources officielles consultées et dates consignées.
- Chaque capacité classée : native, adaptée, non supportée ou non vérifiée.
- Chaque invariant obligatoire associé à un scénario observable ; aucun statut « supporté » basé seulement sur une copie textuelle.

#### T1.1 - Vérifier découverte et schémas par cible
- **Agent :** 🟠 ARCos
- **Fichier(s) :** `docs/plans/006_reports/PHASE_1_COMPLETION_REPORT.md`
- **Couvrir :** instructions racine ; découverte `.claude`, `.github`, `.agents` ; agents, skills, invocation, modèles, outils, délégation, hooks et permissions ; différences d'hôte.
- **Acceptation :** matrice pour les trois cibles avec références officielles et versions ; chaque point non vérifiable explicitement bloqué. Aucun fait de compatibilité attribué à une source non consultée.

#### T1.2 - Définir invariants et stratégie de projection
- **Agent :** 🟠 ARCos
- **Fichier(s) :** même rapport Phase 1
- **Couvrir :** MAINa en session principale ; gates #0→#4 ; ARCos lecture seule ; scopes DEVon/QALvin/DOCly ; conventions et procédures ; exclusions ; commandes interdites ; plans et rapports ; initialization et packaging. Comparer configuration Claude effective et templates sans lire de secrets.
- **Acceptation :** chaque champ transformé possède une décision « conserver / adapter / partager / non supporté » ; capacités d'exécution susceptibles de contourner les rôles identifiées ; absence d'équivalent déterministe signalée, jamais masquée par de la prose.

**Relais :** MAINa contrôle le rapport avant DEVon. Si outils ou preuves manquent, Phase 1 reste bloquée. Si le contrat réduit le périmètre, change la solution ou révèle une impossibilité de parité, soumettre `AJUSTER` au Gate #1 avant implémentation ; pas de décision majeure déléguée implicitement.

### Phase 2 — Corriger source, projection et distribution — ⏳ Planifié

**Contexte :** dépend de Phase 1 et du Gate #1 validé. DEVon implémente uniquement le contrat vérifié ; n'écrit ni tests ni documentation utilisateur.

**Critères de réussite :**
- Profil ARCos sans capacité d'écriture/exécution mutante ni délégation d'implémentation ; autres rôles au moindre privilège compatible avec leur mission.
- Aucun outil d'extension locale imposé par le profil générique ; modèles et outils validés pour les cibles annoncées.
- Aucune perte silencieuse d'un invariant obligatoire dans la génération.
- Parcours et packages respectent exclusions ; génération idempotente et publication de rendu obsolète bloquée.

#### T2.1 - Corriger profils et chargement par rôle
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `scripts/copilot-mapping.psd1`, `scripts/Sync-Description.psm1`, `.claude/agents/{Maina,Arcos,Devon,Qalvin,Docly}.agent.md`
- **Implémenter :** profils par cible si nécessaires ; suppression des droits incohérents ; obtention des preuves par MAINa directement ou par délégation bornée ; procédures/conventions explicitement chargées. Préserver modèles Claude et ne pas forcer un nom Copilot non validé.
- **Acceptation :** cinq profils conformes au contrat ; zéro dépendance Java/Sonar imposée au générique ; aucun cumul global d'interdictions des cinq rôles.

#### T2.2 - Préserver sémantique des skills et gardes
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `scripts/Sync-Description.psm1`, `scripts/sync-claude-to-github.ps1`, `.claude/skills/*/{SKILL.md,SKILL.copilot.md}`, `.claude/settings{,.template}.json`, `.claude/hooks/*`
- **Implémenter :** traitement des champs supportés, fork/routage/invocation, initialization et contexte de rôle ; adaptateurs de gardes si supportés. Préserver contrat Claude. Les variantes restent dans la source unique.
- **Acceptation :** chaque transformation liée à T1.2 ; les gardes sont testables ou la cible reste non certifiée. Toute nouvelle cible de hooks/configuration doit avoir son chemin et schéma approuvés dans Phase 1 ; sinon revenir au Gate #1.

#### T2.3 - Fiabiliser contrôles et packages
- **Agent :** 🔵 DEVon
- **Fichier(s) :** `scripts/check-harness.ps1`, `scripts/Package.psm1`, `scripts/package-{claude,github}.ps1`, `.github/workflows/harness-check.yml`
- **Implémenter :** application des exclusions avant récursion ; schémas et liens de projection validés indépendamment du rendu attendu ; contrôle bloquant avant package ; dépendances tiers explicites ; sorties nouvelles sans suppression d'archive existante.
- **Acceptation :** exclusions appliquées dans tous les parcours concernés ; refus explicite de rendu périmé et d'écrasement interdit ; résultat reproductible à dépendances fixées.

**Preuves / Gate #2 :** build/lint applicables et tests existants verts, commandes et résultats ; génération puis `-Check` sans changement ; `git diff --stat` ; revues automatiques code et sécurité selon protocole. Si outils indisponibles ou script existant interdit, ne pas l'exécuter : signaler bloqueur et demander ajustement du scope avant correction hors rôle.

### Phase 3 — Tester contrats et comportements — ⏳ Planifié

**Contexte :** QALvin intervient après `GO` du Gate #2. Aucun changement de production ou documentation.

**Critères de réussite :**
- Tests unitaires/intégration du générateur, contrôles, gardes et packages verts ; couverture ≥ 80 % du code modifié mesurable.
- Scénarios Claude de non-régression et Copilot des cibles annoncées réellement exécutés ou marqués bloqués.
- Une CLI en erreur, un défaut d'authentification ou un agent non chargé ne peut produire de succès.
- Refus observés et preuves de régression enregistrés ; pas seulement absence de fichiers modifiés.

#### T3.1 - Tester transformations et distribution
- **Agent :** 🟢 QALvin
- **Fichier(s) :** `scripts/tests/sync.tests.ps1`, `scripts/tests/guard.tests.sh`, `scripts/tests/compatibility.tests.ps1`, `tests/fixtures/sample-app/**` hors exclusions
- **Couvrir :** rôles/outils, champs conservés ou adaptés, conventions, chemins/liens, exclusions, erreurs, idempotence, contenu des packages et drift. Adapter le nettoyage des tests sans suppression ni accès aux fichiers ignorés.
- **Acceptation :** tous les contrats T1.2 couverts ; cas limites et erreurs présents ; ≥ 80 % couverture avec méthode et limites documentées. Un défaut volontaire contrôlé fait échouer au moins un test pertinent.

#### T3.2 - Évaluer comportement réel Claude et Copilot
- **Agent :** 🟢 QALvin
- **Fichier(s) :** `scripts/tests/eval-scenarios.ps1`, `scripts/tests/eval-copilot-scenarios.ps1`, `docs/plans/006_reports/PHASE_3_COMPLETION_REPORT.md`
- **Couvrir :** découverte des cinq agents et skills distribuées, initialization, routage, conventions, gates #0→#4, MAINa principal, ARCos lecture seule, frontières dev/QA/doc, opérations interdites et exclusions. Tests IDE/cloud guidés si automatisation indisponible.
- **Acceptation :** codes de sortie et chargement effectif vérifiés ; réponse et effets observés ; journal des gates et arrêt réel à chaque gate ; matrice par cible sans faux positif. Appels payants/authentification/configuration personnelle soumis à accord distinct.

**Relais / Gate #3 :** résultats, couverture, régression et matrice de certification. Si un défaut de production apparaît, retour vers DEVon via MAINa puis nouvelle validation code ; QALvin ne le corrige pas lui-même. Toute cible obligatoire bloquée empêche qualification « 100 % » et clôture sans révision humaine explicite du périmètre.

### Phase 4 — Documenter support vérifié et clôturer — ⏳ Planifié

**Contexte :** DOCly intervient après `GO` du Gate #3, sauf rédaction de l'ADR proposée avant Gate #1.

**Critères de réussite :**
- Documentation annonce uniquement clients, versions et comportements prouvés.
- Quick Starts, checklist, architecture et guides d'initialization cohérents avec installations vierges.
- ADR acceptée et cohérente ; plan/index à jour sans modifier statut AP 005.
- Liens et rendu généré vérifiés ; aucune projection éditée manuellement.

#### T4.1 - Synchroniser documentation et guides
- **Agent :** 🟣 DOCly
- **Fichier(s) :** `.claude/{README.md,CLAUDE.md,CLAUDE.template.md,CHANGELOG.md,PLANS.md}`, `.claude/agents/README.md`, `.claude/skills/{init-harness,update-harness}/SKILL*.md`, `QUICK_START_CLAUDE.md`, `SETUP_CHECKLIST.md`, `scripts/README.md`, `docs/ARCHITECTURE{,.template}.md`, `docs/diagrams/orchestration-agents-activity.puml`
- **Couvrir :** source unique, adaptations, commandes propres aux clients, dépendances, limites et maintenance. Modifications des skills limitées à documentation alignée au comportement validé ; changement opérationnel renvoyé à DEVon.
- **Acceptation :** zéro instruction d'installation visant composant absent ; zéro affirmation de parité non prouvée ; documentation Copilot obtenue via génération (`QUICK_START_COPILOT.md`, `.github`).

#### T4.2 - Finaliser décision et rapports
- **Agent :** 🟣 DOCly
- **Fichier(s) :** `docs/adr/005-projection-copilot-verifiee.md`, `docs/plans/006_compatibilite-copilot.plan.md`, `docs/plans/006_reports/PHASE_4_COMPLETION_REPORT.md`, `docs/plans/README.md`
- **Acceptation :** ADR et rapport référencent preuves, limites et cibles supportées ; préparation de clôture sans présumer `GO` au Gate #4. MAINa marque le plan complété après validation humaine, dans le même changement que l'index.

---

## 📊 Résumé par Agent

| Agent | Tâches | Livrable |
|---|---|---|
| 🟠 ARCos | T1.1–T1.2 | Contrat de compatibilité et décisions de transformation, lecture seule hors rapport persisté par MAINa |
| 🔵 DEVon | T2.1–T2.3 | Source/adaptateurs, projection et distribution corrigées + preuves |
| 🟢 QALvin | T3.1–T3.2 | Tests, couverture, régression et comportements par cible |
| 🟣 DOCly | ADR préalable ; T4.1–T4.2 | ADR proposée, documentation et préparation de clôture |
| ⚫ MAINa | Orchestration | Plan, index, rapports, vérification des preuves et journal des gates |

## 📍 Dépendances entre Phases

```text
Gate #0 GO → Plan + ADR proposée → Gate #1
  → Phase 1 (contrat vérifié)
  → Phase 2 (code) → revue → Gate #2
  → Phase 3 (tests) → Gate #3
  → Phase 4 (documentation) → Gate #4 → clôture
```

Pas de parallélisation entre phases. Toute modification majeure révélée par Phase 1 exige nouvelle validation du plan. Rapports : `006_reports/PHASE_N_COMPLETION_REPORT.md`, créés au lancement de chaque phase.

## ✅ Critères de Succès Globaux

1. Une source maintenue ; projection minimale, déterministe et idempotente ; copies inutiles identifiées avec preuve, sans suppression par agents.
2. Matrice native/adaptée/non supportée pour Copilot CLI (seule cible), sourcée et datée.
3. Cinq rôles et gates #0→#4 conformes dans les cibles certifiées ; conventions/procédures chargées correctement.
4. Aucun invariant de garde ou d'exclusion perdu silencieusement ; aucun support déclaré « 100 % » sans preuve.
5. Tests verts, couverture ≥ 80 % du code modifié et régression détectée ; CLI en échec jamais interprétée comme succès.
6. Distribution reproductible et installation vierge vérifiée ; documentation alignée sans résidus de plateforme erronés.
7. Gates humains tous tracés ; ADR acceptée au Gate #1 ; clôture uniquement après Gate #4 et traitement explicite des bloqueurs.

## 🚦 Journal des gates

| Gate | Date | Objet | Décision 👤 | Notes |
|---|---|---|---|---|
| #0 | 2026-10-13 | Choix de solution | ✅ GO | Option B : source Claude unique + projection Copilot ciblée ; copies réduites après preuve native |
| #1 | 2026-10-13 | Validation AP 006 et ADR 005 | ✅ GO | Réponse humaine « go » ; ADR 005 Acceptée ; Phase 1 bloquée faute accès web/shell, aucune implémentation lancée |
| #1 (ajustement) | 2026-10-15 | Périmètre de compatibilité après preuves documentaires | 🔄 AJUSTER | Décision humaine : cible unique Copilot CLI ; VS Code et cloud agent hors périmètre. Revue du plan et de l'ADR 005 requise avant Phase 2 |
| #2 | — | Validation code et revues | ⏳ En attente | Après Phases 1–2 |
| #3 | — | Validation tests et comportements | ⏳ En attente | Après Phase 3 |
| #4 | — | Documentation et clôture | ⏳ En attente | Après Phase 4 |

## 📚 Références

- [Rapport d'analyse initiale](006_reports/PHASE_0_ANALYSIS_REPORT.md)
- [AP 005 — Claude-first](005_claude-first.plan.md)
- [ADR 003 — Source Claude unique](../adr/003-claude-first-copilot-genere.md)
- [ADR 004 — Emplacement des plans](../adr/004-plans-hors-chemin-protege.md)
- [Guide des plans source](../../.claude/PLANS.md)
