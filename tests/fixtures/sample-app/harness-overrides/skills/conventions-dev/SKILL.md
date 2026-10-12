---
name: conventions-dev
description: "Conventions de développement du projet sample-app pour 🔵 DEVon : Node.js ES modules sans dépendance, fonctions pures, commandes de vérification. Prioritaire sur le générique."
user-invocable: false
---

# Conventions projet — sample-app (développement)

## Stack technique

- **Node.js ≥ 20** — modules ES (`"type": "module"`), aucune dépendance externe

## Commandes de vérification (preuves avant handoff)

```bash
npm run lint   # node --check src/math.js
npm test       # node --test (tests existants, non-régression)
```

## Structure et nommage

- Code source : `src/` ; une fonction pure exportée nommément par responsabilité
- Fichiers : `kebab-case.js` ; identifiants : `camelCase`

## Conventions de code

- Paramètres invalides → `throw new TypeError('<fonction> attend …')`
- JSDoc sur chaque fonction exportée

## Ce que DEVon ne fait PAS

- Modifier les fichiers `src/*.test.js` (rôle 🟢 QALvin)
- Mettre à jour `README.md` ou `docs/` (rôle 🟣 DOCly)
