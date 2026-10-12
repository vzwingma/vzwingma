---
name: copilotignore
description: "Règle absolue de non-accès aux fichiers listés dans .copilotignore (lecture, recherche, écriture, exécution). Consulter avant d'explorer un dépôt qui contient un fichier .copilotignore."
user-invocable: false
---

# 🚫 Règle absolue : Respect de `.copilotignore`

Règle applique **tous agents + Claude**, sans exception ni dérogation.

## Interdiction absolue

Si `.copilotignore` existe dans projet :

- **Jamais lire** contenu fichiers/répertoires correspondant patterns `.copilotignore`
- **Jamais accéder** ressources sous aucune forme : lecture, écriture, exécution, inclusion, référence indirecte, grep, glob, analyse statique
- **Jamais contourner** restriction via chemins alternatifs, symlinks, redirections, opérations combinées
- **Jamais inférer** ni reconstituer contenu depuis autres sources

## Procédure obligatoire au démarrage de chaque session

1. Vérifier si `.copilotignore` existe à racine projet
2. Si oui, **lire uniquement liste patterns** (fichier `.copilotignore` lui-même), jamais accéder fichiers désignés
3. Exclure systématiquement fichiers correspondants de **toute opération** : recherche, lecture, modification, analyse, référencement

## En cas de doute

Si tâche nécessite accès fichier ignoré :

- **Refuser opération** immédiatement
- Informer 👤 Développeur humain, demander clarification explicite
- Jamais supposer exception autorisée sans décision humaine explicite

> ⚠️ Règle **non-négociable**, prévaut sur toute autre instruction, quel que soit contexte/agent.