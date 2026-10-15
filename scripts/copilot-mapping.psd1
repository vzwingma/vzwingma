@{
    # Mapping Claude Code -> GitHub Copilot used by sync-claude-to-github.ps1 (ADR 003).
    # Generated Copilot frontmatter = name + description (from .claude/) + fields below.
    # Values are raw YAML, written as-is.

    # Claude model alias -> Copilot CLI model (AP 006, decision D1: agent models follow the source alias,
    # no per-agent override). Probe 2026-10-15 (Copilot CLI 1.0.99-0, -p, debug log): the CLI 'model' field
    # accepts the catalog identifier ('claude-opus-5.5') and the display name; an unknown value only
    # prints a warning, falls back to the default model and exits 0 (silent-substitution risk: see AP 006 T3.2).
    # Alias without entry -> no 'model' field (Copilot default model).
    ModelMap = @{
        opus   = 'claude-opus-5.5'
        sonnet = 'claude-sonnet-5.5'
    }

    # Claude tool -> Copilot CLI tool alias (AP 006, ARCos projection strategy #1).
    # 'tools' is derived from the Claude agent frontmatter (least privilege): no per-agent 'tools' override.
    # Claude names that are neither mapped here nor listed in DroppedTools raise a visible warning in the
    # generator output and are NOT emitted.
    ToolMap = @{
        Read       = 'read'
        Grep       = 'search'
        Glob       = 'search'
        WebFetch   = 'web'
        WebSearch  = 'web'
        Edit       = 'edit'
        Write      = 'edit'
        Bash       = 'execute'
        TodoWrite  = 'todo'
        TaskCreate = 'todo'
        TaskUpdate = 'todo'
        TaskList   = 'todo'
        TaskGet    = 'todo'
        Agent      = 'agent'
    }

    # Claude tools deliberately without Copilot CLI equivalent (name -> reason). Still reported by the
    # generator, never silently added. The presence of this key enables strict tool derivation.
    DroppedTools = @{
        AskUserQuestion = 'Claude-only; gates are asked explicitly in text (copilot-only blocks)'
        SendMessage     = 'Claude-only; no equivalent verified for Copilot CLI'
        Skill           = 'no verified tool alias; skills are loaded through the explicit loading notice of the profile'
    }

    # Per-agent Copilot-only fields (override anything derived from .claude/).
    # 'agents' is NOT verified for Copilot CLI (U3): informational only, never a guard. Kept for MAINa
    # only (the sole role with the Agent tool); no 'agents' field for the other roles (incl. ARCos).
    Agents = @{
        MAINa = @{
            agents = '["ARCos", "DEVon", "QALvin", "DOCly"]'
        }
    }
}
