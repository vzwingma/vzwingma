---
name: "fleet-guide"
description: "Skill — Guide parallélisation `/fleet` pour tous agents. Appliqué automatiquement."
---

# Skill : Parallélisation avec /fleet

> `/fleet` = mode exécution parallèle CLI Copilot. Dispatche plusieurs sous-agents simultanément, réduit temps total.

---

## Quand utiliser /fleet

- **Tâches indépendantes du même agent**: Plusieurs composants/services/fichiers sans dépendance
- **Phases parallèles d'un Plan d'Action**: Deux phases sans gate humain entre elles et sans dépendance

---

## Quand NE PAS utiliser /fleet

- Tâche B **dépend du résultat** de tâche A
- Deux sous-tâches **modifient le même fichier** (risque conflit)
- Fichier setup commun doit être créé d'abord

---

## Comment indiquer l'usage de /fleet

Dans plan ou délégation, signaler explicitement tâches parallélisables:

```
💡 Ces tâches sont indépendantes → lancer en /fleet :
- Tâche A (Agent X)
- Tâche B (Agent Y)
```

---

## Règle de décision

| Situation | Mode recommandé |
|---|---|
| Tâche B dépend de tâche A | Séquentiel |
| Tâches A et B sans lien | `/fleet` |
| DEVon terminé → QALvin puis DOCly | Séquentiel (Gate #2 puis Gate #3) |
| Plusieurs éléments indépendants | `/fleet` |