# July 2019
# Created by Patrix of https://bucherons.ca

# Edit and Run this script to Sync and backup your satisfactory games.

#---------------------------------------------------------
# Variables
#---------------------------------------------------------

# Variables you should change.
$cloudPath=${env:UserProfile} + "\Google Drive\Satisfactory"	#Path of the cloud sync folder on your Google Drive or DropBox
$clientName=${env:UserName}	#Your name / nickname *(Used for naming backups) formating : "nickname" OR ${env:UserName} for the environment variable.
$guid = Get-ChildItem "${env:localAppData}\FactoryGame\Saved\SaveGames\" | Where-Object {$_.Name -ne 'Common'} | Select-Object -Property Name	#Guid forsave folder
$guid = $guid.Name

#Variables you should probably not change.					
							
$localSave="${env:localAppData}\FactoryGame\Saved\SaveGames\$guid\SharedGame.sav"	#Path to the local save FILE, Don't forget to edit the part for the ID folder that look like this : 289339e8e418470095a90ceeca947834
$cloudSave=$cloudPath+"\SharedGame\SharedGame.sav"	#Path to the cloud save FILE
$backupPath=$cloudPath+"\Backups"	#Path to the cloud backups FOLDER
$backupDays="14"	#Number of days of backups to keep.
$7zExec=$cloudPath+"\7z\7za.exe"	#Path to 7zip

#Do not modify below this line
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#


#---------------------------------------------------------
#Config Check
#---------------------------------------------------------
Write-Host "Checking config"

if (!(Test-Path $7zExec)){
	Write-Host "7za.exe not found at : $7zExec"
	pause
	exit
}

#---------------------------------------------------------
#Backup
#---------------------------------------------------------

Write-Host "Creating Backup"
#Create backup name from date and time
$backupDate=Get-Date -UFormat %Y-%m-%d_%H-%M-%S

#Compare both file

$clientFileDate = [datetime](Get-ItemProperty -Path $localSave -Name LastWriteTime).lastwritetime
$cloudFileDate = [datetime](Get-ItemProperty -Path $cloudSave -Name LastWriteTime).lastwritetime
if ($clientFileDate -eq $cloudFileDate){Write-Host "Both file are the same age, skiping process"} else {
	#if client file is more recent, backup the cloud file and copy the client file to the cloud
	if ($clientFileDate -gt $cloudFileDate) {
		$backupName=$backupDate+" Cloud"
		Write-Host "Using Client File"
		New-Item -ItemType directory -Path $backupPath -ErrorAction SilentlyContinue
		& $7zExec a -tzip -mx=1 $backupPath\$backupName.zip $cloudSave
		Copy-Item $localSave $cloudSave -Force
		Write-Host "Backup Created : $backupName.zip"
	}

	#if cloud file is more recent, backup the client file and copy the cloud file to the client
	if ($clientFileDate -lt $cloudFileDate) {
		$backupName=$backupDate+" "+$clientName
		Write-Host "Using Cloud File"
		New-Item -ItemType directory -Path $backupPath -ErrorAction SilentlyContinue
		& $7zExec a -tzip -mx=1 $backupPath\$backupName.zip $localSave
		Copy-Item $cloudSave $localSave -Force
		Write-Host "Backup Created : $backupName.zip"
	}

	#Delete old backups
	Write-Host "Deleting backup older than $backupDays"
	$limit = (Get-Date).AddDays(-$backupDays)
	Get-ChildItem -Path $backupPath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit } | Remove-Item -Force
}

Start-Sleep -s 5
