param(
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [switch]$Confirm,
    
    [Parameter(Mandatory=$false)]
    [int]$StartPaper = 1,
    
    [Parameter(Mandatory=$false)]
    [int]$EndPaper = 10
)

$ErrorActionPreference = "Stop"

$paperConfigs = @(
    @{Number=1; Version="1.0.0"; Title="LSH-SFA: Spacetime Field Attention with Wave Packets, Light-Cone Causality, and PDE-Driven Evolution"},
    @{Number=2; Version="1.0.0"; Title="LSH: Element-Observers Semantic Architecture with Emergent Execution"},
    @{Number=3; Version="1.0.0"; Title="LSH Format: AI-Native Data Format with Rust/Burn Engineering Validation"},
    @{Number=4; Version="1.0.0"; Title="Beyond Softmax: A Systematic Comparison of Eight Linear Attention Mechanisms"},
    @{Number=5; Version="1.0.0"; Title="Encoding and Gradient in Physics-Informed Networks: Tokenizer-Free Models and Controllable Explosion Optimization"},
    @{Number=6; Version="1.0.0"; Title="LSH-SFA for Autoregressive Generation: Causal Mode and Conversation Ability"},
    @{Number=7; Version="1.0.0"; Title="The Spacetime Cognition Deficit: Why Architecture Matters for General Embodied Intelligence"},
    @{Number=8; Version="1.0.0"; Title="LSH-Burn: Rust-based Spacetime Field Architecture Implementation"},
    @{Number=9; Version="1.0.0"; Title="LSH Rules: Self-Verifying Semantic System for Super Rule Enhancement and Prompt Engineering"},
    @{Number=10; Version="1.0.0"; Title="LSH Version Control: Ternary Semantic Versioning Based on Three-Layer Architecture"}
)

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

Write-Host "========================================" -ForegroundColor Red
Write-Host "  BATCH PRODUCTION RELEASE" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""
Write-Host "  WARNING: This will publish Papers $StartPaper to $EndPaper to production"
Write-Host "  WARNING: Permanent DOIs will be generated"
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] Papers to release:" -ForegroundColor Yellow
    for ($i = $StartPaper - 1; $i -lt $EndPaper; $i++) {
        $config = $paperConfigs[$i]
        $tag = "v$($config.Version)-paper$($config.Number)"
        Write-Host "  Paper $($config.Number): $tag - $($config.Title.Substring(0, [Math]::Min(50, $config.Title.Length)))..."
    }
    Write-Host ""
    Write-Host "[DRY RUN] Done, no changes made" -ForegroundColor Yellow
    return
}

if (-not $Confirm) {
    Write-Host "[ERROR] Please use -Confirm parameter" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Example:"
    Write-Host "  .\scripts\release-all-papers.ps1 -Confirm"
    Write-Host "  .\scripts\release-all-papers.ps1 -Confirm -StartPaper 1 -EndPaper 3"
    Write-Host ""
    exit 1
}

$gitStatus = git status --porcelain 2>$null
if ($gitStatus) {
    Write-Host "[ERROR] Working directory has uncommitted changes" -ForegroundColor Red
    Write-Host $gitStatus
    exit 1
}

$currentBranch = git branch --show-current 2>$null
if ($currentBranch -ne "main") {
    Write-Host "[ERROR] Current branch is '$currentBranch', expected 'main'" -ForegroundColor Red
    exit 1
}

$ghAuth = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] GitHub CLI not authenticated. Run: gh auth login" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Pre-flight checks passed" -ForegroundColor Green
Write-Host ""

$successCount = 0
$failCount = 0
$results = @()

for ($i = $StartPaper - 1; $i -lt $EndPaper; $i++) {
    $config = $paperConfigs[$i]
    $paperNum = $config.Number
    $version = $config.Version
    $title = $config.Title
    $tag = "v${version}-paper${paperNum}"
    $paperDir = $paperDirs[$paperNum.ToString()]
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Paper $paperNum / $EndPaper" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Tag: $tag"
    Write-Host "  Title: $($title.Substring(0, [Math]::Min(60, $title.Length)))..."
    Write-Host ""
    
    $existingTag = git tag -l $tag 2>$null
    if ($existingTag) {
        Write-Host "  [SKIP] Tag already exists: $tag" -ForegroundColor Yellow
        $results += @{Paper=$paperNum; Tag=$tag; Status="SKIPPED"; Error="Tag exists"}
        continue
    }
    
    try {
        Write-Host "  Step 1: Copy .zenodo.json..." -ForegroundColor Yellow
        Copy-Item "$paperDir/.zenodo.json" ".zenodo.json" -Force
        
        Write-Host "  Step 2: Git commit..." -ForegroundColor Yellow
        git add .zenodo.json
        git commit -m "chore: prepare release $tag"
        
        Write-Host "  Step 3: Create tag..." -ForegroundColor Yellow
        git tag $tag
        
        Write-Host "  Step 4: Push to remote..." -ForegroundColor Yellow
        git push origin main
        git push origin $tag
        
        Write-Host "  Step 5: Create GitHub Release..." -ForegroundColor Yellow
        $releaseTitle = "Paper $paperNum - $($title.Substring(0, [Math]::Min(50, $title.Length)))..."
        $releaseNotes = "## $title`n`nVersion: $version`n`nFiles:`n- main.tex`n- .zenodo.json"
        
        gh release create $tag --title "$releaseTitle" --notes "$releaseNotes" --repo nameislihengbo/LSH_demo
        
        Write-Host "  [SUCCESS] Paper $paperNum released!" -ForegroundColor Green
        $results += @{Paper=$paperNum; Tag=$tag; Status="SUCCESS"; Error=""}
        $successCount++
    }
    catch {
        Write-Host "  [FAILED] $($_.Exception.Message)" -ForegroundColor Red
        $results += @{Paper=$paperNum; Tag=$tag; Status="FAILED"; Error=$_.Exception.Message}
        $failCount++
    }
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "  BATCH RELEASE SUMMARY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Success: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host "  Skipped: $(10 - $successCount - $failCount)" -ForegroundColor Yellow
Write-Host ""

foreach ($result in $results) {
    $color = switch ($result.Status) {
        "SUCCESS" { "Green" }
        "FAILED" { "Red" }
        "SKIPPED" { "Yellow" }
    }
    Write-Host "  Paper $($result.Paper): $($result.Status)" -ForegroundColor $color
    if ($result.Error) {
        Write-Host "    Error: $($result.Error)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Check Zenodo for DOIs: https://zenodo.org" -ForegroundColor Cyan
Write-Host ""
