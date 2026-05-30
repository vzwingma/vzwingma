---
description: Spécificités projet [NOM_DU_PROJET] pour l'agent 💰 FINNops (finops)
applyTo: "**"
---

# Spécificités projet — [NOM_DU_PROJET] (FinOps)

> Fichier lu automatiquement par agent 💰 FINNops au démarrage.
> Contient spécificités projet `[NOM_DU_PROJET]` ([DESCRIPTION_COURTE_DU_PROJET]).

## Agents et modèles

| Agent | Modèle | Notes |
|-------|--------|-------|
| 🟠 ARCos | [MODELE_ARCOS, ex: Claude Sonnet 4.6] | Planification + orchestration |
| 🔵 DEVon | [MODELE_DEVON, ex: Claude Sonnet 4.6] | Implémentation |
| 🟢 QUALvin | [MODELE_QUALVIN, ex: GPT-5.3-Codex] | Tests |
| 🟣 DOCly | [MODELE_DOCLY, ex: GPT-5 mini] | Documentation |
| 💰 FINNops | GPT-5 mini | FinOps (ce fichier) |

## Seuils d'alerte

- **Tokens par session** : alerter si dépassement [SEUIL_TOKENS_SESSION, ex: 50 000 tokens]
- **Coût par plan** : alerter si dépassement [SEUIL_COUT_PLAN, ex: $1.00]
- **Rechargements skills** : alerter si un skill chargé > [SEUIL_RECHARGEMENTS, ex: 2] fois par session

## Rapports FinOps

- **Emplacement** : `.github/plans/<NO>_reports/FINNOPS_REPORT.md`
- **Format dates** : [FORMAT_DATE, ex: YYYY-MM-DD]
- **Archivage** : [POLITIQUE_ARCHIVAGE, ex: conserver 3 derniers rapports par plan]

## Priorités d'optimisation

Ordre de priorité pour ce projet :

1. [PRIORITE_1, ex: Réduire taille instructions agents > 500 lignes (caveman-compress)]
2. [PRIORITE_2, ex: Migrer tâches répétitives de Sonnet vers GPT-5 mini]
3. [PRIORITE_3, ex: Éliminer rechargements skills dupliqués]

## Fichiers protégés

> FINNops ne modifie pas ces fichiers sans validation 👤 **explicite** :

- `[FICHIER_PROTEGE_1, ex: .github/agents/Devon.agent.md]` — [RAISON_1]
- `src/**`, `app/**` — code applicatif hors périmètre FinOps

## Ce que tu ne fais PAS

- Modifie pas code applicatif (`src/`, `app/`, etc.)
- Supprime pas fichiers
- Applique pas changements sans accord explicite 👤 Développeur humain
- Prend pas décisions architecturales (rôle 🟠 ARCos)
- Modifie pas `.github/plans/README.md` sans valider statut plan global
