# PowerShell script to create a public GitHub repository and push code automatically
$ErrorActionPreference = "Stop"

# 1. Gather input from user
$username = Read-Host "Enter your GitHub Username"
$repoName = Read-Host "Enter your desired Repository Name (e.g. hasset-portfolio)"
Write-Host "To push code, you need a Personal Access Token (PAT)." -ForegroundColor Yellow
Write-Host "If you don't have one, create it here: https://github.com/settings/tokens (select 'repo' scope)" -ForegroundColor Yellow
$token = Read-Host "Enter your GitHub Personal Access Token (PAT)" -AsSecureString

# Convert secure string to plain text for the API call and Git push authentication
$tokenText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

Write-Host "`n[1/3] Creating public GitHub repository '$repoName'..." -ForegroundColor Cyan

$headers = @{
    "Authorization" = "token $tokenText"
    "Accept"        = "application/vnd.github.v3+json"
    "User-Agent"    = "PowerShell"
}
$body = @{
    name = $repoName
    private = $false
} | ConvertTo-Json

try {
    # Send POST request to GitHub API to create the repository
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
    Write-Host "Success: Repository created at $($response.html_url)" -ForegroundColor Green

    Write-Host "`n[2/3] Committing files locally..." -ForegroundColor Cyan
    git add .
    # Use try/catch in case there are no changes to commit
    try {
        git commit -m "Configure GitHub Pages deployment, contact details, and animations"
    } catch {
        Write-Host "Nothing new to commit." -ForegroundColor Gray
    }

    Write-Host "`n[3/3] Setting remote origin and pushing to GitHub..." -ForegroundColor Cyan
    git branch -M main
    
    # Remove existing remote origin if present
    try {
        git remote remove origin
    } catch {}

    # Add authenticated remote url temporarily
    $authenticatedUrl = "https://${username}:${tokenText}@github.com/${username}/${repoName}.git"
    git remote add origin $authenticatedUrl

    # Push to default branch
    git push -u origin main

    # Reset remote URL to normal public url so token is not saved in your git config
    git remote set-url origin "https://github.com/$username/$repoName.git"

    Write-Host "`n=======================================================" -ForegroundColor Green
    Write-Host "🎉 DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
    Write-Host "Your code is pushed to: https://github.com/`$username/`$repoName" -ForegroundColor Green
    Write-Host "Your live website will be published at: https://`$username.github.io/`$repoName/" -ForegroundColor Green
    Write-Host "=======================================================" -ForegroundColor Green
    Write-Host "`nNote: Go to repository Settings -> Pages -> Source and select 'GitHub Actions' to finish publishing." -ForegroundColor Yellow

} catch {
    Write-Host "`nError: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please check your credentials or if the repository already exists." -ForegroundColor Red
}
