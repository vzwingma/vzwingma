---
name: init-copilot-instructions
description: >
  Initialise les instructions Copilot pour un nouveau projet. Utiliser pour :
  "initialise les instructions Copilot", "génère les instructions pour ce projet",
  "crée un copilot-instructions.md", "configure Copilot pour ce projet".
  Prend en paramètre le type de projet et extrait les informations du code source.
mode: agent
---

# Initialisation des Instructions Copilot

Ta mission est de **générer et initialiser** le fichier `.github/copilot-instructions.md` pour un nouveau projet, en te basant sur :

1. Le **template générique** (`.github/copilot-instructions.template.md`) présent dans ce dépôt transverse
2. L'**analyse du code source** du projet cible
3. Les **conventions réelles** appliquées dans le code

## 📋 Étapes

### 1. Lire le template générique

Lire intégralement `.github/copilot-instructions.template.md` pour comprendre la structure de base.

### 2. Analyser le projet cible

Parcourir le dépôt et identifier :

- **Structure du projet** : Explorer les dossiers principaux (src/, app/, lib/, etc.)
- **Stack technologique** : Identifier le langage (TypeScript, Python, Go, etc.), le framework principal (React, Vue, Django, Spring, etc.)
- **Type de projet** : Catégoriser (frontend, backend, fullstack, mobile, CLI, lib, etc.)
- **Plateforme** : Web, mobile (iOS/Android), desktop, CLI, API, etc.
- **Gestion d'état** : Context API, Redux, Zustand, MobX, etc. (le cas échéant)
- **Patterns architecturaux** : Couches (components, services, models), DDD, MVVM, etc.
- **Conventions existantes** : Naming files, imports, styling, testing patterns, etc.

### 3. Remplir les sections du template

Pour chaque placeholder `[...]` du template, fournir une valeur adaptée :

| Placeholder | Source d'information | Exemple |
|---|---|---|
| `[NOM_DU_PROJET]` | Nom du repo ou package.json name | "Domoticz Mobile", "API-Gateway", "Design System" |
| **Présentation du Projet** | README, description, package.json, main.swift, etc. | Stack tech, domaine métier, plateformes |
| **Commandes** | package.json scripts, Makefile, build scripts, etc. | `npm start`, `npm test`, `go build`, etc. |
| **Architecture** | Structure des dossiers + patterns observés | Diagram ASCII ou description hiérarchique |
| **Conventions Clés** | Fichiers existants du code | Nommage, TypeScript config, ESLint, Prettier, etc. |
| **État du Projet** | Code analysis + notes | État de maintenance, patterns d'erreur, dépendances clés |

### 4. Générer le fichier

Créer `.github/copilot-instructions.md` en :
1. Copiant le template
2. Remplaçant tous les placeholders par les valeurs du projet
3. Supprimant les sections `[📌 À COMPLÉTER : ...]` si elles ont été remplies
4. Conservant les sections génériques (agents, workflow, plans d'action, diagrammes)

### 5. Auditer et enrichir (optionnel)

Si le projet dispose d'autres fichiers de référence (CONTRIBUTING.md, ARCHITECTURE.md, BEST_PRACTICES.md, etc.), les lire et enrichir les sections correspondantes du fichier généré.

## ✅ Checklist de Livraison

- [ ] Fichier `.github/copilot-instructions.md` créé
- [ ] Tous les placeholders `[...]` remplacés par des valeurs réelles
- [ ] Sections `[📌 À COMPLÉTER : ...]` supprimées ou complétées
- [ ] Structure des sections conservée (ordre, hiérarchie)
- [ ] Sections génériques intactes (Agents, Workflow, Plans d'Action, Diagrammes)
- [ ] Exemples de code issus du codebase réel (si pertinent)
- [ ] Pas de références à des fichiers inexistants
- [ ] Langue française conservée pour tout le texte narratif
- [ ] Fichier lisible et bien formaté (Markdown)

## 💡 Conseils

1. **Soyez précis** : Observer et décrire ce qui existe réellement, pas des hypothèses
2. **Soyez concis** : Les instructions Copilot sont lues régulièrement ; rester synthétique
3. **Soyez pratiques** : Inclure les commandes réelles, les patterns réels observés
4. **Conservez la structure** : Ne pas réorganiser les sections du template, sauf si très pertinent
5. **Exemples du code** : Quand utile, inclure des patterns extraits du code source réel

## 🎯 Résultat

À la fin, le fichier `.github/copilot-instructions.md` doit être une **source de vérité** pour Copilot :
- Décrit fidèlement l'état du projet
- Fournit des conventions claires et appliquées
- Guide les agents dans le contexte du projet spécifique
- Reste à jour et maintenu par le projet
