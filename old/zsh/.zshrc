#
# ~/.zshrc
#

#####################################################
### useful functions ###
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

#######################################################
### alias
# for linux coloring 'ls' 
alias ls='ls --color=auto'
# for OSX coloring 'ls' 
alias ls='ls -G'

alias la='ls -A'
alias ll='ls -l'
alias gr='grep --color'
grr = () {
  grep -r $1 ./* --color
}
ggrr = () {
  git grep --color -r $1 ./* 
}
alias vi='vim'
alias src='source'
alias vless='/usr/share/vim/vim82/macros/less.sh'
# secure file system
alias cp='cp -i'
alias rm='rm -i'
alias exes="exec $SHELL -l"

# for git commands
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gcm='git commit -m'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gch='git switch'
gta() {
    version=$1
    git tag -a $version -m $version
}
alias gpt='git push --tags'

# for docker commands
alias d="docker"
alias dk='docker'
alias dc="docker-compose"
alias dcn="docker container"
alias dim="docker image"
alias dpa="docker ps -a"
alias di="docker inspect"
#####################################################

#####################################################
# change shell color
autoload -U compinit
compinit

export LSCOLORS=cxfxcxdxbxegedabagacad
export LS_COLORS='di=32:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=32' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
######################################################

######################################################
# copied from https://gist.github.com/mollifier/4979906
# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# beep を無効にする
setopt no_beep
# フローコントロールを無効にする
setopt no_flow_control
# Ctrl+Dでzshを終了しない
setopt ignore_eof
# '#' 以降をコメントとして扱う
setopt interactive_comments
# ディレクトリ名だけでcdする
setopt auto_cd
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# 高機能なワイルドカード展開を使用する
setopt extended_glob
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# historyコマンドは履歴に登録しない
setopt hist_no_store
# 補完時にヒストリを自動的に展開
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history
# 履歴共有
setopt share_history
########################################
# キーバインド
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward
# history search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^h' zaw-history
########################################## options

# added 10/8,2019 for starship
eval "$(starship init zsh)"

########################################## zsh plugins
# mkdir ~/.zsh_plugins
# cd .zsh_plugins
# git clone git://github.com/zsh-users/zaw.git
source ~/.zsh_plugin/zaw/zaw.zsh
# https://github.com/marlonrichert/zsh-autocomplete
source ~/.zsh_plugin/zsh-autocomplete/zsh-autocomplete.plugin.zsh
########################################## 

# added PATH for cargo crates binaries
export PATH=/home/mie/.cargo/bin:$PATH
export RUST_BACKTRACE=1

# added 6/20, 2020 for locate command alias
# for install mlocate, check this site: https://www.tecmint.com/install-locate-command-to-find-files-in-centos/
alias loc='locate'

if [ -e "$HOME/.anyenv" ]
then
    export ANYENV_ROOT="$HOME/.anyenv"
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv 1>/dev/null 2>&1
    then
        eval "$(anyenv init -)"
    fi
fi

# added 04/14, 2021. for machine-dependent procedures
# https://qiita.com/awakia/items/1d5cd440ce58ef4fb8ae
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.docker_alias ] && source ~/.docker_alias