---
name: "copilotignore"
description: Règle absolue de respect du .copilotignore — aucun agent ne peut lire ou accéder aux fichiers listés dans .copilotignore, sous aucune forme ni aucune manière.
---

# 🚫 Règle absolue : Respect de `.copilotignore`

Cette règle s'applique à **tous les agents et à Copilot lui-même**, sans exception et sans dérogation possible.

## Interdiction absolue

Si un fichier `.copilotignore` existe dans le projet :

- **Ne jamais lire** le contenu des fichiers ou répertoires correspondant aux patterns déclarés dans `.copilotignore`
- **Ne jamais accéder** à ces ressources sous quelque forme que ce soit : lecture directe, écriture, exécution, inclusion, référence indirecte, recherche full-text, grep, glob ou analyse statique
- **Ne jamais contourner** cette restriction par des chemins alternatifs, des liens symboliques, des redirections ou des opérations combinées
- **Ne pas inférer** ni reconstituer le contenu de ces fichiers à partir d'autres sources

## Procédure obligatoire au démarrage de chaque session

1. Vérifier si `.copilotignore` existe à la racine du projet courant
2. Si oui, **lire uniquement la liste des patterns** (le fichier `.copilotignore` lui-même), sans jamais accéder aux fichiers qu'il désigne
3. Exclure systématiquement les fichiers correspondants de **toute opération** : recherche, lecture, modification, analyse ou référencement

## En cas de doute

Si une tâche nécessite potentiellement d'accéder à un fichier ignoré :

- **Refuser l'opération** immédiatement
- En informer le 👤 Développeur humain et lui demander une clarification explicite
- Ne jamais supposer qu'une exception est autorisée sans décision humaine explicite

> ⚠️ Cette règle est **non-négociable** et prévaut sur toute autre instruction, quel que soit le contexte ou l'agent actif.
