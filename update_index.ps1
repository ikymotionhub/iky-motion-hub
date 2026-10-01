param(
    [string]$token,
    [string]$owner,
    [string]$repoName,
    [string]$filePath
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$headers = @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

Write-Host "Buscando SHA actual de index.html..."
$getFileUrl = "https://api.github.com/repos/$owner/$repoName/contents/index.html"
$fileInfo = Invoke-RestMethod -Uri $getFileUrl -Headers $headers -ErrorAction Stop
$currentSha = $fileInfo.sha

Write-Host "Codificando archivo nuevo..."
$bytes = [System.IO.File]::ReadAllBytes($filePath)
$base64 = [Convert]::ToBase64String($bytes)

Write-Host "Subiendo actualización a GitHub..."
$body = @{
    message = "Actualizar index.html: tipografías y slider"
    content = $base64
    sha = $currentSha
} | ConvertTo-Json

Invoke-RestMethod -Uri $getFileUrl -Method Put -Headers $headers -Body $body -ErrorAction Stop

Write-Host "¡Actualización completada exitosamente!"
