#!/usr/bin/env bash

set -u

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
state_file="$runtime_dir/waybar-network-public"
cache_file="$runtime_dir/waybar-network-public-ip"

refresh_waybar() {
    pkill -RTMIN+8 -x waybar 2>/dev/null || true
}

if [ "${1:-status}" = "toggle" ]; then
    if [ -f "$state_file" ]; then
        rm -f "$state_file"
    else
        public_ip="$(curl -4 -fsS --max-time 5 https://api.ipify.org 2>/dev/null || true)"

        if [[ "$public_ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            printf '%s\n' "$public_ip" > "$cache_file"
        else
            rm -f "$cache_file"
        fi

        printf 'public\n' > "$state_file"
    fi

    refresh_waybar
    exit 0
fi

if [ -f "$state_file" ]; then
    public_ip="$(head -n 1 "$cache_file" 2>/dev/null || true)"

    if [ -n "$public_ip" ]; then
        text="$public_ip "
        tooltip="IP público de saída\nClique para voltar à rede local"
        class="public"
    else
        text="IP público indisponível ⚠"
        tooltip="Não foi possível consultar o IP público\nClique para voltar"
        class="disconnected"
    fi
else
    device="$(LC_ALL=C nmcli -t -f DEVICE,TYPE,STATE device status \
        | awk -F: '$2 == "wifi" && $3 == "connected" { print $1; exit }')"
    connection_type="wifi"

    if [ -z "$device" ]; then
        device="$(LC_ALL=C nmcli -t -f DEVICE,TYPE,STATE device status \
            | awk -F: '$2 == "ethernet" && $3 == "connected" { print $1; exit }')"
        connection_type="ethernet"
    fi

    if [ -n "$device" ]; then
        connection="$(LC_ALL=C nmcli -g GENERAL.CONNECTION device show "$device" \
            | sed 's/[[:space:]]*$//')"
        local_ip="$(ip -4 -o address show dev "$device" scope global \
            | awk '{ sub(/\/.*/, "", $4); print $4; exit }')"
        gateway="$(ip -4 route show default dev "$device" \
            | awk '{ print $3; exit }')"

        if [ "$connection_type" = "wifi" ]; then
            signal="$(LC_ALL=C nmcli -t -f ACTIVE,SIGNAL device wifi list --rescan no \
                | awk -F: '$1 == "yes" { print $2; exit }')"
            text="$connection (${signal:-?}%) "
        else
            text="$connection "
        fi

        tooltip="Interface: $device\nIP local: ${local_ip:-indisponível}\nGateway: ${gateway:-indisponível}\nClique para ver o IP público"
        class="connected"
    else
        text="Disconnected ⚠"
        tooltip="Nenhuma conexão Wi-Fi ou Ethernet ativa"
        class="disconnected"
    fi
fi

jq -cn \
    --arg text "$text" \
    --arg tooltip "$tooltip" \
    --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class}'
