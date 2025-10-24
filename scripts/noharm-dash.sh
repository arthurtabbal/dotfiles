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
WIN1_NAME="dashboard${SCHEMA}"

TMUX_CONF="$CONF/.tmux.conf"
TMUX_SRV="ephemeral-$$"

# cria sessão efêmera com todas as janelas de uma vez
tmux -L "$TMUX_SRV" -f "$TMUX_CONF" new-session -d -s NoHarm -n "$WIN1_NAME" \
  \; new-window -n getname \
  \; new-window -n anony

# --- DASHBOARD: seleciona a janela pelo nome e cria panes ---
tmux -L "$TMUX_SRV" select-window -t "NoHarm:$WIN1_NAME"
tmux -L "$TMUX_SRV" split-window -h -t "NoHarm:$WIN1_NAME"
tmux -L "$TMUX_SRV" send-keys -t "NoHarm:$WIN1_NAME".2 'command -v btop &>/dev/null && btop || command -v htop &>/dev/null && top' C-m
tmux -L "$TMUX_SRV" select-layout -t "NoHarm:$WIN1_NAME"

# --- GETNAME: roda docker logs se container existir ---
tmux -L "$TMUX_SRV" split-window -h -t "NoHarm:getname"
tmux -L "$TMUX_SRV" send-keys -t "NoHarm:getname".2 "\
container=\$(docker ps --filter 'name=getname' --format '{{.Names}}' | head -n1); \
if [ -n \"\$container\" ]; then docker logs --tail 5 -f \$container; else echo 'Nenhum container getname encontrado'; fi" C-m

# --- ANONY: roda docker logs se container existir ---
tmux -L "$TMUX_SRV" split-window -h -t "NoHarm:anony"
tmux -L "$TMUX_SRV" send-keys -t "NoHarm:anony".2 "\
container=\$(docker ps --filter 'name=anony' --format '{{.Names}}' | head -n1); \
if [ -n \"\$container\" ]; then docker logs --tail 5 -f \$container; else echo 'Nenhum container anony encontrado'; fi" C-m

# anexa à sessão
tmux -L "$TMUX_SRV" attach -t NoHarm

