param(
    [Parameter(Mandatory=$true)]
    [string]$Token,
    
    [Parameter(Mandatory=$false)]
    [int]$StartPaper = 1,
    
    [Parameter(Mandatory=$false)]
    [int]$EndPaper = 10
)

$ErrorActionPreference = "Stop"

$env:ZENODO_SANDBOX_TOKEN = $Token

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Zenodo Sandbox Batch Test" -ForegroundColor Cyan
Write-Host "  Papers: $StartPaper to $EndPaper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$results = @()

for ($i = $StartPaper; $i -le $EndPaper; $i++) {
    Write-Host "[$i/10] Testing Paper $i..." -ForegroundColor Yellow
    
    $prepareResult = python scripts/prepare_zenodo_release.py --paper $i --sandbox 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [FAIL] Prepare metadata failed" -ForegroundColor Red
        $results += @{Paper=$i; Status="FAIL"; Error="Prepare failed"}
        continue
    }
    
    Write-Host "  [OK] Metadata prepared" -ForegroundColor Green
    
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
    
    $paperDir = $paperDirs[$i.ToString()]
    
    $uploadResult = python scripts/create_zenodo_deposition.py --sandbox --metadata .zenodo.json --paper-dir $paperDir 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [FAIL] Create deposition failed" -ForegroundColor Red
        $results += @{Paper=$i; Status="FAIL"; Error="Deposition failed"}
        continue
    }
    
    Write-Host "  [OK] Deposition created" -ForegroundColor Green
    $results += @{Paper=$i; Status="PASS"; Error=""}
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$passCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($results | Where-Object { $_.Status -eq "FAIL" }).Count

Write-Host "  PASS: $passCount" -ForegroundColor Green
Write-Host "  FAIL: $failCount" -ForegroundColor Red
Write-Host ""

foreach ($result in $results) {
    $color = if ($result.Status -eq "PASS") { "Green" } else { "Red" }
    Write-Host "  Paper $($result.Paper): $($result.Status)" -ForegroundColor $color
    if ($result.Error) {
        Write-Host "    Error: $($result.Error)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Test completed!" -ForegroundColor Cyan
