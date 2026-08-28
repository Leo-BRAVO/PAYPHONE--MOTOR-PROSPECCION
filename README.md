# Caudal — Validación de mercado / Prospección LinkedIn

Flujo de trabajo para conseguir 10–15 conversaciones profundas con empresas
ecuatorianas que venden a crédito B2B (deudor con RUC). Alimenta EST-03
(números de valor), COM-02 (pipeline) y COM-07 (cartas de intención).

## Contenido

| Archivo | Qué es |
|---|---|
| `filtrar_ranking.py` | Recorta `bi_ranking.csv` (356 MB, todos los ejercicios desde 2010) al ejercicio 2025 para poder procesarlo. Correr en la carpeta donde está el CSV: `python filtrar_ranking.py` |
| `habilidad/SKILL.md` | La habilidad completa del flujo de prospección (principios, perfil objetivo, 4 pasos, errores a evitar) |
| `habilidad/references/plantillas.md` | Plantillas de mensaje LinkedIn (conexión, seguimiento, recordatorio) — BORRADOR pendiente de aprobación |

## El embudo (estado: en ejecución, ago-2026)

**Etapa A — Filtro masivo (datos SCVS):**
insumos `bi_compania.csv` + `bi_ciiu.csv` + `bi_ranking_2025.csv` (filtrado).
Filtros: ejercicio 2025, ventas > 0 (proxy de compañía operativa),
ventas USD 2–50M, CIIU comercio al por mayor objetivo (alimentos,
farmacéutico-médico, construcción/ferretería, agro, maquinaria, tecnología,
autopartes), provincias Pichincha / Guayas / Azuay.
Salida: ~150–300 candidatas.

**Etapa B — Priorización por dolor:**
para las 40–60 primeras, consultar cuentas por cobrar clientes en el
estado financiero individual (Portal de Información SCVS, con Claude en
Chrome). Días de cartera = CxC clientes ÷ ventas × 365. Corte: ≥ 45 días.
Bono: genera el comparativo sectorial de días de cobro (EST-03 + incentivo
del mensaje).

**Etapa C — Prospección LinkedIn:**
según `habilidad/SKILL.md`. 10–15 solicitudes/día, mensaje solo tras
aceptación, cada envío con clic de Leonardo.

## Notas de esquema (verificadas contra los archivos reales)

- `bi_compania.csv`: expediente, ruc, nombre, tipo, pro_codigo, provincia.
  Sin cantón, sin CIIU, sin situación legal.
- `bi_ranking.csv`: acumulativo 2010+ con columna `anio`; el CIIU vive aquí
  (`ciiu_n1`, `ciiu_n6`). Descripciones de códigos en `bi_ciiu.csv`.
- Situación legal no está en estos archivos → proxy: presentó ejercicio
  2025 con ventas > 0. Verificación formal solo para finalistas (Etapa B).
- Los CSV de origen NO se versionan en este repo (356 MB, se actualizan
  cada 24 h en la fuente). Fuente:
  https://appscvsmovil.supercias.gob.ec/ranking/reporte.html
