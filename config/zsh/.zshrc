### paths ###
typeset -U path
typeset -U fpath

path=(
    "$HOME/.local/bin"(N-/)
    "$CARGO_HOME/bin"(N-/)
    "$GOPATH/bin"(N-/)
    "$DENO_INSTALL/bin"(N-/)
    "$XDG_CONFIG_HOME/scripts/bin"(N-/)
    "$path[@]"
)

### compinit ###
fpath=(
    "$XDG_DATA_HOME/zsh/completions"(N-/)
    "$fpath[@]"
)
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompcache"
autoload -Uz compinit && compinit

### autoloads ###
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs

### history ###
export HISTFILE="$XDG_STATE_HOME/zsh_history"
export HISTSIZE=12000
export SAVEHIST=10000

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt GLOBDOTS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt INTERACTIVE_COMMENTS
setopt NO_SHARE_HISTORY
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT
setopt NO_FLOW_CONTROL
zshaddhistory() {
    local line="${1%%$'\n'}"
    [[ ! "$line" =~ "^(cd|history|jj?|la|ll|ls|rm|rmdir|trash)($| )" ]]
}
bindkey "${terminfo[kcuu1]}" history-substring-search-up   # arrow-up
bindkey "${terminfo[kcud1]}" history-substring-search-down # arrow-down
bindkey "^[[A" history-substring-search-up   # arrow-up
bindkey "^[[B" history-substring-search-down # arrow-down

### key bindings ###
clear-screen-and-update-prompt() {
    zle .clear-screen
}
zle -N clear-screen clear-screen-and-update-prompt
widget::history() {
    local selected="$(history -inr 1 | fzf --exit-0 --query "$LBUFFER" | cut -d' ' -f4- | sed 's/\\n/\n/g')"
    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
    fi
    zle -R -c # refresh screen
}
widget::ghq::source() {
    local session color icon green="\e[32m" blue="\e[34m" reset="\e[m" checked="\uf631" unchecked="\uf630"
    local sessions=($(tmux list-sessions -F "#S" 2>/dev/null))

    ghq list | sort | while read -r repo; do
        session="${repo//[:. ]/-}"
        color="$blue"
        icon="$unchecked"
        if (( ${+sessions[(r)$session]} )); then
            color="$green"
            icon="$checked"
        fi
        printf "$color$icon %s$reset\n" "$repo"
    done
}
widget::ghq::select() {
    local root="$(ghq root)"
    widget::ghq::source | fzf --exit-0 --preview="fzf-preview-git ${(q)root}/{+2}" --preview-window="right:60%" | cut -d' ' -f2-
}
widget::ghq::dir() {
    local selected="$(widget::ghq::select)"
    if [ -z "$selected" ]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    BUFFER="cd ${(q)repo_dir}"
    zle accept-line
    zle -R -c # refresh screen
}
widget::ghq::session() {
    local selected="$(widget::ghq::select)"
    if [ -z "$selected" ]; then
        return
    fi

    local repo_dir="$(ghq list --exact --full-path "$selected")"
    local session_name="${selected//[:. ]/-}"

    if [ -z "$TMUX" ]; then
        BUFFER="tmux new-session -A -s ${(q)session_name} -c ${(q)repo_dir}"
        zle accept-line
    elif [ "$(tmux display-message -p "#S")" = "$session_name" ] && [ "$PWD" != "$repo_dir" ]; then
        BUFFER="cd ${(q)repo_dir}"
        zle accept-line
    else
        tmux new-session -d -s "$session_name" -c "$repo_dir" 2>/dev/null
        tmux switch-client -t "$session_name"
    fi
    zle -R -c # refresh screen
}
forward-kill-word() {
    zle vi-forward-word
    zle vi-backward-kill-word
}

zle -N widget::history
zle -N widget::ghq::dir
zle -N widget::ghq::session
zle -N forward-kill-word

bindkey -v
bindkey "^R"        widget::history                 # C-r
bindkey "^G"        widget::ghq::session            # C-g
bindkey "^[g"       widget::ghq::dir                # Alt-g
bindkey "^A"        beginning-of-line               # C-a
bindkey "^E"        end-of-line                     # C-e
bindkey "^K"        kill-line                       # C-k
bindkey "^Q"        push-line-or-edit               # C-q
bindkey "^W"        vi-backward-kill-word           # C-w
bindkey "^X^W"      forward-kill-word               # C-x C-w
bindkey "^?"        backward-delete-char            # backspace
bindkey "^[[3~"     delete-char                     # delete
bindkey "^[[1;3D"   backward-word                   # Alt + arrow-left
bindkey "^[[1;3C"   forward-word                    # Alt + arrow-right
bindkey "^[^?"      vi-backward-kill-word           # Alt + backspace
bindkey "^[[1;33~"  kill-word                       # Alt + delete
bindkey -M vicmd "^A" beginning-of-line             # vi: C-a
bindkey -M vicmd "^E" end-of-line                   # vi: C-e

# Change the cursor between 'Line' and 'Block' shape
function zle-keymap-select zle-line-init zle-line-finish {
    case "${KEYMAP}" in
        main|viins)
            printf '\033[6 q' # line cursor
            ;;
        vicmd)
            printf '\033[2 q' # block cursor
            ;;
    esac
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

