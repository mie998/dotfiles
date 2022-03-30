# fuction for c++ competitive programming
cout() {
    filename=$1
    g++ -Wall -ggdb3 -fsanitize=undefined -D_GLIBCXX_DEBUG -std=c++17 $1
    ./a.out < ~/Work/purokon/etc/input.txt
    rm -f a.out
}

# function for python competitive programming
pyout() {
    filename=$1
    python $1 < ~/Work/purokon/etc/input.txt
}

# function for online-judge-tools
ojd() {
    # download
    if [ -e test/ ]; then
        rm -rf test/
    fi
    url=$1
    oj download $url
}

ojt() {
    # test
    filename=$1
    g++ -Wall -std=c++17 $filename
    oj t 
    rm -f a.out
}
#######################################################
