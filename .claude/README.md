# 📚 Claude Code Agents & Templates — Dépôt Transverse

Ce sous-arbre `.claude/` contient les **artefacts Claude réutilisables** du dépôt : agents, skills (procédures, conventions projet, commandes) et plans d'action.

Il sert de point d'entree pour comprendre **qui fait quoi**, **comment les agents se coordonnent** et **quels fichiers copier ou maintenir** sans surcharger chaque `*.agent.md`.

---

## 📂 Structure

```
.claude/
├── agents/                              # 5 agents Claude generiques
│   ├── Maina.agent.md                   # Maitre orchestrateur
│   ├── Arcos.agent.md                   # Architecture (consulté par MAINa)
│   ├── Devon.agent.md                   # Implementation
│   ├── Qalvin.agent.md                  # Tests
│   └── Docly.agent.md                   # Documentation
├── skills/                              # Procédures, conventions par rôle (templates), commandes
├── plans/                               # Plans d'Action et rapports
├── CHANGELOG.md                         # Historique des versions des agents
├── PLANS.md                             # Guide des Plans d'Action
├── README.md                            # Ce fichier
├── CLAUDE.md              # Instructions de ce depot transverse
└── CLAUDE.template.md     # Template a copier dans les projets
```

<!-- claude-only -->
Garde-fous : `hooks/` (`guard.sh` hook `PreToolUse` + `role-boundaries.conf`), `settings.json` (ce dépôt),
`settings.template.json` (à fusionner dans les projets via `/init-harness`).
<!-- /claude-only -->

---

## 🚀 Quick Start : reutiliser le sous-arbre `.claude/`

### Etape 1 : Copier les artefacts utiles

Selon le projet cible, copier :

- `.claude/agents/`
- `.claude/skills/`
<!-- claude-only -->
- `.claude/hooks/` + `.claude/settings.template.json` (garde-fous : permissions + hook `PreToolUse`)
<!-- /claude-only -->
- `.claude/PLANS.md`
- `.claude/CLAUDE.template.md`

### Etape 2 : Initialiser les instructions projet

Lancer `/init-harness` : analyse du code, génération de `CLAUDE.md`, remplissage des conventions par rôle (`conventions-<rôle>`).

### Etape 3 : Utiliser les agents

Les agents peuvent ensuite etre invoques selon le besoin :

- `MAINa` pour orchestrer workflow complet<!-- claude-only --> — en agent principal : `claude --agent MAINa` (gates interactifs)<!-- /claude-only -->
- `ARCos` pour analyser les options et concevoir (lecture seule)
- `DEVon` pour implementer
- `QALvin` pour tester
- `DOCly` pour documenter

---

## 📖 Fichiers cles

### Agents (`.claude/agents/`)

| Agent | Role | Quand l'utiliser |
|---|---|---|
| **Maina.agent.md** (⚫ MAINa) | Maitre orchestrateur + créateur Plan d'Action | "`/maina-help`", "`@MAINa /maina-help`", "orchestrer workflow complet" |
| **Arcos.agent.md** (🟠 ARC) | Expert architecture consulté par MAINa | "Analyse les options pour...", "Conçois architecture pour..." |
| **Devon.agent.md** (🔵 DEV) | Implementateur | "Implémente cette fonctionnalité" |
| **Qalvin.agent.md** (🟢 QUAL) | QA / tests | "Écris des tests pour..." |
| **Docly.agent.md** (🟣 DOC) | Documentation | "Mets à jour la documentation" |

Les agents restent focalises sur leurs instructions runtime. La vue transverse et la coordination sont documentees ici pour eviter la duplication.

<!-- claude-only -->
### Conventions projet (`.claude/skills/conventions-<rôle>/`)

| Skill | Agent | Rôle |
|---|---|---|
| `conventions-orchestrator` | ⚫ MAINa | Orchestration, gates humains, délégation |
| `conventions-architect` | 🟠 ARCos | Couches, état, accès données, intégrations |
| `conventions-dev` | 🔵 DEVon | Stack technique, versions, commandes, conventions de code |
| `conventions-qa` | 🟢 QALvin | Framework de test, commandes CI, couverture, cas à couvrir |
| `conventions-doc` | 🟣 DOCly | Cibles documentaires et conventions de doc |

