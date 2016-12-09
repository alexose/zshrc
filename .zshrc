export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

source ~/.aliases

# github
function new_github_repo(){
    if [ -z "$1" ]
        then
            echo "Usage: github [name]"
        else
            curl https://$USER:$PASS@api.github.com/user/repos -d '{"name":"'$1'"}'
            cd ~
            mkdir $1
            cd $1
            touch README.md
            git init
            git add -A
            git commit -am "Initial commit."
            git remote add origin git@github.com:$USER/$1.git
            git push origin master
    fi
}
alias github='new_github_repo'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="/Users/alexose/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:$HOME/.npm-packages/bin"
export PATH="/usr/local/sbin:$PATH"

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# added by travis gem
[ -f /Users/alexose/.travis/travis.sh ] && source /Users/alexose/.travis/travis.sh

# via https://gist.github.com/jpouellet/5278239
# This script prints a bell character when a command finishes
# if it has been running for longer than $zbell_duration seconds.
# If there are programs that you know run long that you don't
# want to bell after, then add them to $zbell_ignore.
#
# This script uses only zsh builtins so its fast, there's no needless
# forking, and its only dependency is zsh and its standard modules
#
# Written by Jean-Philippe Ouellet <jpo@vt.edu>
# Made available under the ISC license.

# only do this if we're in an interactive shell
[[ -o interactive ]] || return

# get $EPOCHSECONDS. builtins are faster than date(1)
zmodload zsh/datetime || return

# make sure we can register hooks
autoload -Uz add-zsh-hook || return

# initialize zbell_duration if not set
(( ${+zbell_duration} )) || zbell_duration=10

# initialize zbell_ignore if not set
(( ${+zbell_ignore} )) || zbell_ignore=("vim")

# initialize it because otherwise we compare a date and an empty string
# the first time we see the prompt. it's fine to have lastcmd empty on the
# initial run because it evaluates to an empty string, and splitting an
# empty string just results in an empty array.
zbell_timestamp=$EPOCHSECONDS

# right before we begin to execute something, store the time it started at
zbell_begin() {
	zbell_timestamp=$EPOCHSECONDS
	zbell_lastcmd=$1
}

# when it finishes, if it's been running longer than $zbell_duration,
# and we dont have an ignored command in the line, then print a bell.
zbell_end() {
	ran_long=$(( $EPOCHSECONDS - $zbell_timestamp >= $zbell_duration ))

	has_ignored_cmd=0
	for cmd in ${(s:;:)zbell_lastcmd//|/;}; do
		words=(${(z)cmd})
		util=${words[1]}
		if (( ${zbell_ignore[(i)$util]} <= ${#zbell_ignore} )); then
			has_ignored_cmd=1
			break
		fi
	done

	if (( ! $has_ignored_cmd )) && (( ran_long )); then
		 afplay /Users/alexose/sine1.mp3 -t 0.1
	fi
}

# register the functions as hooks
add-zsh-hook preexec zbell_begin
add-zsh-hook precmd zbell_end
