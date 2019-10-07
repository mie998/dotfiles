# added by Anaconda3 5.1.0 installer
# export PATH="/anaconda3/bin:$PATH"  # commented out by conda initialize

export PATH=$PATH:/usr/local/bin

# opam configuration
test -r /Users/mie/.opam/opam-init/init.sh && . /Users/mie/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# auto reflect change of this file
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# change color of directory to green
export LSCOLORS=cxfxcxdxbxegedabagacad
alias python="python3"
export PATH="$HOME/.pyenv/shims:$PATH"

