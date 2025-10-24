#!/usr/bin/env bash
set -euo pipefail

trap 'echo "Erro na linha $LINENO: comando \"$BASH_COMMAND\" falhou com código $?"; exit 1' ERR

# cria tmpdir efêmero
TMPDIR="$(mktemp -d -t dotfiles-XXXXXXXX)"
trap 'rm -rf "$TMPDIR"' EXIT

# baixa repo (shallow)
git clone --depth=1 https://github.com/arthurtabbal/dotfiles.git "$TMPDIR/repo"
CONF="$TMPDIR/repo/configs"

# VIM efêmero
export VIMINIT="let \$MYVIMRC='$CONF/.vimrc' | source \$MYVIMRC"

# --- TMUX ---
SCHEMA="${1:-}"  # argumento opcional
WIN1_NAME="dashboard${SCHEMA:+ {$SCHEMA}}"

TMUX_CONF="$CONF/.tmux.conf"
TMUX_SRV="ephemeral-$$"

# cria sessão e primeira janela
tmux -L "$TMUX_SRV" -f "$TMUX_CONF" new-session -d -s NoHarm -n "$WIN1_NAME"

# curto delay para evitar erro de criação de janelas
sleep 0.1

# cria as outras janelas
tmux new-window -t NoHarm -n getname
tmux new-window -t NoHarm -n anony

# --- DASHBOARD: 2 panes verticais ---
tmux send-keys -t NoHarm:1.0 'command -v btop &>/dev/null && btop || command -v htop &>/dev/null && htop || top' C-m
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

