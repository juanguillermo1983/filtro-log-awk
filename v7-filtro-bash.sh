#archivo="archivo_de_log"
archivo="$1"

[ ! -f "$archivo" ] && echo "El archivo '$archivo' no existe." && exit 1

tail -f "$archivo" | while read -r linea; do
  fecha=$(echo "$linea" | cut -d' ' -f1-3)
  cef=$(echo "$linea" | grep -o 'CEF:0|.*')

  if [ -n "$cef" ]; then
    src=$(echo "$cef" | sed -n 's/.*src=\([^ ]*\).*/\1/p')
    request=$(echo "$cef" | sed -n 's/.*request=\([^ ]*\).*/\1/p')
    msg=$(echo "$cef" | sed -n 's/.*msg=\([^ ]*\).*/\1/p')
    policy=$(echo "$cef" | sed -n 's/.*cs1=\([^ ]*\).*/\1/p')
    act=$(echo "$cef" | sed -n 's/.*act=\([^ ]*\).*/\1/p')

    # Acortar URL si es muy larga
    if [ ${#request} -gt 50 ]; then
      request="${request:0:50}..."
    fi

    printf "%s | SRC: %-15s | ACT: %-7s | POLICY: %-30s | MSG: %-30s | URL: %s\n" \
           "$fecha" "$src" "$act" "$policy" "$msg" "$request"
  fi
done
