if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    alias config="/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
end   
    set fish_emoji_width 2
    set fish_ambiguous_width 2

    # Cardano Node
    set TESTNET --testnet-magic 1097911063
    set CARDANO_NODE_SOCKET_PATH ~/cardano/testnet/node.socket
    alias testnode="cardano-node run --topology ~/cardano/testnet/config/testnet-topology.json --database-path ~/cardano/testnet/db --socket-path $CARDANO_NODE_SOCKET_PATH --port 3001 --config ~/cardano/testnet/config/testnet-config.json"
    alias ctip="cardano-cli query tip $TESTNET"

direnv hook fish | source
