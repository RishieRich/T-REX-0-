$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$uv = Get-Command uv -ErrorAction Stop

Push-Location $repoRoot
try {
    $steps = @(
        @{ Name = "formatting"; Arguments = @("run", "--locked", "ruff", "format", "--check", ".") },
        @{ Name = "lint"; Arguments = @("run", "--locked", "ruff", "check", ".") },
        @{ Name = "type checking"; Arguments = @("run", "--locked", "mypy") },
        @{ Name = "tests"; Arguments = @("run", "--locked", "pytest") }
    )

    foreach ($step in $steps) {
        Write-Host "==> $($step.Name)"
        & $uv.Source @($step.Arguments)
        if ($LASTEXITCODE -ne 0) {
            throw "TREXO verification failed during $($step.Name)."
        }
    }

    Write-Host "TREXO verification PASSED."
}
finally {
    Pop-Location
}