Préchargés par l'agent correspondant (frontmatter `skills:`). Templates à remplir via `/init-harness`.
<!-- /claude-only -->
<!-- copilot-only
### Instructions projet (`.claude/instructions/`)

Un fichier par rôle (`orchestrator`, `architect`, `dev`, `qa`, `doc`) : `<rôle>.instructions.md`, créé depuis `<rôle>.instructions.template.md` via `/init-harness`.
-->

### Commandes (`.claude/skills/`)

| Commande | Utilisation |
|---|---|
| `/init-harness` | Initialiser le harnais dans un projet (nouveau ou existant) |
| `/update-harness` | Auditer et mettre à jour CLAUDE.md + conventions depuis le code |
| `/maina-help` | Aide workflow MAINa |
| `/maina`, `/arcos`, `/devon`, `/qalvin`, `/docly` | Activer un agent sur une demande |

### Plans et gouvernance

| Fichier | Role |
|---|---|
| `PLANS.md` | Guide complet de creation / execution des Plans d'Action |
| `plans/README.md` | Index des plans et statut global |
| `CHANGELOG.md` | Historique de version des 5 agents |

---

## 🤝 Relations entre agents

Le workflow cible reste simple et strict :

1. 👤 **Developpeur humain** cadre le besoin et valide chaque livrable cle.
2. ⚫ **MAINa** orchestre sequence, delegations et cree le Plan d'Action.
3. 🟠 **ARCos** analyse les options, compare les solutions et fournit recommandation à MAINa.
4. ✅ **Validation humaine** du choix de solution.
5. ⚫ **MAINa** cree le Plan d'Action et le soumet.
6. ✅ **Validation humaine** du plan.
7. 🔵 **DEVon** implemente selon le plan valide.
8. ✅ **Validation humaine** du code.
9. 🟢 **QALvin** ecrit et execute les tests.
10. ✅ **Validation humaine** des tests.
11. 🟣 **DOCly** synchronise la documentation.
12. ✅ **Validation humaine** finale.

Relations de passage :

- `MAINa` sollicite `ARCos` (analyse solutions) → `MAINa` crée plan → `DEVon` → `QALvin` → `DOCly`
- `DEVon` → `QALvin`, puis `DOCly`
- `QALvin` → `DOCly`
- chaque etape importante revient vers le 👤 Developpeur humain pour validation

> Les agents n'ont plus besoin de porter chacun ce schema ; ils pointent vers ce README.

---

## 🎯 Workflow typique

```
1. Besoin cadre par le developpeur humain
   ↓
2. MAINa orchestre et consulte ARCos (analyse solutions)
   ↓
3. Validation humaine (choix solution)
   ↓
4. MAINa cree Plan d'Action
   ↓
5. Validation humaine plan
   ↓
6. DEVon implemente
   ↓
7. Validation humaine code
   ↓
8. QALvin valide par les tests
   ↓
9. Validation humaine tests
   ↓
10. DOCly met a jour la documentation
    ↓
11. Validation humaine finale
    ↓
12. Phase suivante / cloture du plan
```

Pour les details de phases, de rapports et de dependances, voir `PLANS.md`.

---

## ✅ Checklist de maintenance

- Modifier un agent => incrementer sa version dans le frontmatter
- Reporter la modification dans `CHANGELOG.md`
- Synchroniser les versions dans `CLAUDE.md` et `CLAUDE.template.md`
- Mettre a jour `plans/README.md` a chaque nouveau Plan d'Action
- Garder ce README comme source de verite pour la coordination transverse `.claude/`

---

## 📚 Ressources

- `README.md` racine : presentation generale du depot
- `docs/ARCHITECTURE.md` : architecture transverse globale
- `.claude/PLANS.md` : format et execution des Plans d'Action
- `.claude/CLAUDE.md` : instructions detaillees du depot Claude
