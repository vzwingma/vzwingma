# Phase 5 : Workflow strict fiabilisé

**Plan :** `.claude/plans/005_claude-first.plan.md`
**Responsable Agent :** 🟠 ARCos (conception du protocole) → 🔵 DEVon
**Date Début :** 2026-10-12
**Date Fin :** 2026-10-12
**Statut :** ✅ COMPLÉTÉE — validation 👤 en attente

---

## 📝 Tâches

### T5.1 - MAINa en thread principal

**Statut :** ✅ DONE (couvert par P2/P3, vérifié)
- `Maina.agent.md` (« Mode d'exécution » : `claude --agent MAINa`, `AskUserQuestion`, `Agent`, `SendMessage`), `/maina` inline, `/maina-help`, `CLAUDE.md`, `agents/README.md`, `docs/ARCHITECTURE.md` alignés.
- Plus aucune instruction ne délègue MAINa en sous-agent pour un workflow à gates.

### T5.2 - Protocole de gate

**Statut :** ✅ DONE

**Fichier créé :** `.claude/skills/gate-protocol/SKILL.md` (`user-invocable: false`, **préchargé par MAINa**)
- Déroulé en 6 étapes : collecter livrable + handoff → contrôler les preuves (relance de l'agent si manquantes, **pas de gate sur livrable incomplet**) → présenter (≤ 15 lignes) → décision via `AskUserQuestion` (`GO` / `AJUSTER` / `STOP`, questions des agents dans le même appel) → ligne de journal → action (`AJUSTER` = relance du même agent via `SendMessage`, `STOP` = plan `❌ Bloqué` + index + ADR `Rejetée`).
- **Table des preuves exigées** pour chacun des gates #0 → #4.
- Variante Copilot (blocs `copilot-only`) : question explicite au chat.

### T5.3 - Revue automatique avant Gate #2

**Statut :** ✅ DONE
- Intégrée à `gate-protocol` : skills `code-review` (niveau `medium`) puis `security-review` sur le diff de la phase ; synthèse bloquant / non bloquant jointe au gate ; finding bloquant → `AJUSTER` recommandé. Indisponibilité des skills → signalée au gate.
- `MAINa` dispose de `Skill` et `Bash` (lecture/preuves) pour l'exécuter.

### T5.4 - Preuves DEVon / QALvin

**Statut :** ✅ DONE
- DEVon (depuis P2) : build + lint + tests existants verts, commandes + résultats.
- **QALvin** : section « Preuves obligatoires avant handoff » — résultats, couverture vs seuil `conventions-qa` (défaut ≥ 80 %), **détection de régression démontrée** (casser → un test échoue → rétablir), tests ignorés listés.

### T5.5 - Contrat de handoff

**Statut :** ✅ DONE
- **Modèle** `.claude/skills/plan-phase-execution/templates/handoff.template.md` : bloc YAML `handoff` (plan, phase, agent, tâches, `status` done/partial/blocked, rapport, fichiers, critères avec preuve, commandes + résultats, risques, questions, suite) + règles (`met: true` jamais sans preuve).
- `plan-phase-execution` : bloc `handoff` obligatoire en fin de réponse.
- Agents : sections « Relais après phase » de DEVon, QALvin, DOCly réécrites (bloc handoff au lieu de messages libres) ; ARCos : bloc handoff en point 7 du format de sortie ; MAINa : templates de délégation exigeant preuves + handoff, contrôle des preuves au gate.

### T5.6 - Cycle de vie des ADR

**Statut :** ✅ DONE
- `adr-writing` : rédaction entre Gate #0 et Gate #1 en **`Proposée`** ; `Acceptée` au `GO` du Gate #1 (MAINa) ; `Rejetée` sur `STOP` ; table du cycle de vie ; checklist corrigée (ancienne règle « toujours Acceptée » retirée).
- Exception d'ordre assumée et documentée : 🟣 DOCly rédige l'ADR **avant** Gate #3 (agent + skill).
- `docs/adr/ADR-TEMPLATE.md` : statut `Rejetée` ajouté ; lien de plan `.github/plans/` → `.claude/plans/`.
- `role-boundaries.conf` : MAINa autorisé sur `docs/adr/*` (mise à jour du statut) ; test ajouté.
- `plan-creation`, template de plan, `CLAUDE.md` / `CLAUDE.template.md` (règle MAINa), `PLANS.md` alignés.

**Cascade :** tables des skills (`CLAUDE.md`, template, `ARCHITECTURE.md`), table de configuration des agents (`agents/README.md`, skills préchargés à jour), `CHANGELOG.md` (entrées AP 005 « P2-P5 »).

---

## 📊 Synthèse de Phase

**Tâches complétées :** 6/6
**Critères de réussite :**
- ✅ Protocole de gate imposant l'entrée « Journal des gates »
- ✅ Handoff YAML exigé des 4 agents exécutants, consommé par MAINa

**Preuves :**
- Validation frontmatter : 18 skills conformes ; préchargements des 5 agents présents (MAINa : `conventions-orchestrator`, `plan-creation`, `gate-protocol`).
- `bash scripts/tests/guard.tests.sh` → **55 passed, 0 failed** (cas MAINa → `docs/adr/*` ajouté).
- `sync-claude-to-github.ps1 -Check` : exit 0, 0 orphelin ; pas de `AskUserQuestion`, `SendMessage`, `/code-review`, blocs plateforme côté `.github/` (hors exemple de journal et CHANGELOG).
- ⚠️ Non testé en runtime (CLI headless non authentifiée) : déroulé complet d'un gate avec `AskUserQuestion` et `code-review` — prévu en P7 (scénarios).

**Bloqueurs :** Aucun
**Points d'attention :**
- Le bloc handoff ajoute ~20 lignes par réponse d'agent : coût de contexte assumé pour la traçabilité.
- `code-review` / `security-review` sont des skills intégrés à Claude Code : disponibilité selon la version/l'offre du consommateur → le protocole prévoit de le signaler au gate.

**❓ Questions pour 👤 :** aucune.
**Prochaine phase :** P6 (Copilot généré + docs + anti-dérive : `CLAUDE.md` ≤ 200 l., `check-harness`, CI, packaging) — après validation 👤.
