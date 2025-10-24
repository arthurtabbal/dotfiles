#!/usr/bin/env bash
set -euo pipefail

trap 'echo "Erro na linha $LINENO: comando \"$BASH_COMMAND\" falhou com código $?"; exit 1' ERR

TMPDIR="$(mktemp -d -t dotfiles-XXXXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT

git clone --depth=1 https://github.com/arthurtabbal/dotfiles.git "$TMPDIR/repo"
CONF="$TMPDIR/repo/configs"

export VIMINIT="let \$MYVIMRC='$CONF/.vimrc' | source \$MYVIMRC"

# --- TMUX ---
SCHEMA="${1:-}"  # se não passar argumento, fica vazio
WIN1_NAME="dashboard${SCHEMA:+ {$SCHEMA}}"

TMUX_CONF="$CONF/.tmux.conf"
TMUX_SRV="ephemeral-$$"

# cria sessão e janelas
tmux -L "$TMUX_SRV" -f "$TMUX_CONF" new-session -d -s NoHarm -n "$WIN1_NAME"
tmux new-window -t NoHarm:2 -n getname
tmux new-window -t NoHarm:3 -n anony

# --- DASHBOARD: 2 panes verticais ---
# pane 0: btop | htop | top
tmux send-keys -t NoHarm:1.0 'command -v btop &>/dev/null && btop || command -v htop &>/dev/null && htop || top' C-m
# pane 1: split vertical
tmux split-window -h -t NoHarm:1
tmux send-keys -t NoHarm:1.1 'echo "Pane direito do dashboard"' C-m
tmux select-layout -t NoHarm:1 tiled

# --- GETNAME: roda docker logs se container existir ---
tmux send-keys -t NoHarm:2 "\
container=\$(docker ps --filter 'name=getname' --format '{{.Names}}' | head -n1); \
if [ -n \"\$container\" ]; then docker logs --tail 5 -f \$container; else echo 'Nenhum container getname encontrado'; fi" C-m

# --- ANONY: roda docker logs se container existir ---
tmux send-keys -t NoHarm:3 "\
container=\$(docker ps --filter 'name=anony' --format '{{.Names}}' | head -n1); \
if [ -n \"\$container\" ]; then docker logs --tail 5 -f \$container; else echo 'Nenhum container anony encontrado'; fi" C-m

# anexa à sessão
tmux attach -t NoHarm

