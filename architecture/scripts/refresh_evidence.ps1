param([ValidateSet('All', 'Static', 'Components', 'Besu', 'Security')][string]$Scope = 'All', [string[]]$Only)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location -LiteralPath $workspaceDirectory
try {
    $arguments = @('-B', 'architecture/scripts/refresh_evidence.py', '--scope', $Scope)
    if ($Only) { $arguments += @('--only') + $Only }
    & python @arguments
    if ($LASTEXITCODE -ne 0) { throw 'Evidence refresh failed; the previous inventory remains published unless it was changed by another process.' }
} finally { Pop-Location }
