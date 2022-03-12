if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    alias config="/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
end
