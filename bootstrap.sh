#! /bin/sh

## shamelessly stolen from @julian
## https://github.com/Julian/dotfiles/blob/7079cd371c7b08dcfae7741fc278c52e3f0caeee/bootstrap.sh

set -e

DOTFILES_URL='https://github.com/mrlannigan/dotfiles.git'
DOTFILES_DEST=$HOME/.dotfiles


if [ -z "$DOTFILES_DEBUG" ]; then
    verbosity='--quiet'
fi


main()
{
    clone_dotfiles
    install_other_brew_packages
    install_nvm
    continue_with_dot
}

clone_dotfiles()
{
    echo 'Setting up the dotfiles repo.'

    if [ ! -d $DOTFILES_DEST ]; then
        setup

        echo "Cloning $DOTFILES_URL into $DOTFILES_DEST..."

        ensure_installed git
        (
            git clone $verbosity $DOTFILES_URL $DOTFILES_DEST
            cd $DOTFILES_DEST
            git submodule $verbosity init
            git submodule $verbosity update
        )
    else
        echo "Existing dotfiles found in $DOTFILES_DEST."
    fi
}

setup()
{
    if [ "$OSTYPE" = darwin* ]; then
        ensure_has_homebrew
    fi
}

ensure_has_homebrew()
{
    printf 'Checking for homebrew... '
     bin_exists brew && printf 'found\n' || {
        printf 'installing\n'
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    }
}

bin_exists()
{
    command -v $1 >/dev/null 2>&1
}

check_installed()
{
    if bin_exists brew; then
        brew list | grep "\b$1\b" >/dev/null
    elif bin_exists dpkg-query; then
        [ "`dpkg-query -W -f='${Status}\n' $1`" = 'install ok installed' ]
    fi
}

ensure_installed()
{
    for package; do
        check_installed $package || install $package
    done
}

install()
{
    printf "Installing $@..."
    sudo apt-get install $verbosity --yes --force-yes $@
    printf 'done\n'
}

install_other_brew_packages()
{
    ensure_installed forture cowsay thefuck wget
}

install_nvm()
{
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
}

continue_with_dot()
{
    exec $DOTFILES_DEST/dot install
}
