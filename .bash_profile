#  ---------------------------------------------------------------------------
#  David Adams - Bash Profile
#
#  Source: https://gist.github.com/natelandau/10654137
#          http://natelandau.com/my-mac-osx-bash_profile/
#          http://bytebaker.com/2012/01/09/show-git-information-in-your-prompt/
#          https://git-scm.com/docs/git-status
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   Git Aliases
#  4.   File and Folder Management
#  5.   Networking
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Functions are for git views in command prompt
#   ------------------------------------------------------------

#   This function is meant to retrieve the current branch name that you are on
#   The function will echo out this current branch name
function git-branch-name {
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
    st1=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c 'A ')
    st2=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c 'M ')
    st3=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c 'D ')
    st4=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c 'R ')
    if [[ $st1 > 0 || $st2 > 0 || $st3 > 0 || $st4 > 0 ]]
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
    st1=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c ' M')
    st2=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c '??')
    st3=$(git status --porcelain | awk '{print substr ($0, 0, 2)}' | grep -c ' D')
    if [[ $st1 > 0 || $st2 > 0 || $st3 > 0 ]]
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
export PS1='\[\e[1;31m\]@\u:\[\e[1;33m\]$(gitify) \[\e[1;34m\]\w\[\e[0;92m\]\n$ \[\e[0m\]'
trap 'printf "\e[m" "$_"' DEBUG           # This resets the color after enter in terminal

#   Set Default Editor
#   ------------------------------------------------------------
export EDITOR=/usr/bin/vim
alias vi=vim                               # set vim as default

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
export BLOCKSIZE=1k

#   Bash-completion
#   ------------------------------------------------------------
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
#alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias la='ls -GA'                            # Preferred actual 'ls' implementation
alias ll='ls -GFBlahp'                       # Preferred 'ls' implementation
cd() { builtin cd "$@" && ls -G; }             # Always list directory contents upon 'cd'
#alias less='less -FSRXc'                    # Preferred 'less' implementation
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='atom'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
#alias which='type -all'                     # which:        Find executables
#alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
#alias show_options='shopt'                  # Show_options: display bash options settings
#alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
#alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mkcd () { mkdir -p "$1" && cd "$1"; }        # mkcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
#ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
#alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias reload='source ~/.bash_profile'       # Reloads the shell with updated bash profile
alias desk='cd ~/Desktop'                   # Go to Desktop
alias work='cd ~/workspace'                 # Go to dev workspace
alias g15='cd ~/workspace/gSchool_15_DA'      # Go to gschool repo
alias xx='exit'                               # Exit terminal
alias superstatic='superstatic --debug true'  # Default superstatic to show network traffic

alias weather='curl http://wttr.in/Denver'    # Display the weather in the terminal

#Change default shell to zsh
alias changetozsh='chsh -s /bin/zsh'

#   -------------------------------
#   3.  Git Aliases
#   -------------------------------
alias gs="git status"
alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gl2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

#   -------------------------------
#   4.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }


#   ---------------------------
#   5.  NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
# alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }

#   ---------------------------
#   6.  Dev language specific
#   ---------------------------
#   Ruby:
#   ---------------------------------------------------------

  # Load RVM into a shell session *as a function*
  function sourceRVM() { [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"; }

#   Go:
#   ---------------------------------------------------------
  # Go path variables
  export GOPATH=$HOME/workspace/goWork
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$PATH:$GOPATH/bin
  export PATH=$PATH:$GOROOT/bin

#   Postgresql:
#   ---------------------------------------------------------
alias psqlstart='brew services start postgresql'
alias psqlrestart='brew services restart postgresql'
alias psqlstop='brew services stop postgresql'
