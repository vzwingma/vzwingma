# Instructions Claude — Template Générique

> **Utilisation** : Template pour init instructions Claude dans nouveau projet. Remplacer placeholders `[...]` par valeurs spécifiques projet.

## 🗿 Mode communication

Mode caveman **full** actif par défaut pour toute session. Règles :
- Supprimer : articles, remplissage (just/really/basically/actually/simplement), formules de politesse, hedging
- Fragments OK. Synonymes courts. Termes techniques exacts. Blocs de code inchangés.
- Désactiver uniquement sur demande explicite : `stop caveman` ou `normal mode`

---

### Regle obligatoire MAINa — plan + ADR

Toute initiative architecturale ou infrastructure (nouvelle fonctionnalite, migration, changement de composant) doit produire **avant** de marquer la tache terminee :
1. Un fichier `Plan d'Action` dans `.claude/plans/NNN_nom.plan.md` (incrementer le numero)
2. Un ADR dans `docs/adr/NNN-titre-court.md` si decision architecturale majeure
3. Une mise a jour de l'index `.claude/plans/README.md`

Ces livrables sont crees dans le meme lot que l'implementation, pas apres coup.

---

## 👋 Bienvenue ! Agents Claude et Relations

Projet **[NOM_DU_PROJET]** utilise **architecture multi-agents** orchestrée pour coordonner développement, tests et documentation via **Plans d'Action (AP)** structurés.

### 🤖 Les Agents et leurs Rôles

Cinq agents spécialisés travaillent ensemble, orchestrés par **👤 Développeur humain** :

#### **⚫ MAINa** [v1.4]
- **Rôle :** Maître orchestrateur, créateur du Plan d'Action et point d'entrée principal
- **Responsabilités :**
  - Cadrer la demande et piloter l'ordre des phases
  - Consulter ARCos (et autres agents) pour analyse solutions avant créer le plan
  - Créer le Plan d'Action complet en mode PLAN (skill plan-creation)
  - Orchestrer `DEVon -> QALvin -> DOCly`
  - Imposer validations humaines entre chaque phase
  - Expliquer fonctionnement via `/maina-help` et `@MAINa /maina-help`
  - Lire `.claude/instructions/orchestrator.instructions.md` au démarrage pour spécificités projet
- **Quand l'utiliser :** "`/maina-help`", "`@MAINa /maina-help`", "organise le workflow", "pilote cette initiative"
- **Livrable :** Plan d'Action validé + workflow orchestré, séquencé, traçable

#### **🟠 ARCos** [v4.6]
- **Rôle :** Expert architecture consulté par MAINa
- **Responsabilités :**
  - Analyser problèmes complexes et concevoir solutions architecturales
  - Présenter ≥2 options comparées avec recommandation motivée à MAINa
  - Prendre décisions stratégiques concernant techno, structure et approche
  - Préparer contenu ADR après décisions architecturales majeures
  - Lire `.claude/instructions/architect.instructions.md` au démarrage pour spécificités projet
  - Lire `docs/ARCHITECTURE.md` au démarrage pour comprendre contexte architectural projet
  - Exécuter tâches T*.* assignées dans le Plan d'Action créé par MAINa
- **Quand l'utiliser :** "Analyse les options pour...", "Conçois architecture pour...", "Quelle approche pour..."
- **Livrable :** Analyse comparative solutions + recommandation motivée

#### **🔵 DEVon** [v4.3]
- **Rôle :** Implémentateur code production
- **Responsabilités :**
  - Traduire exigences en code fonctionnel et testé
  - Respecter patterns architecturaux et conventions projet
  - Mettre à jour dépendances et refactoriser code
  - Implémenter optimisations performance
  - Lire `.claude/instructions/dev.instructions.md` au démarrage pour spécificités projet
- **Quand l'utiliser :** "Implémente cette fonctionnalité", "Développe selon architecture", "Code cette fonction"
- **Livrable :** Code propre, compilant sans erreurs

#### **🟢 QALvin** [v4.4]
- **Rôle :** Expert assurance qualité et tests
- **Responsabilités :**
  - Écrire tests unitaires complets (composants, services, modèles)
  - Assurer couverture test ≥80%
  - Tester cas limites et scénarios d'erreur
  - Valider que code fonctionne correctement
  - Lire `.claude/instructions/qa.instructions.md` au démarrage pour spécificités projet
- **Quand l'utiliser :** "Écris tests pour ce composant", "Génère tests unitaires", "Valide avec tests"
- **Livrable :** Tests passants avec rapports couverture

