#!/bin/bash

# Este script funciona como um "toggle" para seu ambiente de desenvolvimento temporário.
# A cada execução, ele alterna entre ativar e desativar as configurações.
#
# Uso: source ./toggle.sh
#
# O uso de 'source' é crucial para que as variáveis de ambiente sejam aplicadas na sessão atual do shell.

# --- Variáveis de Caminho ---
# Define o caminho base para seus arquivos de configuração.
DOTFILES_BASE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS_PATH="$DOTFILES_BASE_PATH/configs"

# --- Lógica de Toggle ---
# Verifica se a variável MYVIMRC já está definida.
# Usamos ela como indicador do estado atual do ambiente.
if [ -z "$MYVIMRC" ]; then
    # O ambiente não está ativo, então vamos ativá-lo.
    echo "Ambiente de desenvolvimento temporário ativado..."

    # Configuração do VIM: aponta para o seu arquivo .vimrc
    export MYVIMRC="$CONFIGS_PATH/.vimrc"

    # Configuração do tmux: aponta para o seu arquivo .tmux.conf
    export TMUX_CONF="$CONFIGS_PATH/.tmux.conf"

    # Adicione outras ferramentas aqui, se necessário.

    echo "Suas ferramentas (vim, tmux, etc.) usarão as configurações de '$CONFIGS_PATH'."
else
    # O ambiente já está ativo, então vamos desativá-lo.
    echo "Ambiente de desenvolvimento temporário desativado..."

    # Limpa as variáveis de ambiente.
    unset MYVIMRC
    unset TMUX_CONF

    echo "Variáveis de configuração limpas. Retornando ao estado padrão."
fi
