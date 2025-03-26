# Load colors so we can access $fg and more.
autoload -U colors && colors

# Disable CTRL-s from freezing your terminal's output.
stty stop undef

# Enable comments when working in an interactive shell.
setopt interactive_comments

# Prompt. Using single quotes around the PROMPT is very important, otherwise
# the git branch will always be empty. Using single quotes delays the
# evaluation of the prompt. Also PROMPT is an alias to PS1.
git_prompt() {
    local branch="$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3-)"
    local branch_truncated="${branch:0:30}"
    if (( ${#branch} > ${#branch_truncated} )); then
        branch="${branch_truncated}..."
    fi

    [ -n "${branch}" ] && echo " (${branch})"
}
setopt PROMPT_SUBST
PROMPT='%B%{$fg[green]%}%n@%{$fg[green]%}%M %{$fg[blue]%}%~%{$fg[yellow]%}$(git_prompt)%{$reset_color%} %(?.$.%{$fg[red]%}$)%b '

# History settings.
export HISTFILE="${XDG_CACHE_HOME}/zsh/.history"
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000        # History lines stored in mememory.
export SAVEHIST=50000        # History lines stored on disk.
setopt INC_APPEND_HISTORY    # Immediately append commands to history file.
setopt HIST_IGNORE_ALL_DUPS  # Never add duplicate entries.
setopt HIST_IGNORE_SPACE     # Ignore commands that start with a space.
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blank lines.

# Enable mise to manage various programming runtime versions.
SHELL_NAME=${ZSH_VERSION:+zsh}${BASH_VERSION:+bash}

if type "${HOME}/.local/bin/mise" &> /dev/null; then
  if [[ -t 0 ]]; then
    eval "$("${HOME}/.local/bin/mise" activate "$SHELL_NAME")"
  else
    eval "$("${HOME}/.local/bin/mise" activate --shims)"
  fi
fi
eval "$(${HOME}/.local/bin/mise hook-env)"

# Use modern completion system. Other than enabling globdots for showing
# hidden files, these ares values in the default generated zsh config.

fpath+=${HOME}/.local/share/zsh/completions

autoload -Uz compinit && compinit
_comp_options+=(globdots)

autoload -U +X bashcompinit && bashcompinit

zstyle ':completion:*' menu select=2
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''

# dircolors is a GNU utility that's not on macOS by default. With this not
# being used on macOS it means zsh's complete menu won't have colors.
command -v dircolors > /dev/null 2>&1 && eval "$(dircolors -b)"

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# Use emacs keybindings even if your $EDITOR is set to Vim.
bindkey -e

# Ensure home / end keys continue to work.
bindkey '\e[1~' beginning-of-line
bindkey '\e[H' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[F' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[3~' delete-char

# WSL 2 specific settings.
if grep -q "microsoft" /proc/version > /dev/null 2>&1; then
    # Requires: https://sourceforge.net/projects/vcxsrv/ (or alternative)
    # Temporarily disable this because I don't use vcxsrv (or alternative) yet
    # export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"

    # Configure OpenSSH in order to 1password ssh will be usable
    export GIT_SSH='/c/Program\ Files/OpenSSH/ssh.exe'
    export GIT_SSH_COMMAND='/c/Program\ Files/OpenSSH/ssh.exe'
fi

# Allows your gpg passphrase prompt to spawn (useful for signing commits).
export GPG_TTY="$(tty)"

# Configure FZF.
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!.git'"
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none"
export FZF_CTRL_T_OPTS="--preview='less {}' --height=100% --bind shift-up:preview-page-up,shift-down:preview-page-down"

# zsh-autosuggestions settings.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Load / source zsh plugins.
. "${XDG_DATA_HOME}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
. "${XDG_DATA_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Load aliases if they exist.
[ -f "${XDG_CONFIG_HOME}/zsh/.aliases" ] && . "${XDG_CONFIG_HOME}/zsh/.aliases"

# Load local settings if they exist.
[ -f "${XDG_CONFIG_HOME}/zsh/.zshrc.local" ] && . "${XDG_CONFIG_HOME}/zsh/.zshrc.local"
[ -f "${XDG_CONFIG_HOME}/zsh/.aliases.local" ] && . "${XDG_CONFIG_HOME}/zsh/.aliases.local" || true

# Load sources from other repository if they exist.
[ -f "${XDG_CONFIG_HOME}/zsh/.aliases.sassd" ] && . "${XDG_CONFIG_HOME}/zsh/.aliases.sassd"

# Set autosuggestions
eval "$(${HOME}/.local/bin/mise completion zsh)"

complete -C '$(which aws_completer)' aws
complete -C '$(which terraform)' terraform
complete -C '$(which terragrunt)' -C '$(which terraform)' terragrunt

source <(fzf --zsh)
source <(kubectl completion zsh)
source <(k9s completion zsh)
source <(eksctl completion zsh)
source <(terraform-docs completion zsh)
source <(helm completion zsh)
source <(argocd completion zsh)
source <(mongocli completion zsh)

# eval additional
eval "$(zoxide init --cmd cd zsh)"
eval "$(uv generate-shell-completion zsh)"