### plugins ###
# disable auto plugin load for sheldon
# refs: https://zenn.dev/fuzmare/articles/zsh-plugin-manager-cache
cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
sheldon_cache="$cache_dir/sheldon.zsh"
sheldon_toml="$HOME/.config/sheldon/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  mkdir -p $cache_dir
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset cache_dir sheldon_cache sheldon_toml

### starship ###
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

### disable beep for wsl ###
unsetopt BEEP

### Aliases ###
alias la='ls -a'
alias ll='ls -al'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias exes="exec $SHELL -l"
alias gr='grep --color'
grr = () {
  grep -r $1 ./* --color
}
ggrr = () {
  git grep --color -r $1 ./*
}
alias vi='vim'
alias src='source'

### OS specific aliases ###
case "$OSTYPE" in
    linux*)
        (( ${+commands[wslview]} )) && alias open='wslview'
        if (( ${+commands[win32yank.exe]} )); then
            alias pp='win32yank.exe -i'
            alias p='win32yank.exe -o'
        elif (( ${+commands[xsel]} )); then
            alias pp='xsel -bi'
            alias p='xsel -b'
        fi
        alias ls='ls --color=auto'
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    ;;
    msys)
        alias cmake='command cmake -G"Unix Makefiles"'
        alias pp='cat >/dev/clipboard'
        alias p='cat /dev/clipboard'
        alias open="explorer.exe"
    ;;
    darwin*)
        alias ls='ls -G'
        alias chrome='open -a "Google Chrome"'
        (( ${+commands[gdate]} )) && alias date='gdate'
        (( ${+commands[gls]} )) && alias ls='gls --color=auto'
        (( ${+commands[gmkdir]} )) && alias mkdir='gmkdir'
        (( ${+commands[gcp]} )) && alias cp='gcp -i'
        (( ${+commands[gmv]} )) && alias mv='gmv -i'
        (( ${+commands[grm]} )) && alias rm='grm -i'
        (( ${+commands[gdu]} )) && alias du='gdu'
        (( ${+commands[ghead]} )) && alias head='ghead'
        (( ${+commands[gtail]} )) && alias tail='gtail'
        (( ${+commands[gsed]} )) && alias sed='gsed'
        (( ${+commands[ggrep]} )) && alias grep='ggrep'
        (( ${+commands[gfind]} )) && alias find='gfind'
        (( ${+commands[gdirname]} )) && alias dirname='gdirname'
        (( ${+commands[gxargs]} )) && alias xargs='gxargs'
    ;;
esac

### functions ###
(( ${+commands[trash]} )) && alias rm='trash'
mkcd() { command mkdir -p -- "$@" && builtin cd "${@[-1]:a}" }
j() {
    local root dir
    root="${$(git rev-parse --show-cdup 2>/dev/null):-.}"
    dir="$(fd --color=always --hidden --type=d . "$root" | fzf --select-1 --query="$*" --preview='fzf-preview-directory {}')"
    if [ -n "$dir" ]; then
        builtin cd "$dir"
        echo "$PWD"
    fi
}
jj() {
    local root
    root="$(git rev-parse --show-toplevel)" || return 1
    builtin cd "$root"
}
colors() {
	local fgc bgc vals seq0
	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"
	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black
			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}
			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}
# colrizing the man command
_man(){
    env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}
alias man="_man"
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### diff ###
diff() { command diff "$@" | bat --paging=never --plain --language=diff }
alias diffall='diff --new-line-format="+%L" --old-line-format="-%L" --unchanged-line-format=" %L"'

### less ###
export LESSHISTFILE='-'

### zsh-replace-multiple-dots ###
replace_multiple_dots_exclude_go() {
    if [[ "$LBUFFER" =~ '^go ' ]]; then
        zle self-insert
    else
        zle .replace_multiple_dots
    fi
}
zle -N .replace_multiple_dots replace_multiple_dots
zle -N replace_multiple_dots replace_multiple_dots_exclude_go

### completion styles ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### GPG ###
export GPG_TTY="$(tty)"

### wget ###
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'

### Make ###
alias make='make -j$(($(nproc)+1))'

### CMake ###
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug -B "$(git rev-parse --show-toplevel)/build"'
alias cmakerel='cmake -DCMAKE_BUILD_TYPE=Release -B "$(git rev-parse --show-toplevel)/build"'
cmakeb() { cmake --build "${1:-$(git rev-parse --show-toplevel)/build}" -j"$(($(nproc)+1))" "${@:2}" }
cmaket() { ctest --verbose --test-dir "${1:-$(git rev-parse --show-toplevel)/build}" "${@:2}" }

### tealdeer ###
export TEALDEER_CONFIG_DIR="$XDG_CONFIG_HOME/tealdeer"

### exa ###
# exa is currently maintained. currently using eza for substitution.
alias exa="eza"
alias ls='exa --group-directories-first'
alias la='exa --group-directories-first -a'
alias ll='exa --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso'
alias tree='exa --group-directories-first -T --icons'

### hgrep ###
alias hgrep="hgrep --hidden --glob='!.git/'"

### navi ###
__navi_search() {
    LBUFFER="$(navi --print --query="$LBUFFER")"
    zle reset-prompt
}
export NAVI_CONFIG="$XDG_CONFIG_HOME/navi/config.yaml"
zle -N __navi_search
bindkey '^N' __navi_search

### chpwd-recent-dirs ###
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "$XDG_STATE_HOME/chpwd-recent-dirs"

### direnv ###
(( ${+commands[direnv]} )) && eval "$(direnv hook zsh)"

### FZF ###
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'

### bat ###
export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"
alias cat='bat --paging=never'
alias batman='bat --language=man --plain'

### ripgrep ###
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

### zeno.zsh ###
export ZENO_HOME="$XDG_CONFIG_HOME/zeno"
export ZENO_ENABLE_SOCK=1
export ZENO_DISABLE_BUILTIN_COMPLETION=1
export ZENO_GIT_CAT="bat --color=always"
export ZENO_GIT_TREE="exa --tree"
if [[ -n $ZENO_LOADED ]]; then
    bindkey ' '  zeno-auto-snippet
    bindkey '^M' zeno-auto-snippet-and-accept-line
    bindkey '^P' zeno-completion
fi

### zoxide ###
eval "$(zoxide init zsh)"

### git ###
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gcam='git commit --amend -m'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gsw='git switch'
alias gb='git branch'
alias gpo='git push origin "$(git symbolic-ref --short HEAD)"'
gta() {
    version=$1
    git tag -a $version -m $version
}
alias gpt='git push --tags'

### Docker ###
docker() {
    if [ "$#" -eq 0 ] || [ "$1" = "compose" ] || ! command -v "docker-$1" >/dev/null; then
        command docker "${@:1}"
    else
        "docker-$1" "${@:2}"
    fi
}
docker-clean() {
    command docker ps -aqf status=exited | xargs -r docker rm --
}
docker-cleani() {
    command docker images -qf dangling=true | xargs -r docker rmi --
}
docker-rm() {
    if [ "$#" -eq 0 ]; then
        command docker ps -a | fzf --exit-0 --multi --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm --
    else
        command docker rm "$@"
    fi
}
docker-rmi() {
    if [ "$#" -eq 0 ]; then
        command docker images | fzf --exit-0 --multi --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi --
    else
        command docker rmi "$@"
    fi
}

### Editor ###
export EDITOR="vi"
(( ${+commands[vim]} )) && EDITOR="vim"
(( ${+commands[nvim]} )) && EDITOR="nvim"
export GIT_EDITOR="$EDITOR"
e() {
    if [ $# -eq 0 ]; then
        local selected="$(fd --hidden --color=always --type=f  | fzf --exit-0 --multi --preview="fzf-preview-file {}" --preview-window="right:60%")"
        [ -n "$selected" ] && "$EDITOR" -- ${(f)selected}
    else
        command "$EDITOR" "$@"
    fi
}

### Suffix alias ###
alias -s {bz2,gz,tar,xz}='tar xvf'
alias -s zip=unzip
alias -s d=rdmd

### asdf-vm ###
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"

### Node.js ###
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"

### npm ###
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

### irb ###
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

### Python ###
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

### pylint ###
export PYLINTHOME="$XDG_CACHE_HOME/pylint"

### SQLite3 ###
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"

### MySQL ###
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"

### PostgreSQL ###
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"

### local ###
if [ -f "$ZDOTDIR/.zshrc.local" ]; then
    source "$ZDOTDIR/.zshrc.local"
fi

