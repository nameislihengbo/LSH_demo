param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(1,10)]
    [int]$PaperNumber,
    
    [Parameter(Mandatory=$false)]
    [string]$Version = "1.0",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [switch]$Confirm,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipChecks
)

$ErrorActionPreference = "Stop"

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
$tag = "v${Version}-paper${PaperNumber}"

Write-Host "========================================" -ForegroundColor Red
Write-Host "  PRODUCTION RELEASE TO ZENODO" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""
Write-Host "  WARNING: This will publish to production"
Write-Host "  WARNING: A permanent DOI will be generated"
Write-Host "  WARNING: Please ensure sandbox test passed"
Write-Host ""
Write-Host "  Title: $paperTitle"
Write-Host "  Version: $Version"
Write-Host "  Tag: $tag"
Write-Host "  Directory: $paperDir"
Write-Host ""

if (-not $Confirm) {
    Write-Host "[ERROR] Please use -Confirm parameter to confirm production release" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Example:"
    Write-Host "  .\scripts\release-paper-production.ps1 -PaperNumber $PaperNumber -Version $Version -Confirm"
    Write-Host ""
    Write-Host "Run sandbox test first:"
    Write-Host "  .\scripts\release-paper-sandbox.ps1 -PaperNumber $PaperNumber -Version $Version"
    Write-Host ""
    exit 1
}

$checksPassed = $true

if (-not $SkipChecks) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  PRE-RELEASE CHECKS" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[Check 1] Git working directory clean..." -ForegroundColor Yellow
    $gitStatus = git status --porcelain 2>$null
    if ($gitStatus) {
        Write-Host "  [FAIL] Working directory has uncommitted changes:" -ForegroundColor Red
        Write-Host $gitStatus
        $checksPassed = $false
    } else {
        Write-Host "  [PASS] Working directory is clean" -ForegroundColor Green
    }

    Write-Host "[Check 2] Current branch is main..." -ForegroundColor Yellow
    $currentBranch = git branch --show-current 2>$null
    if ($currentBranch -ne "main") {
        Write-Host "  [FAIL] Current branch is '$currentBranch', expected 'main'" -ForegroundColor Red
        $checksPassed = $false
    } else {
        Write-Host "  [PASS] Current branch is 'main'" -ForegroundColor Green
    }

    Write-Host "[Check 3] Remote repository configured..." -ForegroundColor Yellow
    $remoteUrl = git remote get-url origin 2>$null
    if (-not $remoteUrl) {
        Write-Host "  [FAIL] No remote 'origin' configured" -ForegroundColor Red
        $checksPassed = $false
    } else {
        Write-Host "  [PASS] Remote: $remoteUrl" -ForegroundColor Green
    }

    Write-Host "[Check 4] Paper .zenodo.json exists..." -ForegroundColor Yellow
    $zenodoJson = Join-Path $paperDir ".zenodo.json"
    if (-not (Test-Path $zenodoJson)) {
        Write-Host "  [FAIL] File not found: $zenodoJson" -ForegroundColor Red
        $checksPassed = $false
    } else {
        Write-Host "  [PASS] File exists: $zenodoJson" -ForegroundColor Green
    }

    Write-Host "[Check 5] Paper main.tex exists..." -ForegroundColor Yellow
    $mainTex = Join-Path $paperDir "main.tex"
    if (-not (Test-Path $mainTex)) {
        Write-Host "  [FAIL] File not found: $mainTex" -ForegroundColor Red
        $checksPassed = $false
    } else {
        Write-Host "  [PASS] File exists: $mainTex" -ForegroundColor Green
    }

    Write-Host "[Check 6] Tag does not already exist..." -ForegroundColor Yellow
    $existingTag = git tag -l $tag 2>$null
    if ($existingTag) {
        Write-Host "  [FAIL] Tag '$tag' already exists" -ForegroundColor Red
        $checksPassed = $false
    } else {
        Write-Host "  [PASS] Tag '$tag' is available" -ForegroundColor Green
    }

    Write-Host "[Check 7] .zenodo.json is valid JSON..." -ForegroundColor Yellow
    try {
        $jsonContent = Get-Content $zenodoJson -Raw -Encoding UTF8
        $json = $jsonContent | ConvertFrom-Json
        if (-not $json.title) {
            Write-Host "  [FAIL] Missing 'title' field in .zenodo.json" -ForegroundColor Red
            $checksPassed = $false
        } elseif (-not $json.creators) {
            Write-Host "  [FAIL] Missing 'creators' field in .zenodo.json" -ForegroundColor Red
            $checksPassed = $false
        } else {
            Write-Host "  [PASS] JSON is valid with required fields" -ForegroundColor Green
        }
    } catch {
        Write-Host "  [FAIL] Invalid JSON: $($_.Exception.Message)" -ForegroundColor Red
        $checksPassed = $false
    }

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    if ($checksPassed) {
        Write-Host "  ALL CHECKS PASSED" -ForegroundColor Green
    } else {
        Write-Host "  SOME CHECKS FAILED" -ForegroundColor Red
    }
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    if (-not $checksPassed) {
        Write-Host "[ERROR] Please fix the issues above before releasing" -ForegroundColor Red
        Write-Host ""
        Write-Host "To skip checks (not recommended):"
        Write-Host "  .\scripts\release-paper-production.ps1 -PaperNumber $PaperNumber -Version $Version -Confirm -SkipChecks"
        Write-Host ""
        exit 1
    }
}

