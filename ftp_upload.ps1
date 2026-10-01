param(
    [string]$ftpServer,
    [string]$ftpUser,
    [string]$ftpPass,
    [string]$localFilePath,
    [string]$remoteFilePath
)

try {
    Write-Host "Iniciando conexión FTP a $ftpServer..."
    $uri = "ftp://$ftpServer/$remoteFilePath"
    $ftp = [System.Net.FtpWebRequest]::Create($uri)
    $ftp.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)
    $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $ftp.UseBinary = $true
    $ftp.KeepAlive = $false

    $content = [System.IO.File]::ReadAllBytes($localFilePath)
    $ftp.ContentLength = $content.Length

    $requestStream = $ftp.GetRequestStream()
    $requestStream.Write($content, 0, $content.Length)
    $requestStream.Close()

    $response = $ftp.GetResponse()
    Write-Host "Archivo subido exitosamente: $($response.StatusDescription)"
    $response.Close()
} catch {
    Write-Host "Error en la subida FTP: $($_.Exception.Message)"
}
