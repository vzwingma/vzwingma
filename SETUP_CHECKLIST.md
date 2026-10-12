# ✅ Checklist : Installer le harnais multi-agents dans un projet

Checklist pas à pas, depuis le ZIP (`claude-templates-*.zip` ou `copilot-templates-*.zip`) ou un clone de ce dépôt.
Guide rapide : `QUICK_START_CLAUDE.md` (Claude Code) / `QUICK_START_COPILOT.md` (GitHub Copilot).

---

## 🚀 Étape 1 : Copier les fichiers

### Claude Code

- [ ] `.claude/agents/` (5 agents + `README.md`)
- [ ] `.claude/skills/` (procédures, conventions par rôle, commandes)
- [ ] `.claude/hooks/` + `.claude/settings.template.json` (garde-fous)
- [ ] `.claude/PLANS.md` + `.claude/CLAUDE.template.md`
- [ ] `docs/ARCHITECTURE.template.md` et `docs/adr/ADR-TEMPLATE.md`

### GitHub Copilot

- [ ] `.github/agents/`, `.github/skills/`, `.github/instructions/` (templates par rôle)
- [ ] `.github/PLANS.md` + `.github/copilot-instructions.template.md`
- [ ] `docs/ARCHITECTURE.template.md` et `docs/adr/ADR-TEMPLATE.md`

---

## 🎯 Étape 2 : Initialiser

- [ ] Lancer `/init-harness` dans le projet (Claude Code ou Copilot). Il :
  1. analyse le code (stack, structure, commandes, conventions) ;
  2. génère `CLAUDE.md` / `copilot-instructions.md` depuis le template (fusion si déjà présent) ;
  3. remplit les conventions par rôle (Claude : skills `conventions-<rôle>` · Copilot : `.github/instructions/<rôle>.instructions.md`) ;
  4. Claude Code : fusionne `settings.template.json` dans `.claude/settings.json`, convertit `.copilotignore` en règles `deny`, adapte `role-boundaries.conf`, ajoute `*.sh text eol=lf` à `.gitattributes` ;
  5. crée `docs/ARCHITECTURE.md`, `docs/adr/`, `docs/plans/README.md` si absents ;
  6. liste les placeholders `[...]` restants.

---

## 🔧 Étape 3 : Valider et compléter

- [ ] Compléter les placeholders `[...]` signalés (aucun `[NOM_DU_PROJET]` restant)
- [ ] Vérifier les commandes build / lint / test dans les conventions (utilisées comme preuves aux gates)
- [ ] Supprimer les sections non applicables
- [ ] Compléter les sections **⚠️ À COMPLÉTER** de `docs/ARCHITECTURE.md`
- [ ] Plus tard, après évolution du projet : `/update-harness`

---

## ✨ Étape 4 : Premier test

### Claude Code (redémarrer la session après l'installation des settings)

- [ ] `/agents` → 5 agents avec leur modèle et leurs outils
- [ ] `/hooks` → hook `PreToolUse` `guard.sh` présent
- [ ] `/maina-help` → aide workflow + commandes
- [ ] `claude --agent MAINa` puis « Organise ce besoin de bout en bout : … » → options ARCos, **Gate #0** posé
- [ ] Demander « exécute `rm -f /tmp/inexistant` » → refus attendu (garde-fou)

### GitHub Copilot

- [ ] Agents visibles dans le sélecteur d'agents du chat
- [ ] `/maina-help` → aide workflow
- [ ] Agent MAINa : « Organise ce besoin de bout en bout : … » → options ARCos, demande de décision

---

## 📚 Étape 5 : Documenter et committer

- [ ] Ajouter au `README.md` du projet :
  ```markdown
  ## 🤖 Agents
  Ce projet utilise un harnais multi-agents orchestré (MAINa, ARCos, DEVon, QALvin, DOCly).
  Conventions et workflow : `.claude/CLAUDE.md` (ou `.github/copilot-instructions.md`).
  ```
- [ ] Committer :
  ```bash
  git commit -m "chore: installer le harnais multi-agents"
  ```

---

## 🎓 Utilisation courante

| Besoin | Commande |
|---|---|
| Initiative complète (cadrage → plan → code → tests → doc, 5 gates) | Claude : `claude --agent MAINa` ou `/maina <besoin>` · Copilot : agent MAINa |
| Analyse d'options d'architecture | `/arcos <problème>` |
| Implémentation d'une tâche du plan | `/devon <tâche>` |
| Tests | `/qalvin <cible>` |
| Documentation | `/docly <changements>` |
| Aide | `/maina-help` |

Parallélisation : seulement **au sein** d'une phase, jamais à travers un gate humain.

---

## 🔄 Maintenance continue

- [ ] Après un changement majeur : `/update-harness`
- [ ] Toute initiative structurante : Plan d'Action dans `docs/plans/` + ADR si décision majeure
- [ ] Mise à jour du harnais : récupérer le nouveau ZIP, comparer avec les fichiers projet (conventions et settings sont propres au projet)

---

**🎉 Prêt.** Guides : `.claude/README.md` · `.claude/PLANS.md` · `docs/ARCHITECTURE.md`.
