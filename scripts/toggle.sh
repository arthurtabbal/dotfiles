#!/bin/bash

# Este script é executado dentro da sessão do tmux.
# Ele irá aplicar as configurações e ativar o ambiente temporário.

# URLs dos arquivos de configuração no seu repositório.
VIMRC_URL="https://raw.githubusercontent.com/arthurtabbal/dotfiles/main/configs/.vimrc"
TMUX_CONF_URL="https://raw.githubusercontent.com/arthurtabbal/dotfiles/main/configs/.tmux.conf"

# Pega o conteúdo dos arquivos de configuração sem salvá-los.
VIMRC_CONTENT=$(curl -s "$VIMRC_URL")
TMUX_CONF_CONTENT=$(curl -s "$TMUX_CONF_URL")

# Aplica as configurações temporariamente.
# O tmux usará a configuração embutida.
tmux start-server

# Manda o tmux usar a configuração baixada.
tmux source-file <(echo "$TMUX_CONF_CONTENT")

# Cria uma função que irá usar a configuração do vim.
function dev_vim() {
    echo "$VIMRC_CONTENT" > /tmp/.temp_vimrc_$$
    command vim -u /tmp/.temp_vimrc_$$ "$@"
    rm /tmp/.temp_vimrc_$$
}

# Exporta a função para que ela seja visível em sub-shells.
export -f dev_vim

# Cria um alias temporário.
alias vim='dev_vim'

# Mantém o shell interativo.
exec bash
