### script checks certificate expiration dates for a few websites
### script was inspired by https://iamoffthebus.wordpress.com/2014/02/04/powershell-to-get-remote-websites-ssl-certificate-expiration/
### script was fixed with input from https://blog.sheehans.org/2017/09/24/powershell-datetime-throws-the-error-string-was-not-recognized-as-a-valid-datetime/
### works with Windows PowerShell 5.1

$minimumCertAgeDays = 30
$timeoutMilliseconds = 6000
$urls = @(
    "https://blog.kaniski.eu/",
    "https://www.github.com/"
)

$allData = @()
$outputCSV = ".\CertificateExpiration.csv"

# disabling the cert validation check. This is what makes this whole thing work with invalid certs...
[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
 
foreach ($url in $urls) {
    $tempData = New-Object -TypeName PSObject

    Write-Host "Getting certificate information for $url ..." -ForegroundColor "Yellow"
    $tempData | Add-Member -Type NoteProperty -Name "URL" -Value $url

    $req = [System.Net.WebRequest]::Create($url)
    $req.Timeout = $timeoutMilliseconds
 
    try {
        $req.GetResponse() | Out-Null
    }
    catch {
        Write-Host "Exception occurred while checking URL $url`: $_ ." -ForegroundColor "Red"
    }
    $expirationString = $req.ServicePoint.Certificate.GetExpirationDateString()
 
    $dateTimeFormat = "$((Get-Culture).DateTimeFormat.ShortDatePattern) $((Get-Culture).DateTimeFormat.LongTimePattern)"
    $expiration = [DateTime]::ParseExact($expirationString, $dateTimeFormat, [System.Globalization.DateTimeFormatInfo]::InvariantInfo, [System.Globalization.DateTimeStyles]::None)
 
    [int]$certExpiresIn = ($expiration - $(Get-Date)).Days
    if ($certExpiresIn -gt $minimumCertAgeDays){
        Write-Host "Certificate for site $url expires in $certExpiresIn days (on $('{0:dd.MM.yyyy.}' -f $expiration))." -ForegroundColor "Green"
        $tempData | Add-Member -Type NoteProperty -Name "ExpiresIn" -Value $certExpiresIn
    }
    else {
        Write-Host "ERROR: Certificate for site $url expires in $certExpiresIn days (on $('{0:dd.MM.yyyy.}' -f $expiration)) and query threshold is set to $minimumCertAgeDays days!" -ForegroundColor "Red"
    }

    $allData += $tempData
}

Write-Host "INFO: Writing output to CSV file located at $outputCSV" -ForegroundColor "Yellow"
$allData | Export-Csv -Path $outputCSV -Delimiter ";" -NoTypeInformation

# ...
# Getting certificate information for https://blog.kaniski.eu/ ...
# Certificate for site https://blog.kaniski.eu/ expires in 110 days (on 26.04.2022.).
# Getting certificate information for https://www.github.com/ ...
# Certificate for site https://www.github.com/ expires in 211 days (on 16.03.2023.).
# ...
