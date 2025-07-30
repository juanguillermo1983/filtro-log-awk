# filtro-log-awk


'''archivo="archivo_de_log"; RED="\033[31m"; RESET="\033[0m"; [ ! -f "$archivo" ] && echo "El archivo '$archivo' no existe." && exit 1; tail -f "$archivo" | awk -v red="$RED" -v reset="$RESET" '{ fecha = $1 " " $2 " " $3; match($0, /CEF:0\|.*$/, m); if (m[0]) { cef = m[0]; match(cef, /src=([^ ]+)/, src); match(cef, /request=([^ ]+)/, request); match(cef, /msg=([^ ]+)/, msg); match(cef, /cs1=([^ ]+)/, policy); match(cef, /act=([^ ]+)/, act); url = request[1]; if (length(url) > 50) { url = substr(url, 1, 50) "..." }; act_val = act[1]; if (tolower(act_val) == "blocked") { act_val = red act_val reset }; printf "%s | SRC: %-15s | ACT: %-7s | POLICY: %-30s | MSG: %-30s | URL: %s\n", fecha, src[1], act_val, policy[1], msg[1], url } }'
 '''


 # Guía Básica de AWK

`awk` es una poderosa herramienta para procesamiento de texto y análisis de archivos de texto, especialmente útil para trabajar con datos estructurados en columnas.

---

## Conceptos Básicos

- **Campo:** Cada línea de texto se divide en campos separados por un delimitador (por defecto espacio o tabulación).  
  - `$1` es el primer campo, `$2` el segundo, y así sucesivamente.  
  - `$0` representa la línea completa.

- **Patrón-Acción:** La estructura básica es:  
  ```awk
  patrón { acción }