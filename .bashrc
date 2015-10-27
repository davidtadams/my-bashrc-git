#  ---------------------------------------------------------------------------
#  David Adams - Bash Profile code to create a custom prompt with git functionality
#
#  This is a good source for understanding more about how the git functionality
#  works for the Bash command prompt. Some of these functions, I re-wrote.
#  http://bytebaker.com/2012/01/09/show-git-information-in-your-prompt/
#
#  This is a good source for a general Bash profile to get started with
#  https://gist.github.com/natelandau/10654137
#
#  Note: only tested on OS X El Capitan 10.11
#  ---------------------------------------------------------------------------

#   -------------------------------
#   Setting up the command prompt
#   -------------------------------

#   Functions are for git views in command prompt
#   ------------------------------------------------------------
function git-branch-name
{
    echo $(git symbolic-ref HEAD --short)
}

function git-unpushed {
    brinfo=$(git branch -v | grep $(git-branch-name))
    if [[ $brinfo =~ ("[ahead "([[:digit:]]*)) ]]
    then
        echo "(${BASH_REMATCH[2]})"
    fi
}

function git-dirtycommit {
    st=$(git status --porcelain | head -n 1 | awk '{print $1;}')
    if [[ $st == "A" ]]
    then
        echo "+"
    else
        echo ""
    fi
}

function git-dirty {
    st=$(git status --porcelain | awk '{print $1;}')
    if [[ $st == "??" ]]
    then
        echo "*"
    else
        echo ""
    fi
}

#This is the main function that builds the git command prompt
function gitify {
    status=$(git status 2>/dev/null | head -n 1)
    if [[ $status == "" ]]
    then
        echo ""
    else
        echo " ("$(git-branch-name)$(git-dirty)$(git-dirtycommit)$(git-unpushed)")"
    fi
}

#   Change Prompt
#   ------------------------------------------------------------
export PS1='\[\033[0;31m\]@\u:\[\033[0;34m\]\w\[\033[0;92m\]$(gitify)\n$ '
trap 'printf "\e[m" "$_"' DEBUG           # This resets the color after enter in terminal