if ($DryRun) {
    Write-Host "[DRY RUN] Commands to execute:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Copy-Item $paperDir/.zenodo.json .zenodo.json"
    Write-Host "  2. git add .zenodo.json"
    Write-Host "  3. git commit -m 'chore: prepare release $tag'"
    Write-Host "  4. git tag $tag"
    Write-Host "  5. git push origin main"
    Write-Host "  6. git push origin $tag"
    Write-Host "  7. Create GitHub Release at https://github.com/hengbo-li/lsh-workspace/releases/new"
    Write-Host ""
    Write-Host "[DRY RUN] Done, no changes made" -ForegroundColor Yellow
    return
}

Write-Host "Step 1: Copy .zenodo.json..." -ForegroundColor Yellow
Copy-Item "$paperDir/.zenodo.json" ".zenodo.json" -Force
Write-Host "  [OK]" -ForegroundColor Green

Write-Host "Step 2: Git add..." -ForegroundColor Yellow
git add .zenodo.json
Write-Host "  [OK]" -ForegroundColor Green

Write-Host "Step 3: Git commit..." -ForegroundColor Yellow
git commit -m "chore: prepare release $tag"
Write-Host "  [OK]" -ForegroundColor Green

Write-Host "Step 4: Create tag..." -ForegroundColor Yellow
git tag $tag
Write-Host "  [OK]" -ForegroundColor Green

Write-Host "Step 5: Push to remote..." -ForegroundColor Yellow
git push origin main
git push origin $tag
Write-Host "  [OK]" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  RELEASE PREPARED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEP: Create GitHub Release"
Write-Host "  https://github.com/hengbo-li/lsh-workspace/releases/new"
Write-Host ""
Write-Host "Select tag: $tag"
Write-Host "Title: Paper $PaperNumber - $paperTitle v$Version"
Write-Host ""
Write-Host "Zenodo will automatically sync and generate DOI"
Write-Host ""
Write-Host "IMPORTANT REMINDERS:"
Write-Host "  1. Ensure Zenodo-GitHub integration is enabled:"
Write-Host "     https://zenodo.org/account/settings/github/"
Write-Host "  2. After creating GitHub Release, wait a few minutes"
Write-Host "  3. Check https://zenodo.org for the published record"
Write-Host ""
