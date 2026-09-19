# Legacy switches remain accepted; validation always checks authored static C4 DSL.
param([string]$Workspace, [switch]$StaticOnly, [switch]$SkipRender)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location -LiteralPath $workspaceDirectory
try {
    if ($Workspace) {
        python -B architecture/scripts/validate_workspaces.py --workspace $Workspace
    } else {
        python -B architecture/scripts/validate_workspaces.py
    }
    if ($LASTEXITCODE -ne 0) { throw 'C4 validation failed. See workspace reports under build/architecture/.' }
} finally { Pop-Location }
