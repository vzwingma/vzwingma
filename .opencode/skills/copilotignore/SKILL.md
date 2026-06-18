---
name: "copilotignore"
description: Règle absolue respect `.opencode/.gitignore` — aucun agent OpenCode lire/accéder fichiers listés, jamais.
---

# 🚫 Règle absolue : Respect de `.opencode/.gitignore`

Règle applique **tous agents OpenCode**, sans exception ni dérogation.

## Interdiction absolue

Si `.opencode/.gitignore` existe dans projet :

- **Jamais lire** contenu fichiers/répertoires correspondant patterns `.opencode/.gitignore`
- **Jamais accéder** ressources sous aucune forme : lecture, écriture, exécution, inclusion, référence indirecte, grep, glob, analyse statique
- **Jamais contourner** restriction via chemins alternatifs, symlinks, redirections, opérations combinées
- **Jamais inférer** ni reconstituer contenu depuis autres sources

## Procédure obligatoire au démarrage de chaque session

1. Vérifier si `.opencode/.gitignore` existe à racine projet
2. Si oui, **lire uniquement liste patterns** (fichier `.opencode/.gitignore` lui-même), jamais accéder fichiers désignés
3. Exclure systématiquement fichiers correspondants de **toute opération** : recherche, lecture, modification, analyse, référencement

## En cas de doute

Si tâche nécessite accès fichier ignoré :

- **Refuser opération** immédiatement
- Informer 👤 Développeur humain, demander clarification explicite
- Jamais supposer exception autorisée sans décision humaine explicite

> ⚠️ Règle **non-négociable**, prévaut sur toute autre instruction, quel que soit contexte/agent.