#!/bin/bash

#set -e

error() {
    MESSAGE="$*"
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo -e "${RED} ERROR: ${MESSAGE}${NC}"
    EXIT_CODE=63
}

alias mime='file --no-dereference  --mime-type  --brief'

create_symlink() (
    TARGET="$1"
    SYMLINK="$2"

    cd $(dirname $SYMLINK)
    # step 1: fix errors and special cases

    # Checking target existence
    if [ ! -e "$TARGET" ]; then
        error "\"$TARGET\" does not exist ?!"
        return 1
    fi

    # Fail when wanted symlink is a directory.
    # Something is wrong and requires manual intervention.
    if [ -d "$SYMLINK" ] && [ "$(mime $SYMLINK)" = "inode/directory" ]; then
        error "ERROR creating $SYMLINK: I am not replacing a folder"
        return 1
    fi

    # step 2: update symlink when necessary (=rm file)
    if [ -f $SYMLINK ]; then
        # special case where the wanted symlink is a plain file and
        # different than the target
        if [ ! -L $SYMLINK ] && ! diff -qr "$SYMLINK" "$TARGET" > /dev/null ; then
            echo "WARNING: Skipping locally edited file: \"$SYMLINK\""
            return 0
        fi

        current_target=$(readlink -f "$SYMLINK")
        wanted_target=$(realpath $TARGET)

        if [ "$current_target" != "$wanted_target" ]; then
            echo "Updating symlink from $current_target to $TARGET"
            /bin/rm -v "$SYMLINK"
        fi
    fi

    # create the symlink if necessary
    if [ ! -e "$SYMLINK" ]; then
        ln --verbose -s "$TARGET" "$SYMLINK"
    else
        echo $SYMLINK already installed
    fi
)

create_dotlink() {
    SYMLINK=$HOME/$1
    TARGET="$DIR/$1"
    create_symlink "$TARGET" "$SYMLINK"
}

CP="/bin/cp -av"

# This is a nice title
title() {
    echo
    echo " $*"
    echo "-----------------"
}

# Clone a Git repository
# arguments:
# 1. The URL of the repo
# 2. The target folder
# 3. The Git ref (optional)
gitget() {
    url=$1
    folder=$2
    git_ref=$3

    if [ -d $folder ]; then
        if [ "$OFFLINE" == "yes" ]; then
            echo "Skipping update of Git repo $url"
        else
            echo "Updating from \"${url}\" into \"${folder}\"..."
            cd $folder
            git fetch
            git -c advice.detachedHead=false checkout origin/HEAD
        fi
    else
        if [ "$OFFLINE" == "yes" ]; then
            error "Cannot download $url in offline mode"
            exit 1
        else
            echo "Downloading from $url into $folder..."
            set -x
            BRANCH=""
            if [ -n "$git_ref" ]; then
                BRANCH="--BRANCH $git_ref"
            fi
            git clone --depth 1 $BRANCH $url $folder
            cd $folder
        fi
    fi
    if [ -n "$git_ref" ]; then
        found="no"
        # we are looking for a branch name
        for refname in $(git for-each-ref --format='%(refname)' refs/remotes/origin refs/tags/); do
            if [ "refs/remotes/origin/$git_ref" == "$refname" ]; then
                found="yes"
                echo "Checking out to branch $git_ref"
                git reset --hard "origin/$git_ref"
                break
            fi
        done
        # branch name not found, this must be a commit hash
        if [ "$found" == "no" ]; then
            echo "Checking out ref \"$git_ref\"."
            git reset --hard "$git_ref"
        fi
    fi

    cd $DIR
}

# Clone a Gist file (from Github") into the tmp directory
# Arguments:
# - The Gist ID
function gist() {
    gist_id=$1
    if [ -n "$2" ]; then
        echo "wtf gist \"$2\" ( $* )"
        return 1
    fi

    echo Downloading Gist $gist_id
    mkdir -p ./tmp
    gitget https://gist.github.com/$gist_id.git ./tmp/$gist_id
}

function download() {
    local src="$1"
    local dest="$2"
    local perms="$3"

    if [ -f $dest ]; then
        echo "File $dest already exists"
        return 0
    fi

    echo Downloading $src
    curl --fail --location --no-progress-meter "$src" --output "$dest"

    if [ -n "$perms" ]; then
        chmod -v "$perms" "$dest"
    fi
}


function install_crontab() {

    if [ -z "$1" ] || [ ! -f "$1" ]; then
        error "wtf crontab faile"
        exit 2
    fi

    local CRONTAB_LOCAL=$( cat $1 )
    local CRONTAB_START='# dotlib Crontab start'
    local CRONTAB_END='# dotlib Crontab end'
    local CRONTAB_CLEAN=$( crontab -l | sed "/$CRONTAB_START/,/$CRONTAB_EID/d"  )

    echo -e "$CRONTAB_CLEAN\n\n$CRONTAB_START\n$CRONTAB_LOCAL\n$CRONTAB_END" | crontab -

}
