#!/bin/bash

tail -f saved_text.txt | grep -i "act=block" | awk '
{
    # Captura solo desde "CEF:0|..." en adelante
    match($0, /CEF:0\|.*$/, m)
    if (m[0]) {
        cef = m[0]
        
        # Extraer campos clave
        match(cef, /src=([^ ]+)/, src)
        match(cef, /spt=([^ ]+)/, spt)
        match(cef, /method=([^ ]+)/, method)
        match(cef, /request=([^ ]+)/, request)
        match(cef, /msg=([^ ]+)/, msg)
        match(cef, /cs1=([^ ]+)/, policy)
        match(cef, /cs2=([^ ]+)/, profile)
        match(cef, /act=([^ ]+)/, act)

        # Mostrar en columnas bien ordenadas
        printf "SRC: %-15s | SPT: %-5s | METHOD: %-4s | ACT: %-7s | POLICY: %-30s | PROFILE: %-6s | MSG: %-30s | URL: %s\n",
               src[1], spt[1], method[1], act[1], policy[1], profile[1], msg[1], request[1]
    }
}
'
