$OutputFolder = $(Get-Location).Path + "\extracted"
Write-Host("WARNING") -ForegroundColor Red -NoNewline
Write-Host(": This script will extract the content in the current working directory: $OutputFolder")

$SourceFolder = $($(Read-Host 'Insert Folder where the Files should be copied from') -replace '/', '\').TrimEnd('\')
if (!(Test-Path ($SourceFolder + "\resources")))
{
    Write-Host("ERROR") -ForegroundColor Red -NoNewline
    Write-Host(": The specified path does not exist or does not contain a resources folder")
    return
}

$RepositoryFileExtensions = @(".lua", ".xml", ".anm2")
$BannedFileExtensions = @(".gitignore",".it", ".txt", ".json")

$GetNonRepoFiles = $(Read-Host 'Do you want to extract Non Repository Files? (Y/n)') -eq "Y"

if ($GetNonRepoFiles)
{
    $Files = Get-ChildItem -Path $SourceFolder -Recurse | Where-Object {!$_.PSIsContainer -and $_.Extension -notin $RepositoryFileExtensions -and $_.Extension -notin $BannedFileExtensions}
}
else
{
    $Files = Get-ChildItem -Path $SourceFolder -Recurse | Where-Object {!$_.PSIsContainer -and $_.Extension -in $RepositoryFileExtensions -and $_.Extension -notin $BannedFileExtensions}
}

foreach ($File in $Files) {
    $ParentDestinationPath = $($File.FullName | Split-Path -Parent) -replace [regex]::Escape($SourceFolder), $OutputFolder
    if (!(Test-Path $ParentDestinationPath))
    {
        New-Item -ItemType Directory -Path $ParentDestinationPath -Force
    }
    $FullDestinationPath = Join-Path -Path $ParentDestinationPath -ChildPath $File.Name
    Copy-Item -Path $File.FullName -Destination $FullDestinationPath
}