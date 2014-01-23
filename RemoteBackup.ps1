#
# Don't forget to enable script execution and powershell remoting on your server 
# Set-ExecutionPolicy unrestricted
# og 
# Enable-PSRemoting -force
#


$computer = read-host 'Enter server name'
$database = read-host 'Enter database name'
$backupName = read-host 'Enter backup name'
$backupFolder = read-host 'Enter remote folder for backup'
$timestamp = (Get-Date).ToString("yyyyMMddHHmm")
$fullBackupName = "$backupFolder\" + $backupName + "_$timestamp.bak"
$credential = read-host 'Enter user name'
$params = $database,$computer,$fullBackupName

$backupScript = { 
    param([string[]]$params)
    $database = $params[0]
    $computer = $params[1]
    $fullBackupName = $params[2]
    Write-Host "Logged in to server $computer"
    Write-Host "Server: $computer"
    Write-Host "Database: $database"
    Write-Host "Backup location: $fullBackupName"
    import-Module SQLPS
    Backup-SqlDatabase -ServerInstance $computer -Database $database -BackupFile $fullBackupName 
}

invoke-command -computername $computer -scriptblock $backupScript -ArgumentList (,$params) -Credential $credential
