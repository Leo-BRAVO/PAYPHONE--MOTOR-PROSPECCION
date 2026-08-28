<#
    preparar.ps1 - Deja lista la carpeta de trabajo y corre el filtro de la SCVS.

    Automatiza: crear Documentos\caudal, verificar y mover los tres CSV desde
    Descargas, copiar filtrar_ranking.py, comprobar Python y ejecutar el filtro.

    Uso (PowerShell, desde la carpeta del repositorio):
        .\preparar.ps1

    No modifica filtrar_ranking.py.
#>

$ErrorActionPreference = 'Stop'

function Paso { param($t) Write-Host "`n== $t" -ForegroundColor Cyan }
function Ok   { param($t) Write-Host "   OK  $t" -ForegroundColor Green }
function Alto { param($t) Write-Host "`nDETENIDO: $t" -ForegroundColor Red; exit 1 }

$ARCHIVOS   = @('bi_compania.csv','bi_ciiu.csv','bi_ranking.csv')
$MIN_MB     = 100          # bi_ranking.csv real ronda los 356 MB
$SCRIPT     = 'filtrar_ranking.py'
$SALIDA     = 'universo_2025.csv'

# ---------------------------------------------------------------- 1. carpetas
Paso 'Ubicando carpetas'

$documentos = [Environment]::GetFolderPath('MyDocuments')
if (-not $documentos) { Alto 'No pude resolver tu carpeta de Documentos.' }
$destino = Join-Path $documentos 'caudal'

$descargas = $null
foreach ($n in @('Downloads','Descargas')) {
    $c = Join-Path $env:USERPROFILE $n
    if (Test-Path $c) { $descargas = $c; break }
}
if (-not $descargas) {
    Alto "No encontre tu carpeta de Descargas en $env:USERPROFILE. Abre el script y fija la ruta a mano."
}
Ok "Descargas: $descargas"
Ok "Destino:   $destino"

# ------------------------------------------- 2. verificar los tres CSV
Paso 'Verificando los tres CSV en Descargas'

$faltan = @()
foreach ($a in $ARCHIVOS) {
    $enDescargas = Join-Path $descargas $a
    $enDestino   = Join-Path $destino   $a
    if (-not (Test-Path $enDescargas) -and -not (Test-Path $enDestino)) { $faltan += $a }
}
if ($faltan.Count -gt 0) {
    Alto "Faltan estos archivos (no estan ni en Descargas ni en el destino): $($faltan -join ', ')"
}

# El tamano se revisa donde este el archivo
$rankingPath = Join-Path $descargas 'bi_ranking.csv'
if (-not (Test-Path $rankingPath)) { $rankingPath = Join-Path $destino 'bi_ranking.csv' }
$rankingMB = [math]::Round((Get-Item $rankingPath).Length / 1MB, 1)

foreach ($a in $ARCHIVOS) {
    $p = Join-Path $descargas $a
    if (-not (Test-Path $p)) { $p = Join-Path $destino $a }
    $mb = [math]::Round((Get-Item $p).Length / 1MB, 2)
    Ok ("{0,-20} {1,10} MB" -f $a, $mb)
}

if ($rankingMB -lt $MIN_MB) {
    Alto @"
bi_ranking.csv pesa solo $rankingMB MB y deberia rondar los 356 MB.
La descarga quedo corrupta o incompleta. Bajalo de nuevo de la SCVS
y vuelve a correr este script. No sigo.
"@
}
Ok "bi_ranking.csv pesa $rankingMB MB - tamano coherente"

# ---------------------------------------------------------------- 3. mover
Paso 'Preparando carpeta de trabajo'

if (-not (Test-Path $destino)) {
    New-Item -ItemType Directory -Path $destino -Force | Out-Null
    Ok "Carpeta creada"
} else {
    Ok "La carpeta ya existia"
}

foreach ($a in $ARCHIVOS) {
    $origen = Join-Path $descargas $a
    if (Test-Path $origen) {
        Move-Item $origen $destino -Force
        Ok "Movido: $a"
    } else {
        Ok "Ya estaba en destino: $a"
    }
}

# --------------------------------------------------- 4. copiar el script
Paso 'Copiando filtrar_ranking.py'

$origenScript = Join-Path $PSScriptRoot $SCRIPT
if (-not (Test-Path $origenScript)) {
    Alto "No encuentro $SCRIPT junto a este script ($PSScriptRoot). Corre preparar.ps1 desde la carpeta del repositorio."
}
Copy-Item $origenScript $destino -Force
Ok "Copiado desde el repositorio"

# ---------------------------------------------------------------- 5. python
Paso 'Verificando Python 3'

$python = $null
foreach ($cmd in @('python','python3','py')) {
    try {
        $v = & $cmd --version 2>&1 | Out-String
        if ($v -match 'Python 3') { $python = $cmd; Ok "$cmd -> $($v.Trim())"; break }
    } catch { }
}
if (-not $python) {
    Alto @"
No hay Python 3 en el PATH.

Instalalo con:      winget install Python.Python.3.12
o descargalo de:    https://www.python.org/downloads/

En el instalador MARCA la casilla "Add python.exe to PATH".
Cierra y reabre PowerShell, y vuelve a correr este script.
"@
}

# ---------------------------------------------------------------- 6. ejecutar
Paso 'Ejecutando el filtro (tarda varios minutos: recorre ~356 MB)'
Write-Host ''

Push-Location $destino
try {
    & $python $SCRIPT
    $codigo = $LASTEXITCODE
} finally {
    Pop-Location
}

if ($codigo -ne 0) {
    Alto "filtrar_ranking.py termino con error (codigo $codigo). Copia el mensaje completo de arriba y pasalo al chat sin modificar el script."
}

# ---------------------------------------------------------------- 7. reporte
$salidaPath = Join-Path $destino $SALIDA
if (-not (Test-Path $salidaPath)) {
    Alto "El script termino pero no encuentro $SALIDA en $destino."
}

$salidaMB   = [math]::Round((Get-Item $salidaPath).Length / 1MB, 2)
$filas      = (Get-Content $salidaPath -ReadCount 0).Count - 1

Paso 'Listo'
Write-Host "   Archivo : $salidaPath"
Write-Host "   Peso    : $salidaMB MB"
Write-Host "   Filas   : $filas (sin contar la cabecera)"
Write-Host ''
Write-Host 'Pega en el chat las tres lineas del resumen (leidas / guardadas / sin match)' -ForegroundColor Yellow
Write-Host 'y arrastra universo_2025.csv. NO lo subas al repositorio.' -ForegroundColor Yellow
