#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Função de limpeza
# -----------------------------
cleanup() {
    # mata servidor tmux efêmero se ainda existir
    if tmux -L "$TMUX_SRV" has-session 2>/dev/null; then
        tmux -L "$TMUX_SRV" kill-server >/dev/null 2>&1 || true
    fi

    # remove sockets órfãos
    rm -rf /tmp/tmux-$(id -u)/ephemeral-* >/dev/null 2>&1 || true

    # remove tmpdir efêmero
    rm -rf "$TMPDIR"
}

# garante execução da limpeza ao sair do script, erro ou Ctrl+C
trap cleanup EXIT
trap 'echo "Erro na linha $LINENO: comando \"$BASH_COMMAND\" falhou com código $?"; exit 1' ERR

# -----------------------------
# Preparar tmpdir e dotfiles
# -----------------------------

TMPDIR="$(mktemp -d -t dotfiles-XXXXXXXX)"
CONF="$TMPDIR/repo/configs"

# variável de configuração do vim
export VIMINIT="let \$MYVIMRC='$CONF/.vimrc' | source \$MYVIMRC"

git clone --depth=1 https://github.com/arthurtabbal/dotfiles.git "$TMPDIR/repo"
TMUX_CONF="$CONF/.tmux.conf"
TMUX_SRV="ephemeral-$$"

# -----------------------------
# Limpa servidores efêmeros antigos
# -----------------------------
ps -eo pid,command \
    | grep "tmux -L ephemeral" \
    | grep -v grep \
    | awk '{print $1}' \
    | xargs -r kill >/dev/null 2>&1 || true

# -----------------------------
# Inicia tmux efêmero
# -----------------------------

# cria sessão efêmera com todas as janelas de uma vez
tmux -L "$TMUX_SRV" -f "$TMUX_CONF" new-session -d -s NoHarm -n "painel" \
  \; new-window -n getname \
  \; new-window -n anony

# --- painelBOARD: seleciona a janela pelo nome e cria panes ---
tmux -L "$TMUX_SRV" select-window -t "NoHarm:painel"
tmux -L "$TMUX_SRV" split-window -h -t "NoHarm:painel"
tmux -L "$TMUX_SRV" send-keys -t "NoHarm:painel".2 'command -v btop &>/dev/null && btop || command -v htop &>/dev/null && top' C-m
tmux -L "$TMUX_SRV" select-layout -t "NoHarm:painel"

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

