param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(1,10)]
    [int]$PaperNumber,
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "1.0",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$SANDBOX_PREFIX = "[SANDBOX-TEST]"

$paperDirs = @{
    "1" = "structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2"
    "2" = "structures/paper/architecture/architecture_three_layer-20260511_130002-b7d2e1"
    "3" = "structures/paper/architecture/architecture_lsh_format-20260511_130003-h9j8k7"
    "4" = "structures/paper/theory/theory_attention_comparison-20260511_120002-d5f4g3"
    "5" = "structures/paper/theory/theory_tokenizer_free-20260511_120003-e6g5h4"
    "6" = "structures/paper/applications/applications_autoregressive-20260511_150001-i10k9l8"
    "7" = "structures/paper/foundational/foundational_spacetime_cognition-20260511_160001-j11k10m9"
    "8" = "structures/paper/systems/systems_lsh_burn-20260511_140003-l13m14n15"
    "9" = "structures/paper/applications/applications_lsh_rules-20260511_150002-m13n14o15"
    "10" = "structures/paper/systems/systems_version_control-20260511_140004-p4q5r6"
}

$paperTitles = @{
    "1" = "LSH-SFA: Spacetime Field Attention"
    "2" = "Three-Layer Semantic Architecture"
    "3" = "LSH Format: AI-Native Data Format"
    "4" = "Beyond Softmax: Attention Comparison"
    "5" = "Encoding and Gradient in PINNs"
    "6" = "Autoregressive Generation"
    "7" = "Spacetime Cognition Deficit"
    "8" = "LSH-Burn: Rust Implementation"
    "9" = "LSH Rules: Self-Verifying System"
    "10" = "Ternary Semantic Versioning"
}

$paperDir = $paperDirs[$PaperNumber.ToString()]
$paperTitle = $paperTitles[$PaperNumber.ToString()]
$tag = "v${Version}-paper${PaperNumber}-sandbox"

Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  ZENODO Sandbox Test" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "  WARNING: Sandbox test only, not production"
Write-Host "  Tag will include -sandbox suffix"
Write-Host ""
Write-Host "  Title: $paperTitle"
Write-Host "  Version: $Version"
Write-Host "  Tag: $tag"
Write-Host "  Directory: $paperDir"
Write-Host ""

if (-not $env:ZENODO_SANDBOX_TOKEN) {
    Write-Host "[ERROR] ZENODO_SANDBOX_TOKEN not set" -ForegroundColor Red
    Write-Host ""
    Write-Host "Set token first:"
    Write-Host '  $env:ZENODO_SANDBOX_TOKEN = "your-token"'
    Write-Host ""
    exit 1
}

if ($DryRun) {
    Write-Host "[DRY RUN] Commands to execute:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Copy-Item $paperDir/.zenodo.json .zenodo.json"
    Write-Host "  2. Add [SANDBOX-TEST] prefix to title"
    Write-Host "  3. python scripts/create_zenodo_deposition.py --sandbox ..."
    Write-Host ""
    Write-Host "[DRY RUN] Done, no changes made" -ForegroundColor Yellow
    return
}

Write-Host "Step 1: Copy .zenodo.json..." -ForegroundColor Yellow
Copy-Item "$paperDir/.zenodo.json" ".zenodo.json" -Force

$jsonContent = Get-Content ".zenodo.json" -Raw -Encoding UTF8
$json = $jsonContent | ConvertFrom-Json
$json.title = "$SANDBOX_PREFIX $($json.title)"
$json | ConvertTo-Json -Depth 10 | Out-File ".zenodo.json" -Encoding utf8
Write-Host "  [OK] Sandbox prefix added" -ForegroundColor Green

Write-Host "Step 2: Create sandbox deposition..." -ForegroundColor Yellow
python scripts/create_zenodo_deposition.py --sandbox --metadata .zenodo.json --paper-dir $paperDir

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to create deposition" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Sandbox test completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Visit sandbox.zenodo.org to check results"
Write-Host ""
Write-Host "After test passes, use production script:"
$prodCmd = ".\scripts\release-paper-production.ps1 -PaperNumber $PaperNumber -Version $Version -Confirm"
Write-Host "  $prodCmd"
Write-Host ""
