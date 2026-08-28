#!/usr/bin/env bash
# Descarga las bases de la SCVS y corre el filtro. Pensado para Claude Code
# en la web (contenedor Linux), donde no hay PC local ni carpeta de Descargas.
#
# Uso:  bash preparar.sh [carpeta_de_trabajo]
#
# No modifica filtrar_ranking.py.
set -uo pipefail

BASE="https://appscvsmovil.supercias.gob.ec/ranking/recursos"
TRABAJO="${1:-$HOME/caudal}"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tamanos minimos esperados en bytes: si baja menos, la descarga se corto.
declare -A MINIMO=(
  [bi_ciiu.csv]=300000
  [bi_compania.csv]=40000000
  [bi_ranking.csv]=300000000
)

echo "== Carpeta de trabajo: $TRABAJO"
mkdir -p "$TRABAJO"
cp "$REPO/filtrar_ranking.py" "$TRABAJO/"

# El archivo grande al final: si algo falla, falla barato.
for a in bi_ciiu.csv bi_compania.csv bi_ranking.csv; do
  destino="$TRABAJO/$a"
  actual=$( [ -f "$destino" ] && stat -c%s "$destino" || echo 0 )
  if [ "$actual" -ge "${MINIMO[$a]}" ]; then
    echo "== $a ya esta completo ($actual bytes), no lo vuelvo a bajar"
    continue
  fi
  echo "== Descargando $a ..."
  # -C - reanuda si quedo a medias; el servidor de la SCVS corta conexiones
  # con frecuencia, de ahi los reintentos.
  curl -# -C - --retry 10 --retry-delay 5 --retry-all-errors \
       -o "$destino" "$BASE/$a"

  final=$( [ -f "$destino" ] && stat -c%s "$destino" || echo 0 )
  if [ "$final" -lt "${MINIMO[$a]}" ]; then
    echo "ERROR: $a bajo solo $final bytes (esperaba al menos ${MINIMO[$a]})." >&2
    echo "       La descarga quedo incompleta. Vuelve a correr este script." >&2
    exit 1
  fi
  echo "   OK $a: $final bytes"
done

echo
echo "== Ejecutando el filtro"
cd "$TRABAJO" && python3 filtrar_ranking.py
