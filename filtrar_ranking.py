import csv

ENTRADA = "bi_ranking.csv"
SALIDA = "bi_ranking_2025.csv"

with open(ENTRADA, "r", encoding="utf-8", errors="replace", newline="") as fin, \
     open(SALIDA, "w", encoding="utf-8", newline="") as fout:
    lector = csv.reader(fin)
    escritor = csv.writer(fout)
    cabecera = next(lector)
    escritor.writerow(cabecera)
    # localizar la columna del año sin asumir posición
    idx_anio = [i for i, c in enumerate(cabecera) if c.strip().lower() == "anio"][0]
    filas = 0
    for fila in lector:
        if len(fila) > idx_anio and fila[idx_anio].strip() == "2025":
            escritor.writerow(fila)
            filas += 1
    print(f"Listo: {filas} filas del ejercicio 2025 en {SALIDA}")
