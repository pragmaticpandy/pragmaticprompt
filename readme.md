## About
This is my custom, minimal zsh prompt. It prints the following:
* The working directory on the line above the prompt.
* Unicode right arrow for the prompt itself.
* If in a git repository, the current branch name on the right.
* Just before a command is executed, the current time on the right.

## Installation
This plugin is just one file and can be sourced directly however you want, or you can use a plugin manager. Here's an example with [antigen](https://github.com/zsh-users/antigen):
```
antigen bundle https://github.com/pragmaticpandy/pragmaticprompt.git
```

## Usage
These variables, shown here with their defaults, can optionally be set to [zsh foreground colors](https://github.com/zsh-users/zsh/blob/master/Functions/Misc/colors#L37):
* ```PRAGMATIC_PROMPT_PROMPT_FOREGROUND=cyan```
* ```PRAGMATIC_PROMPT_COMMAND_FOREGROUND=white```
