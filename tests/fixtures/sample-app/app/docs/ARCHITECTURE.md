# Architecture — sample-app

- **Stack** : Node.js (modules ES), aucune dépendance externe.
- **Structure** : `src/` (fonctions pures) ; tests co-localisés `src/*.test.js` (`node:test`).
- **Conventions** : fonctions pures exportées nommément, erreurs de type via `TypeError`.
