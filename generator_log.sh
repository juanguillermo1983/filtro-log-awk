#!/bin/bash

# Archivo de salida
LOG_FILE="log-local.log"

# Lista de posibles acciones
actions=("blocked" "pass" "drop" "redirect")

# Lista de URLs simuladas
urls=(
  "https://www.webjuanito.cl/lorem-ipsum-dolor"
  "https://www.webjuanito.cl/quis-nostrud-exercitation"
  "https://www.webjuanito.cl/ullamco-laboris-nisi"
  "https://www.webjuanito.cl/ut-aliquip-ex-ea"
  "https://www.webjuanito.cl/commodo-consequat"
  "https://www.webjuanito.cl/duis-aute-irure"
)

# Función para generar una IP pública aleatoria
random_ip() {
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

# Función para obtener la hora actual en formato syslog
timestamp() {
    date "+%b %d %H:%M:%S"
}

# Función para generar una línea de log
generate_log_line() {
    local time=$(timestamp)
    local src_ip=$(random_ip)
    local spt=$((RANDOM % 60000 + 1024))
    local method="GET"
    local request=${urls[$RANDOM % ${#urls[@]}]}
    local msg="Disallow Illegal URL."
    local cn1=$((RANDOM % 999999999))
    local cn2=$((RANDOM % 999999999))
    local cs1="APPFW_www.webjuanito.cl"
    local cs2="PPE$((RANDOM % 4))"
    local cs3="AAA$(tr -dc A-Za-z0-9 </dev/urandom | head -c 64)"
    local cs4="ALERT"
    local cs5="2025"
    local act=${actions[$RANDOM % ${#actions[@]}]}
    local geo="Unknown"

    echo "$time <local0.info> 10.16.2.11  CEF:0|Citrix|NetScaler|NS14.1|APPFW|APPFW_STARTURL|6|src=$src_ip geolocation=$geo spt=$spt method=$method request=$request msg=$msg cn1=$cn1 cn2=$cn2 cs1=$cs1 cs2=$cs2 cs3=$cs3 cs4=$cs4 cs5=$cs5 act=$act"
}

# Bucle infinito para generación continua
echo "Generando logs en tiempo real en '$LOG_FILE' (Ctrl+C para detener)..."
while true; do
    generate_log_line >> "$LOG_FILE"
    sleep 0.5
done
