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
git clone --depth=1 https://github.com/arthurtabbal/dotfiles.git "$TMPDIR/repo"
CONF="$TMPDIR/repo/configs"
TMUX_CONF="$CONF/.tmux.conf"
TMUX_SRV="ephemeral-$$"
export VIMINIT="let \$MYVIMRC='$CONF/.vimrc' | source \$MYVIMRC"

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
# - inicia shell no tmux
# - define alias para vim já carregar o .vimrc efêmero
tmux -L "$TMUX_SRV" -f "$TMUX_CONF" new-session -s arthur
