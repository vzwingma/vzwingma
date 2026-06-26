# CHANGELOG — Agents Claude

Versioning agents + skills Claude Code.

---

## **Agents**

### MAINa
- **v1.1** (2026-06-25) : Orchestrateur principal, workflow strict ARCos→DEVon→QALvin→DOCly, validations humaines obligatoires

### ARCos
- **v4.3** (2026-06-25) : Planification + architecture, lit `.github/instructions/architect.instructions.md` + `docs/ARCHITECTURE.md` au démarrage, ADR writing

### DEVon
- **v4.2** (2026-06-25) : Implémentation code production, patterns architecturaux, conventions projet

### QALvin
- **v4.2** (2026-06-25) : Tests unitaires, couverture ≥80%, cas limites + erreurs, mocks dépendances

### DOCly
- **v4.2** (2026-06-25) : Documentation, README, `docs/ARCHITECTURE.md`, ADRs, conventions

---

## **Skills**

- `plan-creation` : Création Plans d'Action (ARCos orchestration)
- `plan-phase-execution` : Exécution phases (avant/pendant/après, rapports)
- `fleet-guide` : Parallélisation `/fleet`
- `adr-writing` : Rédaction ADR (ARCos prépare, DOCly rédige)
- `caveman-default` : Mode caveman règles
- `compact-context` : Compression contexte mémoire
- `maina-help` : Aide MAINa + workflow
- `copilotignore` : Respect `.copilotignore`

---

**Dernière mise à jour** : 2026-06-25
