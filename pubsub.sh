#!/usr/bin/env -S bash
# https://gist.github.com/jul/e9dcfdfb2490f6df3930dfe8ee29ead1
# WTFPL2.0 do WTF you want with the code except claiming paternity

# require ucspi-tcp http://cr.yp.to/ucspi-tcp/tcpserver.html
# server launched with tcpserver localhost 1234 ./pubsub.sh
# client launched with tcpclient localhost 1234 ./psclient.sh  # https://gist.github.com/jul/e9dcfdfb2490f6df3930dfe8ee29ead1#file-psclient-sh
# TODO unsub
# TODO trap SIHGUP to make file rotations (avoiding to have to stop/start server to do so)

set -e
declare -a action;
declare -a ppids;
exit_script() {
    d "killing all subs"
    for pid in "${ppids[@]}"; do
        kill $pid;
    done
    trap - SIGINT SIGTERM # clear the trap
    kill -- -$$ # Sends SIGTERM to child/sub processes
    e 1 "byebye"
}
trap exit_script SIGINT SIGTERM SIGPIPE SIGKILL

DEBUG=1
echo "Welcome"

RD='\e[31m'
GB='\e[33m'
BL='\e[34m'

GR='\e[0;90m\e[1;47m'
RZ='\e[0m'

atomic_create () {(set -o noclobber;>"$1") &>/dev/null; }

d() {
    set +e
    [ ! -z  "$DEBUG" ] && echo -e "[D]:$(date +%H:%M:%S):$GR $* $RZ"
    set -e
}
push() {
    local stack
    declare -a stack
    stack=( "$@" )
    for ((i=${#@}; i--; i)); do
        action=( "${stack[$i]}" "${action[@]}" );
    done
}

trim () {
    echo "$@" | delcr
}
check () { echo "$@" | perl -ane '/^([a-z0-9]+)$/ or die "[\e[31mE\e[0m] illicit characters detected only [a-z0-9] authorized"' 2>&1 ;}

w() {
    echo -e "[${BL}W${RZ}] $@" ;
}
i() {
    echo -e "[${GB}I${RZ}] $@" ;
}
[ -d out ] || mkdir out
e() {
    local EX="$1"
    shift
    echo -e "[${BL}EXITING${RZ}] ${*}"
    exit $EX
}
TCPREMOTEIP=${TCPREMOTEIP:-${SOCAT_PEERADDR:-${NCAT_PEERADDR:-}}}
TCPREMOTEPORT=${TCPREMOTEPORT:-${SOCAT_PEERPORT:-${NCAT_PEERPORT:-}}}
[ -z "TCPREMOTEIP" ] && e "cant find IP peer address"
[ -z "TCPREMOTEPORT" ] && e "cant find IP peer port"

pub() {
    local channel=$1;
    shift
    check $channel || (w illicit channel name $channel ;  return )
    [ -f out/$channel ] || ( i "creating <$channel>" )

    if [ -f out/$channel.lock ]; then
        w lock taken;
        return
    fi
    atomic_create out/$channel.lock
    echo -n "$TCPREMOTEIP:$TCPREMOTEPORT on $channel at $(date +'%H:%M:%S'): " >> out/$channel
    while (( ${#action} )); do
        echo -n $( echo ${action[0]} | delcr ) >> out/$channel
        echo -n " " >> out/$channel
        action=("${action[@]:1}")
    done
    echo >> out/$channel
    echo
    rm out/$channel.lock;
}
dispatch_action() {
    while [[ ${#action} -gt 0 ]]; do
    # pop in shell :D
        act=${action[0]}
        action=("${action[@]:1}")
    # end of pop
        case $act  in
            pub)
                channel=$( trim ${action[0]} )
                action=("${action[@]:1}")
                pub $channel
            ;;

            sub)
                argument=$( trim ${action[0]} )
                d "subscribing <$argument>"
                action=("${action[@]:1}")
                if [ ! -f out/$argument ]; then
                    w "<$argument> doesn't exist. Publish on channel to create ot"
                    break
                fi
                if check $argument; then
                    tail -f out/$argument &
                    ppids+=( "$!" );
                fi
            ;;
            bye)
                exit_script
            ;;
            \")
                d publishing in general
                push "pub" "general" 
            ;;
            \?)
                    cat <<EOF
        <channel> must be in form [a-z0-9]+

        ?
            this help

        pub <channel> [line of text to add in channel]
            publish on channel the text
            create channel if inexistant silently

        sub <channel>
            suscribe to channel

        bye
            exit cleanly and politely

        "
            publish on general channel to which you are subscribed at startup

EOF
            ;;
            *)
                i "unrecognized action <$act>. Try ? for help"
                break
            ;;
        esac
    done
}
push '"' "new subscriber entering"
d trying
sudo jul -S -c dispatch_action

push "sub" "general"
dispatch_action
while [ 1 ]; do
    echo -n "ready> "
    read -a action
    action=$( echo $action | delcr )
    dispatch_action
done
