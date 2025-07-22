## Installing
Use these commands to install VSCODE extensions
```
code --install-extension bradlc.vscode-tailwindcss
code --install-extension christian-kohler.npm-intellisense
code --install-extension dbaeumer.vscode-eslint
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension esbenp.prettier-vscode
code --install-extension firefox-devtools.vscode-firefox-debug
code --install-extension ms-python.debugpy
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-python.vscode-python-envs
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension rangav.vscode-thunder-client
code --install-extension simonsiefke.svg-preview
code --install-extension syler.sass-indented
code --install-extension unifiedjs.vscode-mdx
code --install-extension vitest.explorer
code --install-extension vscode-icons-team.vscode-icons
code --install-extension wayou.vscode-todo-highlight
code --install-extension yoavbls.pretty-ts-errors
```

## Adding new extensions to this list
Run the below command and copy & paste the list (found on [Stackoverflow](https://stackoverflow.com/a/51403163/10223638)):
```sh
code --list-extensions | xargs -L 1 echo code --install-extension
```
