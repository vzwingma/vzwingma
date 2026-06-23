---
name: "adr-writing"
description: "Skill — Procedure for writing an Architecture Decision Record (ADR) after agreement by ARCos + human. Automatically applied."
applyTo: "**"
---

# Skill: Writing an Architecture Decision Record (ADR)

> This skill describes the standard procedure for creating an ADR after an architectural decision has been validated by 🟠 ARCos + 👤 the human Developer.
> **Who does what:** ARCos prepares the content, 🟣 DOCly writes the file.
> Template: `docs/adr/ADR-TEMPLATE.md`

---

## When to create an ADR

An ADR **must** be created immediately after the chosen solution is validated by the 👤 human Developer (step 3 of the ARCos methodology), for decisions that:

- Introduce a **new technology or library** into the project
- Define a **new architectural pattern** (layer, service, global state, routing…)
- **Structurally modify an existing convention**
- Involve a **security** or compliance choice
- Result from an **explicit comparison of solutions** (analysis already produced by ARCos)

> 💡 A trivial or local decision (for example: renaming a variable, adding a field) → **no ADR**.

---

## Naming and location

| Element | Convention |
|---|---|
| **Folder** | `docs/adr/` |
| **File name** | `NNN-titre-court.md` (for example: `003-choix-librairie-ui.md`) |
| **Number** | Sequential 3 digits, last existing ADR + 1 |
| **Title** | Kebab-case, short, describes the decision (not the problem) |

Find the next number: list the files in `docs/adr/`, take the next one.

---

## Who does what

| Role | Responsibility |
|---|---|
| 🟠 **ARCos** | Prepares the ADR content: context, decision, alternatives (from comparative analysis), consequences, implementation |
| 🟣 **DOCly** | Drafts the ADR file in `docs/adr/` from the content provided by ARCos |

**ARCos never creates the ADR file itself.** It produces structured content, then delegates to DOCly.

---

## ARCos procedure — Prepare the ADR content

After the human decision, ARCos produces a delegation block to DOCly structured as follows:

```markdown
## 📋 Contenu ADR à rédiger

**Fichier cible :** `docs/adr/NNN-titre-court.md`
**Date :** [AAAA-MM-JJ]
**Statut :** Acceptée

### Contexte
[Reprendre le problème posé au départ : situation actuelle, contraintes,
pourquoi une décision est nécessaire ici.]

### Décision
Nous avons décidé de [DÉCISION RETENUE, en une phrase directe].

### Alternatives Considérées
*(Reprendre directement l'analyse comparative présentée à l'humain)*

**Option 1 : [Nom — retenue ✅]**
- Avantages : [...]
- Inconvénients : [...]

**Option 2 : [Nom]**
- Avantages : [...]
- Inconvénients : [...]
- Raison du rejet : [...]

### Conséquences
- Positives : [...]
- Négatives / Compromis : [...]
- Neutres : [ex: mise à jour de docs/ARCHITECTURE.md requise]

### Mise en œuvre
- Fichiers impactés : [...]
- Tâches de suivi : [DEVon — ..., QUALvin — ...]
- Date d'effet : [ex: à partir de la Phase N du plan]

### Références
- Plan d'Action associé : `.github/plans/NNN_nom.plan.md` (si applicable)
```

---

## DOCly procedure — Write the ADR file

When ARCos delegates ADR writing:

1. **Read the provided content** from ARCos (block above)
2. **Determine the number**: list `docs/adr/`, take the next one
3. **Create the file** `docs/adr/NNN-titre-court.md` from the template `docs/adr/ADR-TEMPLATE.md`
4. **Fill in each section** with the content provided by ARCos
5. **Do not interpret**: faithfully copy the decisions and alternatives provided

---

## Quality checklist for a good ADR

- [ ] The context explains **why** the decision is necessary
- [ ] The decision is stated in **one direct sentence** ("Nous avons décidé de…")
- [ ] At least **2 alternatives** documented with the reason for rejection
- [ ] Consequences include **negative points** (not only positive ones)
- [ ] Implementation lists concrete **files and follow-up tasks**
- [ ] Status is `Acceptée` (never empty or `Proposée` except exceptionally)
- [ ] Sequential number and kebab-case name

---

## Example ARCos → DOCly delegation prompt

```
🟣 DOCly, rédiges ADR suivant dans docs/adr/ :

[Coller ici bloc "Contenu ADR à rédiger" produit par ARCos]

Modèle utilisé : docs/adr/ADR-TEMPLATE.md
```

---

## References

- 📄 ADR template: `docs/adr/ADR-TEMPLATE.md`
- 📁 ADR folder: `docs/adr/`
- 📋 Action Plan guide: `.github/PLANS.md`