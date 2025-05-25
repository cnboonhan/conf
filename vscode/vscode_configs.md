# VSCode Configurations

## Extensions
```
echo """
github.copilot
ms-vscode-remote.vscode-remote-extensionpack
ms-python.python
ms-vscode-remote.remote-containers
ms-azuretools.vscode-containers
vscodevim.vim
ms-python.vscode-python-envs
""" | xargs -I{} code --install-extension {}
```

## keybindings.json
```
[
    {
        "key": "ctrl-k",
        "command": "editor.action.peekDefinition"
    },
    {
        "key": "alt+n",
        "command": "workbench.action.files.newUntitledFile"
    },
    {
        "key": "alt+w",
        "command": "workbench.action.closeActiveEditor"
    },
    {
        "key": "alt+h",
        "command": "workbench.action.navigateLeft"
    },
    {
        "key": "alt+l",
        "command": "workbench.action.navigateRight"
    },
    {
        "key": "alt+k",
        "command": "workbench.action.navigateUp"
    },
    {
        "key": "alt+j",
        "command": "workbench.action.navigateDown"
    },
    {
        "key": "alt+t",
        "command": "workbench.action.terminal.toggleTerminal"
    },
    {
        "key": "alt+p",
        "command": "workbench.action.quickOpen"
    },
    {
        "key": "alt+f",
        "command": "actions.find"
    },
    {
        "key": "alt+g",
        "command": "workbench.action.findInFiles"
    },
    {
        "key": "alt+r",
        "command": "workbench.action.terminal.runRecentCommand"
    },
    {
        "key": "alt+e",
        "command": "workbench.action.terminal.runSelectedText"
    },
    {
        "key": "alt+q",
        "command": "workbench.action.closeSidebar",
        "when": "explorerViewletVisible"
    },
    {
        "key": "alt+q",
        "command": "workbench.view.explorer",
        "when": "!explorerViewletVisible"
    },
    {
        "key": "alt+d",
        "command": "editor.action.deleteLines"
    },
    {
        "key": "alt+z",
        "command": "workbench.action.toggleMaximizeEditorGroup"
    }
]
```
