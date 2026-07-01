---
description: Spécificités projet [NOM_DU_PROJET] pour l'agent 🔵 DEVon (dev)
applyTo: "**"
---

# Spécificités projet — [NOM_DU_PROJET] (Dev)

> Fichier lu auto par agent 🔵 DEVon au démarrage. Contient specs projet `[NOM_DU_PROJET]` ([DESCRIPTION_COURTE_DU_PROJET], ex: frontend React/TypeScript).
>
> **Template** : copier en `dev.instructions.md` (retirer `.template`) et remplir les placeholders
> `[...]` pour activer cette couche. Non instancié → agent applique le générique.

## Workflow

1. Récupère tes tâches (`🔵 DEVon` / `Agent: DEVon`) dans le **Plan d'Action** actif (`.github/plans/`).
2. Vérifie que les dépendances sont livrées avant de commencer.
3. Implémente selon conventions ci-dessous ; ne pas élargir le scope.
4. Signale la complétion (rapport `PHASE_N_*.md`) puis relaie vers `🟢 QALvin` / `🟣 DOCly`.

Procédure détaillée : skill `plan-phase-execution`.

## Stack technique

- **[FRAMEWORK_PRINCIPAL] [VERSION]** – [PARADIGME, ex: TypeScript strict, composants fonctionnels uniquement]
- **[LIBRAIRIE_UI] [VERSION]** (`[PACKAGE_UI]`) – seule lib UI autorisée
- **[LIBRAIRIE_ROUTING] [VERSION]** – `[STRATEGIE_ROUTING]`, routes dans `[FICHIER_ROUTES]`
- **[LIBRAIRIE_AUTH] [VERSION]** – [CONSIGNE_AUTH, ex: pas manipuler tokens OAuth direct]
- **[LIBRAIRIE_CHARTS] [VERSION]** – pour visualisations ([TYPES_GRAPHIQUES])

## Conventions de code

### Composants

> 💡 Exemples ci-dessous en React/TypeScript — adapter à `[FRAMEWORK_PRINCIPAL]`.

```typescript
// Toujours : composant fonctionnel typé
export const MonComposant: React.FC<MonComposantProps> = ({ prop1, prop2 }): JSX.Element => {
  // ...
};
```

- Props interfaces dans `[FICHIER_PROPS]`.
- Sous-composants page dans `[DOSSIER_SUBCOMPONENTS]/`, boutons action dans `[DOSSIER_ACTIONS]/`.
- Utiliser le mécanisme de mémoïsation du framework pour calculs dérivés coûteux et handlers passés en props (ex: `useMemo`/`useCallback`).
- Responsive via `[METHODE_RESPONSIVE]`.

### Appels HTTP

```typescript
// Toujours passer par [SERVICE_HTTP]
import { call } from '../Services/[SERVICE_HTTP]';
// URL avec {{}} comme marqueur positionnel
call('GET', [CONFIG_URL_VARIABLE], '/[CHEMIN_API]/{{}}/[RESSOURCE]', [paramId]);
```

### Modèles et état

- Classes données dans `[DOSSIER_MODELS]`.
- État global via le provider du projet (ex: `useContext([NOM_CONTEXT])`).
- État local UI via le mécanisme du framework (ex: `useState`).

### Enums et constantes

- Constantes techniques dans `[FICHIER_CONSTANTES_TECHNIQUES]`.
- Enums métier dans `[FICHIER_ENUMS_METIER]`.
- Pas hardcoder URLs ou clés API dans composants.

## Ce que tu ne fais PAS

- Pas modifier fichiers `*.test.[tsx|ts]` (rôle de 🟢 QALvin).
- Pas MAJ `README.md`, `docs/`, ni `copilot-instructions.md` (rôle de 🟣 DOCly).
- Pas décisions archi (nouveau Context, nouvelle lib) sans tâche 🟠 ARCos dans le Plan d'Action.


## Règle d'index des plans (obligatoire)

- `.github/plans/README.md` limité aux **plans + statut global** (sans détail phases).
- Si travail change statut global plan, MAJ `.github/plans/README.md` dans même changement.