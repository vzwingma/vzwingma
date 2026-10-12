# 🏗️ Architecture — Dépôt Transverse Multi-Agents

> Architecture et principes de ce dépôt de templates multi-agents (harnais Claude Code, Copilot généré).

---

## 🎯 Vue d'ensemble

Ensemble réutilisable d'agents, skills et templates pour orchestrer le développement avec des assistants IA
via une architecture **multi-agents coordonnée** et des **gates humains** stricts.

| Propriété | Valeur |
|---|---|
| **Type** | Dépôt de templates / harnais multi-agents |
| **Stack principale** | Markdown + frontmatter YAML ; tooling PowerShell (5.1 / 7) |
| **Plateforme source** | Claude Code (`.claude/`) |
| **Plateforme générée** | GitHub Copilot (`.github/`, ne jamais éditer à la main) |
| **Langue** | Français (contenu), anglais (code, scripts) |
| **Distribution** | ZIP (`scripts/package-*.ps1`) + copie manuelle |

**Philosophie :** *« Écrire une fois, réutiliser partout »*
- 🎯 **Généricité** : agents stables d'un projet à l'autre ; spécificités dans les conventions par rôle
- 🔧 **Customisation minimale** : placeholders `[...]` remplis par `/init-harness`
- 🔄 **Versionnage** : chaque agent porte une version (corps + CHANGELOG)
- 🛡️ **Traçabilité** : Plan d'Action persisté + journal des gates pour toute initiative

---

## 🏢 Architecture Globale

### Séparation des responsabilités

```
.claude/
├── agents/        # Comportements génériques (frontmatter natif : model, tools, skills)
├── skills/        # Procédures partagées · conventions projet par rôle · commandes
├── plans/         # Plans d'Action + rapports de phase + archive
├── CLAUDE.md      # Instructions de ce dépôt (maintenu à la main)
└── CLAUDE.template.md
docs/              # Documentation du dépôt + templates (ARCHITECTURE, ADR)
scripts/           # Génération Copilot + packaging
.github/           # GÉNÉRÉ depuis .claude/ (Copilot)
```

### Flux d'utilisation (projet consommateur)

```
Nouveau projet
    → copier .claude/agents, .claude/skills, PLANS.md, CLAUDE.template.md, templates docs/
    → /init-harness
        → .claude/CLAUDE.md + conventions-<rôle> remplis depuis le code
    → claude --agent MAINa   (ou /maina <besoin>)
        → ⚫ MAINa orchestre ; chaque agent précharge ses conventions :
            ├── 🟠 ARCos  ← conventions-architect + docs/ARCHITECTURE.md
            ├── 🔵 DEVon  ← conventions-dev
            ├── 🟢 QALvin ← conventions-qa
            └── 🟣 DOCly  ← conventions-doc
```

### Principes architecturaux

| Principe | Description |
|---|---|
| **Réutilisabilité** | Agents et procédures génériques, prêts à l'emploi |
| **Séparation des préoccupations** | Agents = comportement · Conventions = valeurs projet · Commandes = automatisation |
| **Chargement déterministe** | Conventions et procédures préchargées par agent (`skills:`), pas « lues au démarrage » |
| **Gates humains** | Gate #0 → #4 ; seul l'agent principal (MAINa) peut interroger 👤 |
| **Source unique** | `.claude/` ; Copilot généré et vérifié (`-Check`) |

### Modèle Claude-first : source unique + génération Copilot

Les agents, skills et templates sont **écrits une seule fois** dans `.claude/` (source de vérité, optimisée Claude Code), puis **générés** vers `.github/` (GitHub Copilot) par `scripts/sync-claude-to-github.ps1` : frontmatter Copilot dérivé (`scripts/copilot-mapping.psd1`), substitution de chemins/termes, blocs `claude-only` / `copilot-only`, variantes `SKILL.copilot.md`, conventions → `.github/instructions/*.instructions.template.md`. OpenCode est retiré. Voir [ADR 003](adr/003-claude-first-copilot-genere.md) (remplace [ADR 002](adr/002-claude-miroir-genere.md)).

> Ne jamais éditer `.github/` à la main : `sync-claude-to-github.ps1 -Check` échoue si `.github/` diverge.

