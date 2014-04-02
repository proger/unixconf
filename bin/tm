#!/bin/bash

# Copyright (C) 2011, 2012, 2013 Joerg Jaspert <joerg@debian.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# .
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# .
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Always exit on errors
set -e
# Undefined variables, we don't like you
set -u
# ERR traps are inherited by shell functions, command substitutions and
# commands executed in a subshell environment.
set -E

########################################################################
# The following variables can be overwritten outside the script.
#

# We want a useful tmpdir, so set one if it isn't already.  Thats the
# place where tmux puts its socket, so you want to ensure it doesn't
# change under your feet - like for those with a daily-changing tmpdir
# in their home...
declare -r TMPDIR=${TMPDIR:-"/tmp"}

# Do you want me to sort the arguments when opening an ssh/multi-ssh session?
# The only use of the sorted list is for the session name, to allow you to
# get the same session again no matter how you order the hosts on commandline.
declare -r TMSORT=${TMSORT:-"true"}

# Want some extra options given to tmux? Define TMOPTS in your environment.
# Note, this is only used in the final tmux call where we actually
# attach to the session!
TMOPTS=${TMOPTS:-"-2"}

# The following directory can hold session config for us, so you can use them
# as a shortcut.
declare -r TMDIR=${TMDIR:-"${HOME}/.tmux.d"}

