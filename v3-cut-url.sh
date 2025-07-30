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

# Procesa el archivo con awk y muestra salida ordenada
tail -f "$archivo" | grep -i "act=block" | awk '
{
    match($0, /CEF:0\|.*$/, m)
    if (m[0]) {
        cef = m[0]
        match(cef, /src=([^ ]+)/, src)
        match(cef, /spt=([^ ]+)/, spt)
        match(cef, /method=([^ ]+)/, method)
        match(cef, /request=([^ ]+)/, request)
        match(cef, /msg=([^ ]+)/, msg)
        match(cef, /cs1=([^ ]+)/, policy)
        match(cef, /cs2=([^ ]+)/, profile)
        match(cef, /act=([^ ]+)/, act)

        url = request[1]
        if (length(url) > 70) {
            url = substr(url, 1, 70) "..."
        }

        # Imprime en formato compacto sin espacios extra
        printf "SRC:%s | SPT:%s | METHOD:%s | ACT:%s | POLICY:%s | PROFILE:%s | MSG:%s | URL:%s\n",
               src[1], spt[1], method[1], act[1], policy[1], profile[1], msg[1], url
    }
}
'
