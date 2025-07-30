#!/bin/bash

# Verifica que se pase un archivo como parámetro
if [ -z "$1" ]; then
    echo "Uso: $0 archivo_de_log"
    exit 1
fi

archivo="$1"

# Verifica que el archivo exista
if [ ! -f "$archivo" ]; then
    echo "El archivo '$archivo' no existe."
    exit 1
fi

RED="\033[31m"
RESET="\033[0m"

tail -f "$archivo" | awk -v red="$RED" -v reset="$RESET" '
{
    # Extraemos fecha y hora (los 3 primeros campos)
    fecha = $1 " " $2 " " $3

    match($0, /CEF:0\|.*$/, m)
    if (m[0]) {
        cef = m[0]
        match(cef, /src=([^ ]+)/, src)
        match(cef, /request=([^ ]+)/, request)
        match(cef, /msg=([^ ]+)/, msg)
        match(cef, /cs1=([^ ]+)/, policy)
        match(cef, /act=([^ ]+)/, act)

        url = request[1]
        if (length(url) > 50) {
            url = substr(url, 1, 50) "..."
        }

        act_val = act[1]
        if (tolower(act_val) == "blocked") {
            act_val = red act_val reset
        }

        printf "%s | SRC: %-15s | ACT: %-7s | POLICY: %-30s | MSG: %-30s | URL: %s\n",
               fecha, src[1], act_val, policy[1], msg[1], url
    }
}
'
