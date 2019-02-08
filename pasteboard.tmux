#!/usr/bin/env bash

common() {
    tmux setw -g mode-keys vi
    tmux set -g set-clipboard off
    tmux bind-key -T copy-mode-vi v send-keys -X begin-selection
    tmux bind-key -T copy-mode-vi H send-keys -X start-of-line
    tmux bind-key -T copy-mode-vi L send-keys -X end-of-line
    tmux bind-key -T copy-mode-vi / command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
    tmux bind-key -T copy-mode-vi ? command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""
    tmux unbind-key ]
}

linux() {
    tmux bind-key -T copy-mode-vi y send-key -X copy-pipe-and-cancel "xclip -i -selection primary -f | xclip -i -selection clipboard"
    tmux bind-key -T copy-mode-vi MouseDragEnd1Pane send-key -X copy-pipe-and-cancel "xclip -i -selection primary -f | xclip -i -selection clipboard"
    tmux bind-key ] run "xclip -o -selection clipboard | tmux load-buffer -; tmux paste-buffer"
}

macos() {
    tmux bind-key -T copy-mode-vi y send-key -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    tmux bind-key -T copy-mode-vi MouseDragEnd1Pane send-key -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    tmux bind-key ] run "reattach-to-user-namespace pbpaste | tmux load-buffer -; tmux paste-buffer"
}

main() {
    common
    case `uname` in
        Linux)
            linux
            ;;
        Darwin)
            macos
            ;;
    esac
}

main
