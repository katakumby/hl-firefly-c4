# Legacy switches remain accepted; validation always checks authored static C4 DSL.
param([string]$Workspace, [switch]$StaticOnly, [switch]$SkipRender, [ValidateRange(1, 16)][int]$Jobs = 2)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location -LiteralPath $workspaceDirectory
try {
    if ($Workspace) {
        python -B architecture/scripts/validate_workspaces.py --workspace $Workspace --jobs $Jobs
    } else {
        python -B architecture/scripts/validate_workspaces.py --jobs $Jobs
    }
    if ($LASTEXITCODE -ne 0) { throw 'C4 validation failed. See workspace reports under build/architecture/.' }
} finally { Pop-Location }
