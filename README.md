# Caudal — Validación de mercado / Prospección LinkedIn

Flujo de trabajo para conseguir 10–15 conversaciones profundas con empresas
ecuatorianas que venden a crédito B2B (deudor con RUC). Alimenta EST-03
(números de valor), COM-02 (pipeline) y COM-07 (cartas de intención).

## Contenido

| Archivo | Qué es |
|---|---|
| `filtrar_ranking.py` | Construye el universo de la Etapa A en una sola pasada: filtra el ejercicio 2025 y la banda de ventas, cruza contra `bi_compania.csv` y `bi_ciiu.csv`, y recorta a 17 columnas. Se corre en la carpeta donde están los tres CSV: `python filtrar_ranking.py` |
| `habilidad/SKILL.md` | La habilidad completa del flujo de prospección (principios, perfil objetivo, 4 pasos, errores a evitar) |
| `habilidad/references/plantillas.md` | Plantillas de mensaje LinkedIn (conexión, seguimiento, recordatorio) — BORRADOR pendiente de aprobación |

## El embudo (estado: en ejecución, ago-2026)

**Etapa A — Filtro masivo (datos SCVS).**
Insumos: `bi_compania.csv` + `bi_ciiu.csv` + `bi_ranking.csv`, los tres
descargados de la fuente y **no versionados aquí** (ver más abajo).
Filtros aplicados por `filtrar_ranking.py`:

- ejercicio 2025
- ventas entre USD 2.000.000 y USD 50.000.000 (la banda ya implica ventas > 0,
  que es el proxy de compañía operativa)
- provincias Pichincha / Guayas / Azuay

**Sin filtro CIIU.** El corte sectorial no se hace en el script: se decide
después, leyendo las descripciones reales de `bi_ciiu.csv` sobre el universo
ya construido. La clasificación CIIU tiene sorpresas — distribuidoras
registradas como industria, importadoras como servicios — y fijar la lista de
códigos a ciegas deja fuera candidatas buenas.

Salida: `universo_2025.csv`, unos cientos de KB. Tras el corte sectorial
manual, la expectativa es 150–300 candidatas.

Si el universo sale con menos de ~100 empresas, bajar `VENTAS_MIN` a 1.000.000
y volver a correr. El script avisa solo cuando ocurre.

**Etapa B — Priorización por dolor.**
Para las 40–60 primeras, consultar cuentas por cobrar clientes en el estado
financiero individual (Portal de Información SCVS, con Claude en Chrome).
Días de cartera = CxC clientes ÷ ventas × 365. Corte: ≥ 45 días.
Aquí también se verifica la situación legal, empresa por empresa.
Bono: genera el comparativo sectorial de días de cobro (EST-03 + incentivo del
mensaje).

**Etapa C — Prospección LinkedIn.**
Según `habilidad/SKILL.md`. 10–15 solicitudes/día, mensaje solo tras
aceptación, cada envío con clic de Leonardo.

## Notas de esquema (verificadas contra los archivos reales)

- `bi_compania.csv` (~51 MB): `expediente`, `ruc`, `nombre`, `tipo`,
  `pro_codigo`, `provincia`. Sin cantón, sin CIIU, sin situación legal.
  El filtro geográfico es por provincia, no por ciudad.
- `bi_ranking.csv` (~356 MB): acumulativo con columna `anio`. **Arranca en 2008**,
  no en 2010. 54 columnas. El CIIU vive aquí (`ciiu_n1`, `ciiu_n6`).
- `bi_ciiu.csv` (~393 KB): `ciiu`, `descripcion`. Es el catálogo que traduce
  los códigos.
- Los tres archivos son coma-separados, UTF-8 sin BOM, saltos de línea LF.
- **Trampa confirmada:** los campos vienen rellenados con espacios a la derecha,
  y de forma inconsistente entre archivos. En `bi_ciiu.csv` la clave es
  `"G              "` (15 caracteres); en `bi_ranking.csv` el mismo código es
  `"G"`. `provincia` en `bi_compania.csv` viene rellenada a 50 caracteres.
  Sin `.strip()` en ambos lados, el cruce de CIIU devuelve vacío en el 100% de
  las filas y cualquier comparación de provincia da falso — sin lanzar error.
- Situación legal no está en estos archivos → proxy: presentó ejercicio 2025
  con ventas > 0. Verificación formal solo para finalistas (Etapa B).

## Por qué los CSV no están en este repositorio

1. `bi_ranking.csv` pesa ~356 MB y **GitHub rechaza archivos de más de 100 MB**.
2. La fuente los regenera cada 24 horas, así que cualquier copia versionada
   nace desactualizada.

Descarga los tres desde la fuente, déjalos en una carpeta local junto al
script, y corre `python filtrar_ranking.py` ahí mismo.

Fuente: https://appscvsmovil.supercias.gob.ec/ranking/reporte.html
(pestaña **Recursos** → cada archivo tiene su enlace *Descarga*)

## Este repositorio es privado y debe seguir siéndolo

Contiene el perfil objetivo, las bandas de facturación, el umbral de días de
cartera y las plantillas de mensaje: es la estrategia comercial de Caudal, no
un conjunto de datos públicos. `universo_2025.csv` tampoco se publica — es la
lista de prospectos ya segmentada. Para mover ese archivo entre sesiones o
personas, se adjunta; pesa cientos de KB.
