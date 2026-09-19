param([ValidateSet('Preview', 'Export', 'Validate', 'Down', 'Config')][string]$Action = 'Preview',
      [string]$Workspace = 'architecture/workspace.dsl', [ValidateRange(1, 65535)][int]$Port = 8080, [string]$View)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location -LiteralPath $workspaceDirectory
try {
    $arguments = @('-B', 'architecture/scripts/compose.py', $Action, '--workspace', $Workspace, '--port', $Port)
    if ($View) { $arguments += @('--view', $View) }
    & python @arguments
    if ($LASTEXITCODE -ne 0) { throw 'Architecture Compose operation failed.' }
} finally { Pop-Location }
