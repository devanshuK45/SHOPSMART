<#
PowerShell helper to initialize git (if needed), add origin remote, and push to GitHub.
Usage examples:

# Basic (uses README suggested repo)
.\push_to_github.ps1 -RemoteUrl 'https://github.com/devanshuK45/SHOPSMART.git' -Branch 'main'

# Force replace existing origin remote
.\push_to_github.ps1 -RemoteUrl 'git@github.com:devanshuK45/SHOPSMART.git' -Branch 'main' -ForceRemote -UseSsh

Notes:
- For HTTPS pushes you'll be prompted for GitHub credentials or a Personal Access Token (PAT).
- For SSH, ensure your SSH keys are set up and added to your GitHub account.
- Run in the project folder (where index.html and README.md live).
#>

param(
    [string]$RemoteUrl = 'https://github.com/devanshuK45/SHOPSMART.git',
    [string]$Branch = 'main',
    [switch]$ForceRemote,
    [switch]$UseSsh
)

function Assert-GitAvailable {
    try {
        git --version > $null 2>&1
        return $true
    } catch {
        Write-Error "Git does not seem to be installed or not in PATH. Install Git first: https://git-scm.com/downloads"
        exit 1
    }
}

function Run($cmd) {
    Write-Host "> $cmd" -ForegroundColor Cyan
    $r = & cmd /c $cmd
    if ($LASTEXITCODE -ne 0) { Write-Host "(exit $LASTEXITCODE)" -ForegroundColor Yellow }
    return $LASTEXITCODE
}

Assert-GitAvailable

# Ensure we're in the desired folder
Write-Host "Working directory: $(Get-Location)" -ForegroundColor Green

# Init repo if needed
$inside = 0
try { git rev-parse --is-inside-work-tree > $null 2>&1; $inside = $LASTEXITCODE } catch { $inside = 1 }
if ($inside -ne 0) {
    Write-Host "No git repository found — initializing..." -ForegroundColor Green
    Run 'git init'
} else {
    Write-Host "Git repository detected." -ForegroundColor Green
}

# Stage files
Run 'git add .'

# Create initial commit if none exists
$hasHead = 0
try { git rev-parse --verify HEAD > $null 2>&1; $hasHead = $LASTEXITCODE } catch { $hasHead = 1 }
if ($hasHead -ne 0) {
    Write-Host "No commits found. Creating initial commit..." -ForegroundColor Green
    Run 'git commit -m "Initial commit: add ShopSmart UX playground"'
} else {
    Write-Host "Repository already has commits. Creating a new commit for recent changes..." -ForegroundColor Green
    Run 'git commit -m "Update ShopSmart UX playground" --allow-empty'
}

# Ensure branch name
Run "git branch -M $Branch"

# Manage remote
$remoteExists = 0
try { git remote get-url origin > $null 2>&1; $remoteExists = $LASTEXITCODE } catch { $remoteExists = 1 }
if ($remoteExists -eq 0) {
    $cur = git remote get-url origin
    Write-Host "Origin already exists: $cur" -ForegroundColor Yellow
    if ($ForceRemote) {
        Write-Host "Force flag set — replacing origin with $RemoteUrl" -ForegroundColor Yellow
        Run 'git remote remove origin'
        Run "git remote add origin $RemoteUrl"
    } else {
        $ans = Read-Host "Do you want to overwrite the existing origin remote? (y/N)"
        if ($ans -match '^[Yy]') {
            Run 'git remote remove origin'
            Run "git remote add origin $RemoteUrl"
        } else {
            Write-Host "Keeping existing remote. Skipping remote add." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "Adding origin -> $RemoteUrl" -ForegroundColor Green
    Run "git remote add origin $RemoteUrl"
}

# Push
Write-Host "Pushing to origin/$Branch (you may be prompted for credentials)..." -ForegroundColor Green
$pushCmd = "git push -u origin $Branch"
Run $pushCmd

Write-Host "Done. If push failed due to authentication, please ensure you have a GitHub PAT or SSH key configured." -ForegroundColor Green
Write-Host "Helpful tips:" -ForegroundColor Cyan
Write-Host "- For HTTPS: create a Personal Access Token (PAT) at https://github.com/settings/tokens and use it as your password when prompted." -ForegroundColor Cyan
Write-Host "- For SSH: add your public key to GitHub and use the SSH remote URL (git@github.com:owner/repo.git)." -ForegroundColor Cyan
