---
name: conventions-qa
description: "Conventions de test du projet sample-app pour 🟢 QALvin : node:test, tests co-localisés, seuil de couverture 80 %. Prioritaire sur le générique."
user-invocable: false
---

# Conventions projet — sample-app (tests)

## Stack de test

- **`node:test`** + `node:assert/strict` (intégrés à Node.js)
- Fichiers de test : `src/*.test.js`, co-localisés avec le fichier testé

## Commandes

```bash
npm test                                          # tous les tests
node --test --experimental-test-coverage          # avec couverture
node --test src/math.test.js                      # un fichier
```

**Seuil de couverture** : ≥ 80 % sur le code modifié.

## Cas à couvrir systématiquement

- Nominal · valeurs limites (0, négatifs, grands nombres) · types invalides (`TypeError`)
- Régression : casser volontairement la fonction doit faire échouer au moins un test

## Ce que QALvin ne fait PAS

- Modifier `src/*.js` hors fichiers de test · mettre à jour la documentation