#### **🟣 DOCly** [v4.3]
- **Rôle :** Gardien documentation
- **Responsabilités :**
  - Mettre à jour README, `docs/` et guides
  - Maintenir `docs/ARCHITECTURE.md` à jour avec état réel projet
  - Créer ADRs dans `docs/adr/` sur délégation ARCos
  - Documenter changements architecturaux
  - Mettre à jour instructions Claude quand agents changent
  - Garder documentation en sync avec code
  - Lire `.claude/instructions/doc.instructions.md` au démarrage pour spécificités projet
- **Quand l'utiliser :** "Mets à jour documentation", "Garde docs en sync avec ce code", "Ajoute ça au README"
- **Livrable :** Documentation à jour, claire et complète

---

### 🔄 Workflow Typique

1. **Cadrage (👤 Développeur humain)** → Définir besoin et critères d'acceptation
2. **Orchestration (⚫ MAINa)** → Déclencher mode PLAN et consulter ARCos
3. **Analyse solutions (🟠 ARCos)** → Présenter ≥2 options + recommandation
4. **Validation Humaine** → Choisir solution
5. **Plan d'Action (⚫ MAINa)** → Créer Plan d'Action complet (skill plan-creation)
6. **Validation Humaine** → Approuver plan avant implémentation
7. **Implémentation (🔵 DEV - Devon)** → Coder tâches assignées
8. **Validation Humaine** → Approuver code avant tests
9. **Tests (🟢 QUAL - Qalvin)** → Écrire et valider tests
10. **Validation Humaine** → Approuver tests avant doc
11. **Documentation (🟣 DOC - Docly)** → Mettre à jour documentation
12. **Validation Humaine** → Approuver documentation et clôturer

> 💡 **Parallélisation** : Après validation code (étape 8), QALvin et DOCly peuvent être orchestrés en parallèle par MAINa quand tâches indépendantes.

---

## 📋 Plans d'Action et Suivi

Chaque initiative majeure (modernisation, nouvelle feature, refactoring) orchestrée via **Plan d'Action (AP)** :

- **Fichier plan :** `.claude/plans/<NO>_<nom>.plan.md`
- **Rapports de phase :** `.claude/plans/<NO>_reports/PHASE_N_...md`
- **Index des plans :** `.claude/plans/README.md`
- **Guide complet :** `.claude/PLANS.md`

Plans d'Action coordonnent travail multi-phases et garantissent traçabilité complète via rapports.

## 📐 Instructions Spécifiques Projet (`.claude/instructions/`)

Chaque agent lit au démarrage son fichier instructions spécifique projet :

| Fichier | Agent | Contenu |
|---|---|---|
| `orchestrator.instructions.md` | ⚫ MAINa | Orchestration, gates humains, délégations |
| `architect.instructions.md` | 🟠 ARCos | Conventions archi, couches, protocole SQL handoff |
| `dev.instructions.md` | 🔵 DEVon | Stack technique, versions, conventions code |
| `qa.instructions.md` | 🟢 QALvin | Framework test, commandes CI, cas à couvrir |
| `doc.instructions.md` | 🟣 DOCly | Fichiers /docs, conventions documentation |

Fichiers contiennent valeurs **spécifiques projet** (versions réelles, chemins, noms fichiers).  
Agents génériques (`.claude/agents/`) restent inchangés entre projets.

> Pour initialiser fichiers : utiliser prompt `init-copilot-instructions`.  
> Pour mettre à jour : utiliser prompt `update-copilot-instructions`.

## 🛠️ Skills Partagés (`.claude/skills/`)

Skills = procédures réutilisables incluses automatiquement dans contexte tous agents (`applyTo: **`) :

