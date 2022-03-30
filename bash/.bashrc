#change the 'ls' method
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -l'
alias gr='grep --color'

# change color: in sudo - red  in nomal - sian
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi

# opam configuration
test -r /Users/mie/.opam/opam-init/init.sh && . /Users/mie/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# starship configuration
eval "$(starship init bash)"

# function for atcoder
cpp_test() {
    problemname=$1
    oj dl "https://${problemname:0:6}.contest.atcoder.jp/tasks/${problemname:0:8}"
    g++ -Wall -std=c++14 ./$1.cpp
    oj test
    rm -f a.out
    rm -rf test
}

# function for c++ compile
cout() {
    filename=$1
    g++ -Wall -std=c++14 $1
    ./a.out < ~/purokon/etc/input.txt
    rm -f a.out
}