---

## 📂 Structure des Dossiers

```
.
├── README.md                     # Profil GitHub
├── QUICK_START_CLAUDE.md         # Démarrage rapide Claude Code (source)
├── QUICK_START_COPILOT.md        # Démarrage rapide Copilot (généré)
├── SETUP_CHECKLIST.md            # Checklist d'initialisation
├── docs/
│   ├── ARCHITECTURE.md           # Ce fichier
│   ├── ARCHITECTURE.template.md  # Template à copier dans les projets
│   ├── adr/                      # ADR + ADR-TEMPLATE.md
│   └── diagrams/                 # Diagrammes d'orchestration (Mermaid, PlantUML)
├── scripts/                      # sync-claude-to-github, package-claude, package-github
├── .claude/
│   ├── agents/                   # 5 agents + README (configuration)
│   ├── skills/                   # voir « Skills » ci-dessous
│   ├── plans/                    # Plans d'Action, rapports, archive/
│   ├── CHANGELOG.md · PLANS.md · README.md
│   └── CLAUDE.md · CLAUDE.template.md
└── .github/                      # GÉNÉRÉ (agents, skills, instructions, copilot-instructions*.md)
```

---

## 🔧 Composants Principaux

### 🤖 Agents (`.claude/agents/`)

| Agent | Fichier | Version | Modèle | Rôle |
|---|---|---|---|---|
| ⚫ MAINa | `Maina.agent.md` | v1.5 | `opus` | Maître orchestrateur — agent principal de session, crée le Plan d'Action, tient les gates |
| 🟠 ARCos | `Arcos.agent.md` | v4.8 | `opus` | Architecte en lecture seule : ≥ 2 options + recommandation |
| 🔵 DEVon | `Devon.agent.md` | v4.4 | `sonnet` | Implémentation + preuves (build, lint, tests existants) |
| 🟢 QALvin | `Qalvin.agent.md` | v4.5 | `sonnet` | Tests et couverture |
| 🟣 DOCly | `Docly.agent.md` | v4.4 | `sonnet` | Documentation, ADR |

Outils et skills préchargés par agent : [`.claude/agents/README.md`](../.claude/agents/README.md).
Les sous-agents n'ont pas accès à `AskUserQuestion` : ils remontent leurs questions (`❓ Questions pour 👤`)
à MAINa, qui les pose au gate.

### 🛠️ Skills (`.claude/skills/`)

| Catégorie | Skills | Chargement |
|---|---|---|
| Procédures | `plan-creation`, `plan-phase-execution`, `adr-writing`, `parallel-guide` | Préchargées par les agents concernés (`user-invocable: false`) |
| Conventions projet | `conventions-orchestrator`, `-architect`, `-dev`, `-qa`, `-doc` | Préchargées par le rôle correspondant ; templates remplis par `/init-harness` |
| Rappels sécurité | `safety-rules`, `copilotignore` | Sur besoin ; règles de référence dans `CLAUDE.md` |
| Commandes | `/maina`, `/arcos`, `/devon`, `/qalvin`, `/docly`, `/maina-help`, `/init-harness`, `/update-harness` | Utilisateur uniquement (`disable-model-invocation: true`) |

`/arcos`, `/devon`, `/qalvin`, `/docly` s'exécutent en sous-agent forké (`context: fork`) ; `/maina`
s'exécute dans la session courante (gates interactifs).

### 📄 Templates

| Fichier | Rôle |
|---|---|
| `.claude/CLAUDE.template.md` | Template de `CLAUDE.md` projet |
| `.claude/skills/conventions-*/SKILL.md` | Conventions par rôle (placeholders) |
| `.claude/skills/plan-creation/templates/plan.template.md` | Modèle de Plan d'Action (avec journal des gates) |
| `.claude/skills/plan-phase-execution/templates/phase-report.template.md` | Modèle de rapport de phase |
| `docs/ARCHITECTURE.template.md` | Template `docs/ARCHITECTURE.md` |
| `docs/adr/ADR-TEMPLATE.md` | Template ADR |

---

## 📐 Conventions et Invariants

