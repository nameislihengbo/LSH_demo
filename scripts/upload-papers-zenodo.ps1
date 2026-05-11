param(
    [Parameter(Mandatory=$false)]
    [switch]$Sandbox,

    [Parameter(Mandatory=$false)]
    [switch]$Publish,

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

$baseUrl = if ($Sandbox) { "https://sandbox.zenodo.org" } else { "https://zenodo.org" }
$tokenEnv = if ($Sandbox) { "ZENODO_SANDBOX_TOKEN" } else { "ZENODO_TOKEN" }
$token = [Environment]::GetEnvironmentVariable($tokenEnv)

Write-Host "========================================" -ForegroundColor $(if ($Sandbox) { "Yellow" } else { "Red" })
Write-Host "  ZENODO API UPLOAD" -ForegroundColor $(if ($Sandbox) { "Yellow" } else { "Red" })
Write-Host "========================================" -ForegroundColor $(if ($Sandbox) { "Yellow" } else { "Red" })
Write-Host ""
Write-Host "  Environment: $(if ($Sandbox) { 'SANDBOX' } else { 'PRODUCTION' })"
Write-Host "  Papers: $StartPaper to $EndPaper"
Write-Host "  Auto-publish: $Publish"
Write-Host ""

if (-not $token) {
    Write-Host "[ERROR] $tokenEnv not set" -ForegroundColor Red
    Write-Host ""
    Write-Host "Set token first:"
    Write-Host "  `$env:$tokenEnv = 'your-token'"
    Write-Host ""
    Write-Host "Get token from: $(if ($Sandbox) { 'https://sandbox.zenodo.org/account/settings/applications/' } else { 'https://zenodo.org/account/settings/applications/' })"
    exit 1
}

$results = @()

for ($i = $StartPaper - 1; $i -lt $EndPaper; $i++) {
    $config = $paperConfigs[$i]
    $paperNum = $config.Number
    $paperDir = $paperDirs[$paperNum.ToString()]
    $metadataPath = Join-Path $paperDir ".zenodo.json"
    $mainTexPath = Join-Path $paperDir "main.tex"

    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Paper $paperNum / $EndPaper" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Title: $($config.Title.Substring(0, [Math]::Min(60, $config.Title.Length)))..."
    Write-Host "  Version: v$($config.Version)"
    Write-Host ""

    if (-not (Test-Path $metadataPath)) {
        Write-Host "[ERROR] Metadata not found: $metadataPath" -ForegroundColor Red
        $results += @{Paper=$paperNum; Status="ERROR"; Message="Metadata not found"}
        continue
    }

    if (-not (Test-Path $mainTexPath)) {
        Write-Host "[ERROR] Paper file not found: $mainTexPath" -ForegroundColor Red
        $results += @{Paper=$paperNum; Status="ERROR"; Message="Paper file not found"}
        continue
    }

    Write-Host "[1/3] Creating deposition..." -ForegroundColor Yellow

    $metadata = Get-Content $metadataPath -Raw -Encoding UTF8 | ConvertFrom-Json

    $depositionData = @{
        metadata = @{
            title = $metadata.title
            upload_type = $metadata.upload_type
            publication_type = $metadata.publication_type
            description = $metadata.description
            creators = $metadata.creators
            keywords = $metadata.keywords
            license = $metadata.license
            access_right = $metadata.access_right
            version = "v$($config.Version)"
        }
    }

    $headers = @{
        "Content-Type" = "application/json"
    }

    try {
        $uri = "$baseUrl/api/deposit/depositions?access_token=$token"
        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body ($depositionData | ConvertTo-Json -Depth 10)

        $depositionId = $response.id
        Write-Host "[OK] Deposition created: $depositionId" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to create deposition: $_" -ForegroundColor Red
        $results += @{Paper=$paperNum; Status="ERROR"; Message=$_.Exception.Message}
        continue
    }

    Write-Host "[2/3] Uploading file..." -ForegroundColor Yellow

    try {
        $filePath = Resolve-Path $mainTexPath
        $uploadUrl = "$baseUrl/api/deposit/depositions/$depositionId/files?access_token=$token"
        
        $curlResult = curl.exe -s -X POST -F "file=@$filePath" $uploadUrl 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] File uploaded: main.tex" -ForegroundColor Green
        } else {
            Write-Host "[ERROR] curl failed: $curlResult" -ForegroundColor Red
            $results += @{Paper=$paperNum; Status="ERROR"; Message="Upload failed: $curlResult"}
            continue
        }
    }
    catch {
        Write-Host "[ERROR] Failed to upload file: $_" -ForegroundColor Red
        $results += @{Paper=$paperNum; Status="ERROR"; Message="Upload failed: $($_.Exception.Message)"}
        continue
    }

    if ($Publish) {
        Write-Host "[3/3] Publishing..." -ForegroundColor Yellow

        try {
            $publishResponse = Invoke-RestMethod -Uri "$baseUrl/api/deposit/depositions/$depositionId/actions/publish?access_token=$token" -Method Post

            $doi = $publishResponse.doi
            Write-Host "[OK] Published!" -ForegroundColor Green
            Write-Host "  DOI: $doi" -ForegroundColor Green

            $results += @{
                Paper = $paperNum
                Status = "PUBLISHED"
                DepositionId = $depositionId
                DOI = $doi
            }
        }
        catch {
            Write-Host "[ERROR] Failed to publish: $_" -ForegroundColor Red
            $results += @{
                Paper = $paperNum
                Status = "DRAFT"
                DepositionId = $depositionId
                Message = "Publish failed: $($_.Exception.Message)"
            }
        }
    }
    else {
        Write-Host "[3/3] Keeping as draft" -ForegroundColor Yellow
        Write-Host "[OK] Draft created: $baseUrl/deposit/$depositionId" -ForegroundColor Green

        $results += @{
            Paper = $paperNum
            Status = "DRAFT"
            DepositionId = $depositionId
            Url = "$baseUrl/deposit/$depositionId"
        }
    }

    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "  SUMMARY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

foreach ($result in $results) {
    $statusColor = if ($result.Status -eq "PUBLISHED") { "Green" } elseif ($result.Status -eq "DRAFT") { "Yellow" } else { "Red" }
    Write-Host "Paper $($result.Paper): $($result.Status)" -ForegroundColor $statusColor

    if ($result.DOI) {
        Write-Host "  DOI: $($result.DOI)" -ForegroundColor Green
    }
    if ($result.Url) {
        Write-Host "  URL: $($result.Url)" -ForegroundColor Yellow
    }
    if ($result.Message) {
        Write-Host "  Error: $($result.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
