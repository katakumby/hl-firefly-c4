param([switch]$SkipRender, [switch]$StaticOnly)
$ErrorActionPreference = 'Stop'
$workspaceDirectory = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $workspaceDirectory
try {
    if ($StaticOnly) {
        python -B scripts/validate_static.py
        if ($LASTEXITCODE -ne 0) { throw 'Static C4 validation failed. See reports/static/validation-summary.md.' }
        return
    }
    New-Item -ItemType Directory -Force -Path reports,exports | Out-Null
    python scripts/build_workspace.py
    if ($LASTEXITCODE -ne 0) { throw 'Workspace generation failed.' }
    python scripts/source_inventory.py
    if ($LASTEXITCODE -ne 0) { throw 'Source coverage failed.' }
    docker compose run --rm cli validate -workspace workspace.dsl 2>&1 | Tee-Object -FilePath reports/validate.txt
    if ($LASTEXITCODE -ne 0) { throw 'DSL validation failed.' }
    docker compose run --rm cli inspect -workspace workspace.dsl 2>&1 | Tee-Object -FilePath reports/inspect-dsl.txt
    $dslInspectExitCode = $LASTEXITCODE
    python -B scripts/check_inspect.py reports/inspect-dsl.txt $dslInspectExitCode
    if ($LASTEXITCODE -ne 0) { throw 'Unexpected DSL inspection findings.' }
    docker compose run --rm cli export -workspace workspace.dsl -format json -output exports 2>&1 | Tee-Object -FilePath reports/export-json.txt
    if ($LASTEXITCODE -ne 0) { throw 'JSON export failed.' }
    python scripts/layout_workspace.py
    if ($LASTEXITCODE -ne 0) { throw 'Deployment layout failed.' }
    docker compose run --rm cli validate -workspace exports/workspace.json 2>&1 | Tee-Object -FilePath reports/validate-json.txt
    if ($LASTEXITCODE -ne 0) { throw 'JSON validation failed.' }
    docker compose run --rm cli inspect -workspace exports/workspace.json 2>&1 | Tee-Object -FilePath reports/inspect.txt
    $inspectExitCode = $LASTEXITCODE
    python -B scripts/check_inspect.py reports/inspect.txt $inspectExitCode
    if ($LASTEXITCODE -ne 0) { throw 'Unexpected full inspection result.' }
    docker compose run --rm cli inspect -workspace exports/workspace.json -severity error,warning 2>&1 | Tee-Object -FilePath reports/inspect-errors-warnings.txt
    if ($LASTEXITCODE -ne 0) { throw 'Actionable inspection findings remain.' }
    python scripts/audit_workspace.py
    if ($LASTEXITCODE -ne 0) { throw 'Architecture audit failed.' }
    if (-not $SkipRender) {
        docker compose run --rm export 2>&1 | Tee-Object -FilePath reports/export-svg.txt
        if ($LASTEXITCODE -ne 0) { throw 'SVG export failed.' }
        python scripts/audit_workspace.py --svg
        if ($LASTEXITCODE -ne 0) { throw 'Rendered artifact audit failed.' }
        python scripts/visual_audit.py
        if ($LASTEXITCODE -ne 0) { throw 'Rendered geometry findings remain.' }
    }
    python scripts/gallery.py
    if ($LASTEXITCODE -ne 0) { throw 'Gallery generation failed.' }
    docker image inspect structurizr/structurizr:2026.06.28-noble structurizr/structurizr:2026.06.28-playwright |
        Set-Content -LiteralPath reports/docker-images.json -Encoding utf8
    if (-not $SkipRender) {
        python scripts/validation_summary.py
        if ($LASTEXITCODE -ne 0) { throw 'Validation summary failed.' }
    }
    Write-Output 'PASS: validation, actionable inspections and architecture checks. Documented scope INFO findings retained.'
} finally { Pop-Location }

