# 🤖 .claude — Configuration Claude Code

Structure de configuration pour Claude Code (cli.claude.ai).

## 📂 Structure

```
.claude/
├── README.md                  # Ce fichier
├── agents/                    # Agents spécialisés
│   ├── README.md             # Index agents
│   ├── Arcos.agent.md        # 🟠 Architecte
│   ├── Devon.agent.md        # 🔵 Implémentateur
│   ├── Qalvin.agent.md       # 🟢 Expert QA
│   ├── Docly.agent.md        # 🟣 Gardien docs
│   └── Maina.agent.md        # ⚫ Orchestrateur
├── templates/                # Templates réutilisables
│   └── [à créer]
└── workflows/                # Workflows Claude
    └── [à créer]
```

## 🤖 Agents

5 agents spécialisés orchestrant développement :

| Agent | Rôle | Quand l'utiliser |
|-------|------|------------------|
| **⚫ MAINa** | Orchestrateur principal | Point d'entrée pour travail complexe |
| **🟠 ARCos** | Architecte | "Conçois architecture", "Crée plan" |
| **🔵 DEVon** | Implémentateur | "Implémente fonctionnalité" |
| **🟢 QALvin** | Expert QA | "Écris tests", "Ajoute couverture test" |
| **🟣 DOCly** | Gardien docs | "Mets à jour doc", "Garde docs en sync" |

**→ Voir [`agents/README.md`](./agents/README.md) pour détails complets.**

## 📖 Workflow strict

```
Besoin → MAINa intake
        ↓
       ARCos : plan & architecture
        ↓ (validation humaine)
       DEVon : implémentation
        ↓ (validation humaine)
       QALvin : tests
        ↓ (validation humaine)
       DOCly : documentation
        ↓ (validation humaine)
       ✅ Clôture
```

Chaque étape requiert **validation humaine** avant progression.

## 🚀 Démarrage rapide

### Travail simple

Invoquer agent spécifique directement :

```bash
# Concevoir architecture
claude.ai/code → Mention ARCos → "Conçois architecture pour..."

# Implémenter fonction
claude.ai/code → Mention DEVon → "Implémente cette fonctionnalité..."
```

### Travail complexe (multi-phases)

Utiliser MAINa comme orchestrateur :

```bash
claude.ai/code → Mention MAINa → "J'ai ce besoin : ..."

# MAINa :
# 1. Clarifie avec toi
# 2. Active ARCos pour plan
# 3. Attend validation
# 4. Active DEVon pour code
# ... etc jusqu'à clôture
```

## 🔐 Règles absolues

Tous agents respectent :

- ⛔ **Ne JAMAIS** supprimer fichiers/répertoires
- ⛔ **Ne JAMAIS** exécuter commandes SQL destructives
- ⛔ **Ne JAMAIS** `git clean`, `git reset --hard`
- ⛔ **Ne JAMAIS** modifier fichiers hors périmètre
- ⛔ **Respect ABSOLU** `.copilotignore`

En cas doute → demander confirmation.

## 📝 Instructions projet (optionnelles)

Personnaliser agents par projet :

- `.github/instructions/architect.instructions.md` → ARCos
- `.github/instructions/dev.instructions.md` → DEVon
- `.github/instructions/qa.instructions.md` → QALvin
- `.github/instructions/doc.instructions.md` → DOCly

Agents lisent automatiquement au démarrage si présent.

## 🎓 Exemples

### Exemple 1 : Feature simple

```
Toi : @Devon "Crée composant Card avec props title, description"

Devon analyse patterns existants → code → signale
↓ (tu valides)
@QALvin "Écris tests pour ComponentCard"

QALvin écrit tests → valide couverture → signale
↓ (tu valides)
@DOCly "Ajoute ComponentCard au README"

DOCly met à jour docs → clôture
```

### Exemple 2 : Initiative complexe

```
Toi : @MAINa "Nous avons besoin d'un système auth complet"

MAINa :
1. Clarifie besoins, périmètre
2. Appelle ARCos pour concevoir
3. Attend ta décision sur plan
4. Appelle DEVon pour coder
5. Attend ta validation code
6. Appelle QALvin pour tests
7. Attend ta validation tests
8. Appelle DOCly pour docs
9. Clôture initiative
```

## 📚 Références

- [ARCos Agent](./agents/Arcos.agent.md) — Planification et architecture
- [DEVon Agent](./agents/Devon.agent.md) — Implémentation
- [QALvin Agent](./agents/Qalvin.agent.md) — Tests
- [DOCly Agent](./agents/Docly.agent.md) — Documentation
- [MAINa Agent](./agents/Maina.agent.md) — Orchestration

---

**Dernière mise à jour** : 2026-06-25
