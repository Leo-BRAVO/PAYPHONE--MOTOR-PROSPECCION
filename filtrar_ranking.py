# -*- coding: utf-8 -*-
"""
Filtra y arma en un solo archivo la base de la SCVS lista para trabajar.

Entradas (las tres en la misma carpeta que este script):
    bi_ranking.csv    ~356 MB   cifras financieras, todos los ejercicios
    bi_compania.csv   ~51 MB    nombre, RUC, tipo, provincia
    bi_ciiu.csv       ~393 KB   descripcion de los codigos de actividad

Salida:
    universo_2025.csv  unos pocos MB, ya cruzado y filtrado

Uso:  python filtrar_ranking.py
"""

import csv
import os
import sys

csv.field_size_limit(10_000_000)

# ---------------------------------------------------------------- parametros
ANIO = "2025"

# Filtro geografico. Vacio = todas las provincias.
PROVINCIAS = {"PICHINCHA", "GUAYAS", "AZUAY"}

# Banda de ingresos por ventas en dolares (inclusive en ambos extremos).
# Perfil objetivo: mediana-grande, con equipo de cobranza pero sin ERP
# con modulo de cobranza ni cobranza tercerizada.
VENTAS_MIN = 2_000_000.0
VENTAS_MAX = 50_000_000.0

# NO hay filtro por CIIU a proposito: el corte sectorial se decide despues,
# mirando las descripciones reales. El script solo trae los codigos y su
# descripcion para que se pueda revisar el universo completo.

RANKING = "bi_ranking.csv"
COMPANIA = "bi_compania.csv"
CIIU = "bi_ciiu.csv"
SALIDA = "universo_2025.csv"

# Columnas de bi_ranking que se conservan. El resto (40+ indicadores
# financieros) se descarta: es lo que hace que el archivo pase de MB a GB.
COLS_RANKING = [
    "expediente",
    "posicion_general",
    "ingresos_ventas",
    "ingresos_totales",
    "activos",
    "patrimonio",
    "utilidad_neta",
    "n_empleados",
    "cod_segmento",
    "ciiu_n1",
    "ciiu_n6",
]


def limpiar(valor):
    """Los archivos de la SCVS vienen con relleno de espacios a la derecha."""
    return (valor or "").strip()


def a_numero(valor):
    try:
        return float(limpiar(valor) or 0)
    except ValueError:
        return 0.0


def abrir(nombre):
    if not os.path.exists(nombre):
        sys.exit(f"ERROR: falta {nombre} en {os.getcwd()}")
    # utf-8-sig tolera archivos con y sin BOM
    return open(nombre, "r", encoding="utf-8-sig", errors="replace", newline="")


def indice(cabecera, nombre, archivo):
    objetivo = nombre.strip().lower()
    for i, c in enumerate(cabecera):
        if c.strip().lower() == objetivo:
            return i
    sys.exit(f"ERROR: la columna '{nombre}' no existe en {archivo}. "
             f"Cabecera leida: {cabecera}")


# ------------------------------------------------- 1. companias en memoria
print("Leyendo bi_compania.csv ...")
companias = {}
with abrir(COMPANIA) as f:
    lector = csv.reader(f)
    cab = next(lector)
    i_exp = indice(cab, "expediente", COMPANIA)
    i_ruc = indice(cab, "ruc", COMPANIA)
    i_nom = indice(cab, "nombre", COMPANIA)
    i_tip = indice(cab, "tipo", COMPANIA)
    i_pro = indice(cab, "provincia", COMPANIA)
    for fila in lector:
        if len(fila) <= i_pro:
            continue
        companias[limpiar(fila[i_exp])] = (
            limpiar(fila[i_ruc]),
            limpiar(fila[i_nom]),
            limpiar(fila[i_tip]),
            limpiar(fila[i_pro]).upper(),
        )
print(f"  {len(companias):,} companias".replace(",", "."))

# ------------------------------------------------------ 2. catalogo CIIU
print("Leyendo bi_ciiu.csv ...")
ciiu_desc = {}
with abrir(CIIU) as f:
    lector = csv.reader(f)
    cab = next(lector)
    i_cod = indice(cab, "ciiu", CIIU)
    i_des = indice(cab, "descripcion", CIIU)
    for fila in lector:
        if len(fila) > i_des:
            # OJO: la clave viene rellenada con espacios y en bi_ranking no.
            # Sin este strip el cruce devuelve vacio en todas las filas.
            ciiu_desc[limpiar(fila[i_cod])] = limpiar(fila[i_des])
print(f"  {len(ciiu_desc):,} codigos".replace(",", "."))

# -------------------------------------------- 3. recorrer el archivo grande
print(f"Recorriendo bi_ranking.csv (ejercicio {ANIO}, ventas entre "
      f"{VENTAS_MIN:,.0f} y {VENTAS_MAX:,.0f} USD) ...".replace(",", "."))
leidas = escritas = sin_match = 0

with abrir(RANKING) as fin, \
     open(SALIDA, "w", encoding="utf-8", newline="") as fout:

    lector = csv.reader(fin)
    escritor = csv.writer(fout)
    cab = next(lector)

    i_anio = indice(cab, "anio", RANKING)
    idx = {c: indice(cab, c, RANKING) for c in COLS_RANKING}
    i_ventas = idx["ingresos_ventas"]

    escritor.writerow(
        ["ruc", "nombre", "tipo", "provincia"]
        + COLS_RANKING
        + ["ciiu_n1_desc", "ciiu_n6_desc"]
    )

    for fila in lector:
        leidas += 1
        if leidas % 500_000 == 0:
            print(f"  {leidas:,} filas leidas, {escritas:,} guardadas"
                  .replace(",", "."))

        if len(fila) <= i_ventas or fila[i_anio].strip() != ANIO:
            continue

        ventas = a_numero(fila[i_ventas])
        if ventas < VENTAS_MIN or ventas > VENTAS_MAX:
            continue

        exp = limpiar(fila[idx["expediente"]])
        datos = companias.get(exp)
        if datos is None:
            sin_match += 1
            continue

        ruc, nombre, tipo, provincia = datos
        if PROVINCIAS and provincia not in PROVINCIAS:
            continue

        valores = [limpiar(fila[idx[c]]) for c in COLS_RANKING]
        n1 = limpiar(fila[idx["ciiu_n1"]])
        n6 = limpiar(fila[idx["ciiu_n6"]])

        escritor.writerow(
            [ruc, nombre, tipo, provincia]
            + valores
            + [ciiu_desc.get(n1, ""), ciiu_desc.get(n6, "")]
        )
        escritas += 1

tam = os.path.getsize(SALIDA) / (1024 * 1024)
print("-" * 60)
print(f"Filas leidas          : {leidas:,}".replace(",", "."))
print(f"Filas guardadas       : {escritas:,}".replace(",", "."))
print(f"Sin match en compania : {sin_match:,}".replace(",", "."))
print(f"Archivo               : {SALIDA}  ({tam:.1f} MB)")
if escritas == 0:
    print("ADVERTENCIA: cero filas. Revisa ANIO, PROVINCIAS y la banda de ventas.")
elif escritas < 100:
    print(f"ADVERTENCIA: solo {escritas} empresas en la banda. Segun lo acordado,")
    print("             baja VENTAS_MIN a 1_000_000 y vuelve a correr.")
