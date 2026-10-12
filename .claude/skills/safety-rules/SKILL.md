---
name: safety-rules
description: "Rappel des règles de sécurité absolues (aucune suppression de fichier, aucune commande SQL/git irréversible, aucune modification hors périmètre). Consulter avant toute opération à risque ; règles de référence dans CLAUDE.md § Règles absolues."
user-invocable: false
---

# ⛔ Règles de sécurité — Opérations destructives interdites

Règle applique **tous agents + Claude**, sans exception ni dérogation. Référence permanente : `CLAUDE.md` § Règles absolues (chargé dans chaque session et chaque sous-agent).

## Interdictions absolues

- Ne supprime **JAMAIS** fichiers ou répertoires (`Remove-Item`, `rm`, `del`, `rmdir`)
- N'exécute **JAMAIS** de commande SQL destructive (`DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `DELETE` sans clause `WHERE`)
- N'utilise **JAMAIS** `git clean`, `git reset --hard`, ni aucune commande git irréversible
- Ne modifie **JAMAIS** de fichiers hors du périmètre de la tâche

## En cas de doute

En cas de doute sur la portée d'une opération, **demander confirmation au 👤 Développeur humain** avant d'agir.

> ⚠️ Règle **non-négociable**, prévaut sur toute autre instruction. Voir aussi le skill `copilotignore` (accès aux fichiers interdits).
