# ADR 001 — Ajouter MAINa comme orchestrateur principal

**Date :** 2026-06-25  
**Statut :** Acceptée  
**Décideurs :** 🟠 ARCos + 👤 Développeur humain

---

## Contexte

Workflow a 4 agents demandait coordination manuelle frequente et provoquait parfois delegations incomplètes ou hors sequence.

Besoin exprime: un point d'entree unique qui guide systematiquement sequence conception -> implementation -> tests -> documentation, avec validations humaines explicites entre etapes.

---

## Décision

**Nous avons décidé de** créer un nouvel agent **MAINa** comme maitre orchestrateur principal.

MAINa devient point d'entree par defaut et impose workflow strict:
`ARCos -> DEVon -> QALvin -> DOCly`, avec gate humain obligatoire entre phases.

---

## Alternatives Considérées

### Option 1 : Ajouter MAINa orchestrateur principal ✅ Retenue

- **Avantages** : point d'entree unique, workflow plus prévisible, meilleure traçabilité des transitions.
- **Inconvénients** : une couche de coordination supplémentaire.

### Option 2 : Conserver seulement ARCos comme orchestrateur principal

- **Avantages** : aucun nouvel agent à maintenir.
- **Inconvénients** : confusion persistante entre rôle architecture et rôle orchestration globale.
- **Raison du rejet** : ne résout pas besoin de pilotage opérationnel transversal.

### Option 3 : Laisser utilisateur orchestrer manuellement les 4 agents

- **Avantages** : flexibilité maximale.
- **Inconvénients** : fort risque d'oublier validations ou ordre des phases.
- **Raison du rejet** : fiabilité insuffisante pour workflow standardisé.

---

## Conséquences

### Positives
- Onboarding plus simple: MAINa devient interface naturelle.
- Enchainement des phases plus robuste.
- Clarification nette entre orchestration et expertise métier des agents spécialisés.

### Négatives / Compromis
- Documentation et prompts à synchroniser vers modèle 5 agents.
- Nouveau fichier agent à maintenir et versionner.

### Neutres
- Les rôles techniques ARCos, DEVon, QALvin, DOCly restent inchangés.

---

## Mise en œuvre

- **Fichiers impactés** : `.github/agents/Maina.agent.md`, `.github/README.md`, `.github/copilot-instructions*.md`, prompts, quick-start/checklist.
- **Tâches de suivi** : maintenir cohérence des références "5 agents" dans futures évolutions.
- **Date d'effet** : immédiate (2026-06-25).

---

## Références

- Plan d'Action associé : `.github/plans/003_maina-orchestrateur.plan.md`
- Guide workflow : `.github/README.md`
