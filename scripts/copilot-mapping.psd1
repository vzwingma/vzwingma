@{
    # Mapping Claude Code -> GitHub Copilot used by sync-claude-to-github.ps1 (ADR 003).
    # Generated Copilot frontmatter = name + description (from .claude/) + fields below.
    # Values are raw YAML, written as-is.

    # Claude model alias -> Copilot model, used when an agent has no 'model' override.
    # Alias without entry -> no 'model' field (Copilot default model).
    ModelMap = @{
        sonnet = 'Claude Sonnet 4.6 (copilot)'
    }

    # Claude tool -> Copilot tool, used when an agent has no 'tools' override.
    # Copilot accepts Claude tool names as aliases (Read, Edit, Write, Bash, Grep, Glob,
    # WebFetch, WebSearch, Task, TodoWrite); only tools missing from its alias table are listed.
    ToolMap = @{
        Agent      = 'agent'
        TaskCreate = 'todo'
        TaskUpdate = 'todo'
        TaskList   = 'todo'
        TaskGet    = 'todo'
    }

    # Per-agent Copilot-only fields (override anything derived from .claude/).
    Agents = @{
        MAINa = @{
            model  = 'Claude Sonnet 4.6 (copilot)'
            agents = '["ARCos", "DEVon", "QALvin", "DOCly"]'
            tools  = '[read, agent, edit, search, web, todo]'
        }
        ARCos = @{
            model  = 'Claude Sonnet 4.6 (copilot)'
            agents = '["DEVon", "QALvin", "DOCly", "MAINa"]'
            tools  = '[execute/getTerminalOutput, execute/sendToTerminal, execute/runTask, execute/createAndRunTask, execute/runInTerminal, read, agent, edit, search, web, todo]'
        }
        DEVon = @{
            model  = 'Claude Sonnet 4.6 (copilot)'
            agents = '["QALvin", "DOCly", "MAINa"]'
            tools  = '[vscode, execute/getTerminalOutput, execute/sendToTerminal, execute/runTask, execute/createAndRunTask, execute/runInTerminal, execute/runTests, execute/testFailure, read, agent, edit, search, web, vscjava.vscode-java-debug/debugJavaApplication, vscjava.vscode-java-debug/setJavaBreakpoint, vscjava.vscode-java-debug/debugStepOperation, vscjava.vscode-java-debug/getDebugVariables, vscjava.vscode-java-debug/getDebugStackTrace, vscjava.vscode-java-debug/evaluateDebugExpression, vscjava.vscode-java-debug/getDebugThreads, vscjava.vscode-java-debug/removeJavaBreakpoints, vscjava.vscode-java-debug/stopDebugSession, vscjava.vscode-java-debug/getDebugSessionInfo]'
        }
        QALvin = @{
            model  = 'GPT-5.3-Codex (copilot)'
            agents = '["DOCly", "MAINa"]'
            tools  = '[vscode, execute, read, agent, edit, search, web, browser, sonarsource.sonarlint-vscode/sonarqube_getPotentialSecurityIssues, sonarsource.sonarlint-vscode/sonarqube_excludeFiles, sonarsource.sonarlint-vscode/sonarqube_setUpConnectedMode, sonarsource.sonarlint-vscode/sonarqube_analyzeFile, todo]'
        }
        DOCly = @{
            model  = 'GPT-5 mini (copilot)'
            agents = '["MAINa"]'
            tools  = '[vscode, read, agent, edit, search, web, browser, todo]'
        }
    }
}