# Where does your tmux starts numbering its windows? Mine does at 1,
# default for tmux is 0. We try to find it out, but if we fail, (as we
# only check $HOME/.tmux.conf you can set this variable to whatever it
# is for your environment.
if [ -f "${HOME}/.tmux.conf" ]; then
    bindex=$(grep ' base-index ' ${HOME}/.tmux.conf || echo 0 )
    bindex=${bindex//* }
else
    bindex=0
fi
TMWIN=${TMWIN:-$bindex}
unset bindex

########################################################################
# Nothing below here to configure

# Store the commandline
declare -r cmdline=${1:-""}

# Get the tmux version and split it in major/minor
TMUXVERS=$(tmux -V)
declare -r TMUXVERS=${TMUXVERS##* }
declare -r TMUXMAJOR=${TMUXVERS%%.*}
declare -r TMUXMINOR=${TMUXVERS##*.}

# Save IFS
declare -r OLDIFS=${IFS}

########################################################################
function usage() {
    echo "tmux helper by Joerg Jaspert <joerg@ganneff.de>"
    echo "Call as: $0 CMD [host]..."
    echo ""
    echo "CMD is one of"
    echo " ls          List running sessions"
    echo " s           Open ssh session to host"
    echo " ms          Open multi ssh sessions to hosts, synchronizing input"
    echo " \$anything   Either plain tmux session with name of \$anything or"
    echo "             session according to TMDIR file"
    echo ""
    echo "TMDIR file:"
    echo "Each file in \$TMDIR defines a tmux session."
    echo "Filename is the commandline option \$anything"
    echo "Content is defined as:"
    echo "  First line: Session name"
    echo "  Second line: extra tmux options"
    echo "  Any following line: A hostname to open a shell with in the normal"
    echo "  ssh syntax. (ie [user@]hostname"
    echo ""
    echo "Environment variables recognized by this script:"
    echo "TMPDIR - Where tmux stores its session information"
    echo "         DEFAULT: If unset: /tmp"
    echo "TMSORT - Should ms sort the hostnames, so it always opens the same"
    echo "         session, no matter in which order hostnames are presented"
    echo "         DEFAULT: true"
    echo "TMOPTS - Extra options to give to the tmux call"
    echo "         Note that this ONLY affects the final tmux call to attach"
    echo "         to the session, not to the earlier ones creating it"
    echo "         DEFAULT: -2"
    echo "TMDIR  - Where are session information files stored"
    echo "         DEFAULT: ${HOME}/.tmux.d"
    echo "TMWIN  - Where does your tmux starts numbering its windows?"
    echo "         This script tries to find the information in your config,"
    echo "         but as it only checks $HOME/.tmux.conf it might fail".
    echo "         So if your window numbers start at anything different to 0,"
    echo "         like mine do at 1, then you can set TMWIN to 1"
    exit 42
}

# Check the first cmdline parameter, we might want to prepare something
case ${cmdline} in
    ls)
        # Simple overview of running sessions
        tmux list-sessions
        exit 0
        ;;
    s|ms)
        # Yay, we want ssh to a remote host - or even a multi session setup
        # So we have to prepare our session name to fit in what tmux (and shell)
        # allow us to have. And so that we can reopen an existing session, if called
        # with the same hosts again.
        sess="${*}"

        if [[ "${TMSORT}" = "true" ]]; then
            one=$1
            # get rid of first argument (s|ms), we don't want to sort this
            shift
            sess="$one $(for i in $sess; do echo $i; done | sort | tr '\n' ' ')"
            sess=${sess%% *}
        else
            # no sorting, wanted, so we just get rid of first argument (s|ms)
            shift
        fi

        # Neither space nor dot are friends in the SESSION name
        sess=${sess// /_}
        sess=${sess//./_}

        declare -r SESSION="${SESSION:-$(hostname -s)}${sess}"
        ;;
    *)
        # Nothing special (or something in our tmux.d)
        if [ $# -lt 1 ]; then
            usage
        fi
        if [ -r "${TMDIR}/$1" ]; then
            # Set IFS to be NEWLINE only, not also space/tab, as our input files
            # are \n seperated (one entry per line) and lines may well have spaces
            IFS="
"
            # Fill an array with our config
            TMDATA=( $(cat "${TMDIR}/$1") )
            # Restore IFS
            IFS=${OLDIFS}

            SESSION="$(hostname -s)_${TMDATA[0]}"
            # Neither space nor dot are friends in the SESSION name
            SESSION=${SESSION// /_}
            declare -r SESSION=${SESSION//./_}

            if [ "${TMDATA[1]}" != "NONE" ]; then
                TMOPTS=${TMDATA[1]}
            fi
        else
            # Not a config file, so just session name.
            TMDATA=""
            declare -r SESSION="${SESSION:-$(hostname -s)}${cmdline}"
        fi
        ;;
esac

# We only do special work if the SESSION does not already exist.
if ! tmux has-session -t ${SESSION} 2>/dev/null; then
    # In case we want some extra things...
    # Check stupid users
    if [ $# -lt 1 ]; then
        usage
    fi
    case ${cmdline} in
        s)
            # The user wants to open ssh to one or more hosts
            tmux new-session -d -s ${SESSION} -n "${1}" "ssh ${1}"
            # We disable any automated renaming, as that lets tmux set
            # the pane title to the process running in the pane. Which
            # means you can end up with tons of "bash". With this
            # disabled you will have panes named after the host.
            tmux set-window-option -t ${SESSION} automatic-rename off >/dev/null
            # If we have at least tmux 1.7, allow-rename works, such also disabling
            # any rename based on shell escape codes.
            if [ ${TMUXMINOR} -ge 7 ] || [ ${TMUXMAJOR} -gt 1 ]; then
                tmux set-window-option -t ${SESSION} allow-rename off >/dev/null
            fi
            shift
            count=2
            while [ $# -gt 0 ]; do
                tmux new-window -d -t ${SESSION}:${count} -n "${1}" "ssh ${1}"
                tmux set-window-option -t ${SESSION}:${count} automatic-rename off >/dev/null
                # If we have at least tmux 1.7, allow-rename works, such also disabling
                # any rename based on shell escape codes.
                if [ ${TMUXMINOR} -ge 7 ] || [ ${TMUXMAJOR} -gt 1 ]; then
                    tmux set-window-option -t ${SESSION}:${count} allow-rename off >/dev/null
                fi
                count=$(( count + 1 ))
                shift
            done
            ;;
        ms)
            # We open a multisession window. That is, we tile the window as many times
            # as we have hosts, display them all and have the user input send to all
            # of them at once.
            tmux new-session -d -s ${SESSION} -n "Multisession" "ssh ${1}"
            shift
            while [ $# -gt 0 ]; do
                tmux split-window -d -t ${SESSION}:${TMWIN} "ssh ${1}"
                # Always have tmux redo the layout, so all windows are evenly sized.
                # Otherwise you quickly end up with tmux telling you there is no
                # more space available for tiling - and also very different amount
                # of visible space per host.
                tmux select-layout -t ${SESSION}:${TMWIN} main-horizontal >/dev/null
                shift
            done
            # Now synchronize them
            tmux set-window-option -t ${SESSION}:${TMWIN} synchronize-pane >/dev/null
            # And set a final layout which ensures they all have about the same size
            tmux select-layout -t ${SESSION}:${TMWIN} tiled >/dev/null
            ;;
        *)
            # Whatever string, so either a plain session or something from our tmux.d
            if [ -z "${TMDATA}" ]; then
                # the easy case, just a plain session name
                tmux new-session -d -s ${SESSION}
            else
                # data in our data array, the user wants his own config

                # So lets start with the "first" line, before dropping into a loop
                tmux new-session -d -s ${SESSION} -n "Multisession" "ssh ${TMDATA[2]}"

                tmcount=${#TMDATA[@]}
                index=3
                while [ ${index} -lt ${tmcount} ]; do
                    tmux split-window -d -t ${SESSION}:${TMWIN} "ssh ${TMDATA[$index]}"
                    # Always have tmux redo the layout, so all windows are evenly sized.
                    # Otherwise you quickly end up with tmux telling you there is no
                    # more space available for tiling - and also very different amount
                    # of visible space per host.
                    tmux select-layout -t ${SESSION}:${TMWIN} main-horizontal >/dev/null
                    (( index++ ))
                done
                # Now synchronize them
                tmux set-window-option -t ${SESSION}:${TMWIN} synchronize-pane >/dev/null
                # And set a final layout which ensures they all have about the same size
                tmux select-layout -t ${SESSION}:${TMWIN} tiled >/dev/null
            fi
            ;;
    esac
    # Build up new session, ensure we start in the first window
    tmux select-window -t ${SESSION}:${TMWIN}
fi

# And last, but not least, attach to it
tmux ${TMOPTS} attach -t ${SESSION}
