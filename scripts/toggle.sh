#!/usr/bin/env bash
set -euo pipefail

# cria tmpdir efêmero
TMPDIR="$(mktemp -d -t dotfiles-XXXXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT

# baixa repo (shallow) no tmpdir
git clone --depth=1 https://github.com/arthurtabbal/dotfiles.git "$TMPDIR/repo"

# caminho pras configs
CONF="$TMPDIR/repo/configs"

# --- VIM ---
# força vim usar o .vimrc efêmero
export VIMINIT="let \$MYVIMRC='$CONF/.vimrc' | source \$MYVIMRC"

# --- TMUX ---
TMUX_CONF="$CONF/.tmux.conf"
TMUX_SRV="ephemeral-$$"

# inicia tmux isolado com sua config
tmux -L "$TMUX_SRV" -f "$TMUX_CONF"

