param([string]$Workspace = 'architecture/workspace.dsl', [ValidateRange(1, 65535)][int]$Port = 8080)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location -LiteralPath $workspaceDirectory
try {
    python -B architecture/scripts/preview.py --workspace $Workspace --port $Port
    if ($LASTEXITCODE -ne 0) { throw 'Architecture preview failed. See the selected workspace reports under build/architecture/.' }
} finally { Pop-Location }
