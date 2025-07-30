#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: $0 archivo_de_log"
    exit 1
fi

archivo="$1"

# Campos que quieres mostrar (por nombre)
campos=("act" "src" "spt" "request" "msg" "cs1" "cs2")

# Pasar lista de campos a awk
campo_str=$(IFS=, ; echo "${campos[*]}")

awk -v campos="$campo_str" '
BEGIN {
    n = split(campos, mostrar)
}
{
    # Buscar desde CEF:0 hacia adelante
    match($0, /CEF:0\|.*$/, m)
    if (!m[0]) next

    cef = m[0]
    delete valores

    # Buscar cada campo del arreglo
    for (i = 1; i <= n; i++) {
        clave = mostrar[i]
        pattern = clave "=([^ ]+)"
        if (match(cef, pattern, r)) {
            valores[clave] = r[1]
        } else {
            valores[clave] = "-"
        }
    }

    # Imprimir salida en orden
    for (i = 1; i <= n; i++) {
        clave = mostrar[i]
        printf "%s: %-30s | ", toupper(clave), valores[clave]
    }
    print ""
}
' "$archivo"
