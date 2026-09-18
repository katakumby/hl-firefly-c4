# StaticOnly and SkipRender remain accepted for existing callers; the single
# canonical workspace is always static and this entrypoint never renders.
param([switch]$StaticOnly, [switch]$SkipRender)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $workspaceDirectory
try {
    python -B scripts/validate_static.py
    if ($LASTEXITCODE -ne 0) { throw 'C4 validation failed. See reports/static/validation-summary.md.' }
} finally { Pop-Location }
