# code for single vm file transfer
# powershell code:

# # transfer.ps1
# param (
#     [string]$DestinationUser = "cdudi",
#     [string]$DestinationHost = "10.128.0.28",
#     [string]$CsvFilePath = "data3.csv",
#     [string]$TargetPath = "/home/cdudi/"
# )

# # Compose destination string with proper variable expansion
# $destination = "${DestinationUser}@${DestinationHost}:$TargetPath"

# # Run scp command with strict host key checking disabled
# scp -o StrictHostKeyChecking=no $CsvFilePath $destination


param (

    [string]$DestinationUser,

    [string]$DestinationHosts,

    [string]$CsvFilePath,

    [string]$TargetPath

)
 
$hosts = $DestinationHosts -split ','
 
foreach ($hostIp in $hosts) {

    $destination = "$DestinationUser@${hostIp}:${TargetPath}"

    Write-Host "Transferring $CsvFilePath to $destination"

    scp -o StrictHostKeyChecking=no $CsvFilePath $destination
 
    if ($LASTEXITCODE -ne 0) {

        Write-Host "Transfer to $hostIp failed."

        exit 1

    }

}
 
Write-Host "✅ All transfers completed successfully."
 