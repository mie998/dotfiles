#!/bin/sh
set -eu

legacy_zshenv="$HOME/.config/zsh/.zshenv"
home_zshenv="$HOME/.zshenv"
home_vim="$HOME/.vim"
legacy_config_vim="$HOME/.config/vim"

# The new source installs ~/.zshenv as a regular file. Remove only the old
# managed target when ~/.zshenv still identifies it explicitly.
if [ -L "$home_zshenv" ] && [ "$(readlink "$home_zshenv")" = ".config/zsh/.zshenv" ]; then
    [ ! -f "$legacy_zshenv" ] || rm -f "$legacy_zshenv"
fi

# Classic Vim is no longer managed. Only remove links created by the previous
# repository layout; leave arbitrary files, directories, and external links.
remove_legacy_config_vim=false
if [ -L "$home_vim" ]; then
    case "$(readlink "$home_vim")" in
        .config/vim|"$HOME/.config/vim")
            rm -f "$home_vim"
            remove_legacy_config_vim=true
            ;;
    esac
fi

if $remove_legacy_config_vim && [ -L "$legacy_config_vim" ]; then
    case "$(readlink "$legacy_config_vim")" in
        */config/vim) rm -f "$legacy_config_vim" ;;
    esac
fi