| Skill | Emplacement | Contenu |
|---|---|---|
| `plan-phase-execution` | `.claude/skills/plan-phase-execution/SKILL.md` | Procédure standard exécution phase AP (avant/pendant/après, formats rapport) |
| `plan-creation` | `.claude/skills/plan-creation/SKILL.md` | Procédure création et orchestration Plan d'Action (MAINa) |
| `fleet-guide` | `.claude/skills/fleet-guide/SKILL.md` | Guide parallélisation `/fleet` (quand utiliser, règle décision) |
| `adr-writing` | `.claude/skills/adr-writing/SKILL.md` | Rédaction ADR après accord ARCos + humain : ARCos prépare contenu, DOCly rédige fichier |
| `copilotignore` | `.claude/skills/copilotignore/SKILL.md` | **Règle absolue**: interdiction d'accès à tout fichier déclaré dans `.copilotignore` |
| `caveman-default` | `.claude/skills/caveman-default/SKILL.md` | Mode caveman (full) actif par défaut pour tous agents, sans invocation du skill tool |
| `compact-context` | `.claude/skills/compact-context/SKILL.md` | Instructions preCompact pour sessions plans/SDLC — évite accumulation skill blobs entre phases |
| `maina-help` | `.claude/skills/maina-help/SKILL.md` | Aide à l'orchestration MAINa (`/maina-help`) : workflow strict et gates humains |
| `safety-rules` | `.claude/skills/safety-rules/SKILL.md` | **Règle absolue**: interdiction des opérations destructives (suppression, SQL/git irréversibles, hors périmètre) |

Skills centralisent procédures communes pour éviter duplication entre agents.

---

## [📌 SECTION À COMPLÉTER : Présentation du Projet]

Remplacer section par brève description projet (1-2 paragraphes) :
- Domaine métier (ex: e-commerce, domotique, santé)
- Stack technologique principal (ex: React, Node.js, Python)
- Plateformes cibles (web, mobile, desktop)
- Langue interface (si applicable)

### Exemple pour projet React Native/Expo :
```
Application mobile React Native / Expo pour [DOMAINE MÉTIER].
Cible principalement [PLATEFORME] et le web.
L'interface utilisateur est en [LANGUE].
```

---

## [📌 SECTION À COMPLÉTER : Commandes]

Lister commandes principales projet (démarrage, tests, build, lint)

### Exemple pour projet Node.js/npm :
```bash
npm start               # Démarrer le serveur de développement
npm test                # Lancer les tests
npm run lint            # ESLint
npm run build           # Build de production
```

---

## [📌 SECTION À COMPLÉTER : Architecture]

Décrire structure projet et patterns architecturaux utilisés.

Éléments à couvrir :
- Structure dossiers principaux (src/, app/, lib/)
- Couches principales (composants, services, modèles, contrôleurs)
- Patterns gestion état (Context API, Redux, Zustand)
- Flux données principal
- Paradigmes clés (réactif, impératif)

### Exemple pour projet React :
```
src/
  components/         # Composants réutilisables
  pages/              # Pages/écrans
  services/           # Logique métier et API calls
  hooks/              # Custom hooks
  utils/              # Fonctions utilitaires
  styles/             # Styles partagés
  models/             # Modèles de données
```

---

## [📌 SECTION À COMPLÉTER : Conventions Clés]

Décrire conventions code et patterns projet. Couvrir :

### Nommage des fichiers
- Composants : `*.component.tsx` (ou autre convention)
- Services : `*.service.ts`
- Tests : `*.test.ts` (ou autre convention)
- Utilitaires : `*.utils.ts`

### TypeScript/JavaScript
- Mode strict activé ? (Oui/Non)
- Interfaces vs types ?
- Naming conventions (camelCase, PascalCase, CONSTANT_CASE)
- Classes vs fonctions ?

### Composants/Vues
- Hooks ou composants classe ?
- Gestion état (props, Context, Redux)
- Naming conventions pour props et états
- Styles (CSS modules, styled-components, Tailwind)

### Services et Logique Métier
- Pattern appels API (fetch, axios)
- Gestion erreurs HTTP
- Configuration et variables environnement

### Tests
- Framework (Jest, Vitest, Mocha)
- Pattern setup et mocks
- Couverture minimale attendue (ex: ≥80%)

### Autres conventions
- Committing (conventional commits)
- Branching strategy (Git flow, trunk-based)
- Code review expectations

---

## [📌 SECTION À COMPLÉTER : État du Projet et Bonnes Pratiques]

Ajouter sections pertinentes pour conventions spécifiques projet :
- État maintenance (stable, legacy, en evolution)
- Patterns erreur courants à éviter
- Dépendances clés et usages
- Performance/optimisations importantes
- Sécurité (authentification, validation)

---

## 📊 Relations entre Agents (Diagramme Mermaid)

> Diagramme complet : voir [README.md — Workflow Typique](../README.md#-workflow-typique)

---

**🎯 Pour customiser instructions :** Remplacer tous placeholders `[...]` par vos valeurs, puis utiliser prompt `.claude/prompts/update-copilot-instructions.prompt.md` pour auditer et enrichir fichier depuis code source.
