$Url = "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.6.3.zip"
$ZipFile = "$PSScriptRoot\jmeter.zip"
$DestFolder = "$PSScriptRoot\jmeter"

Write-Host "Downloading Apache JMeter 5.6.3..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $ZipFile

Write-Host "Extracting Apache JMeter..." -ForegroundColor Cyan
Expand-Archive -Path $ZipFile -DestinationPath $DestFolder -Force

# Move contents of apache-jmeter-5.6.3 subfolder to the root jmeter folder
$SubFolder = Get-ChildItem -Path $DestFolder -Directory | Select-Object -First 1
if ($SubFolder) {
    Get-ChildItem -Path $SubFolder.FullName | Move-Item -Destination $DestFolder -Force
    Remove-Item $SubFolder.FullName -Recurse -Force
}

Remove-Item $ZipFile -Force
Write-Host "JMeter setup complete!" -ForegroundColor Green
Write-Host "To start JMeter GUI, run: jmeter\bin\jmeter.bat" -ForegroundColor Yellow
Write-Host "You can open 'performance_test.jmx' directly in JMeter to run the test." -ForegroundColor Yellow
