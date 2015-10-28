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

#   This function is meant to retrieve the current branch name that you are on
#   The function will echo out this current branch name
function git-branch-name
{
    echo $(git symbolic-ref HEAD --short)
}

#   This function will find out how many commits behind your remote master
#   you currently are. In order for this to work, you have to have your repo
#   connected to an upstream remote.
function git-unpushed {
    brinfo=$(git branch -v | grep $(git-branch-name))
    if [[ $brinfo =~ ("[ahead "([[:digit:]]*)) ]]
    then
        echo "(${BASH_REMATCH[2]})"
    fi
}

#   This function is meant to show when their are changes in the repo
#   that have been staged for commit, but have not been commited yet.
#   When this is the case, then it will show a + in the command prompt.
function git-dirtycommit {
    st1=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep 'A ')
    st2=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep 'M ')
    st3=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep 'D ')
    st4=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep 'R ')
    if [[ $st1 == "A " || $st2 == "M " || $st3 == "D " || $st4 == "R " ]]
    then
        echo "+"
    else
        echo ""
    fi
}

#   This function is meant to show when your repo is dirty, meaning that
#   it has changes that have not been staged for commit. If this is the
#   case, then it will show an asterisk in the command prompt.
function git-dirty {
    st1=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep ' M')
    st2=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep '??')
    st3=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep ' D')
    if [[ $st1 == " M" || $st2 == "??" || $st3 == " D" ]]
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
        echo " ("$(git-branch-name)$(git-unpushed)$(git-dirty)$(git-dirtycommit)")"
    fi
}

#   Change Prompt
#   ------------------------------------------------------------
export PS1='\[\033[0;31m\]@\u:\[\033[0;34m\]\w\[\033[0;92m\]$(gitify)\n$ '
trap 'printf "\e[m" "$_"' DEBUG           # This resets the color after enter in terminal