### Agents — génériques
- Aucune référence à un projet spécifique dans les `*.agent.md`
- Frontmatter natif Claude Code uniquement (`name`, `description`, `model`, `tools`, `skills`, `color`, …)
- Incrémenter la version à chaque modification comportementale

### Conventions projet — spécifiques
- Remplies projet par projet (`/init-harness`), maintenues via `/update-harness`
- Refléter les conventions réelles du code (pas d'hypothèse)

### Templates — placeholders clairs
- Format : `[DESCRIPTION_DE_CE_QUI_MANQUE]` (ex. `[NOM_DU_PROJET]`, `[COMMANDE_TEST]`)
- Exemples illustratifs en commentaire, jamais de valeurs d'un projet réel

### Plateformes
- Contenu propre à Claude : `<!-- claude-only -->…<!-- /claude-only -->` ; propre à Copilot : `<!-- copilot-only … -->`
- Skill dont la version Copilot diffère : `SKILL.copilot.md` à côté de `SKILL.md`

---

## 🗺️ Décisions Architecturales (ADR)

> Les décisions architecturales majeures sont documentées dans `docs/adr/`.  
> Format : `docs/adr/NNN-titre-court.md` — utiliser `docs/adr/ADR-TEMPLATE.md` comme base.

| # | Décision | Statut | Date |
|---|---|---|---|
| 001 | [Ajouter MAINa comme orchestrateur principal](adr/001-maina-orchestrateur.md) | Acceptée | 2026-06-25 |
| 002 | [`.claude/` = miroir généré de `.github/`](adr/002-claude-miroir-genere.md) | Remplacée par 003 | 2026-06-29 |
| 003 | [Claude-first : `.claude/` source unique, Copilot généré, OpenCode retiré](adr/003-claude-first-copilot-genere.md) | Acceptée | 2026-10-12 |

> 💡 Chaque nouvelle décision majeure sur ce dépôt transverse doit faire l'objet d'un ADR.

---

## 🔄 Maintenance

### Mise à jour d'un agent ou d'un skill

1. Modifier `.claude/agents/<Agent>.agent.md` ou `.claude/skills/<nom>/SKILL.md` (jamais `.github/`)
2. Agent : incrémenter la version (ligne `> **Version**`) et documenter dans `.claude/CHANGELOG.md`
3. Régénérer Copilot : `scripts/sync-claude-to-github.ps1`, puis `-Check` (doit sortir en 0)

### Mapping Copilot

Modèles, outils et sous-agents Copilot : `scripts/copilot-mapping.psd1` (voir [`scripts/README.md`](../scripts/README.md)).

---

## 📝 Historique des Versions

| Version | Date | Changements majeurs |
|---|---|---|
| v5.0 | 2026-10-12 | Claude-first (ADR 003) : `.claude/` source, Copilot généré, OpenCode retiré ; agents à frontmatter natif ; conventions par rôle en skills préchargés ; commandes `/init-harness`, `/update-harness` |
| v4.0 | 2026-06-29 | Modèle miroir : `.github/` source → `.claude/` généré (sync) ; ADR 002 ; ARCos recentré (MAINa crée le plan) |
| v3.2 | 2026-06-25 | Ajout MAINa (maître-orchestrateur) ; rationalisation agents ; skills `maina-help`, `compact-context` |
| v3.1 | 2026-06-11 | Suppression agent FINNops ; ajout skills `adr-writing` et `caveman-default` |
| v3.0 | 2026-05-28 | Activation globale du mode `caveman` dans tous les agents + compression des instructions |
| v2.1 | 2026-05-07 | Migration wiki → `/docs` ; ajout templates ARCHITECTURE.md et ADR |
| v2.0 | 2026-05-05 | Ajout parallélisation `/fleet` dans tous les agents |

---

## 🔗 Ressources

- **Guide `.claude/`** : [`.claude/README.md`](../.claude/README.md)
- **Guide Plans d'Action** : [`.claude/PLANS.md`](../.claude/PLANS.md)
- **Scripts** : [`scripts/README.md`](../scripts/README.md)
- **Checklist** : [`SETUP_CHECKLIST.md`](../SETUP_CHECKLIST.md)
- **ADRs** : [`docs/adr/`](./adr/)
