function Test-ValidFileName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$FileName
    )

    $InvalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    return !($FileName.IndexOfAny($InvalidChars) -ge 0)
}

function Get-CommonFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $MainFolder,
        [Parameter(Mandatory = $true)]
        [String] $OtherFolder,
        [Parameter(Mandatory = $true)]
        [String] $Extension
    )

    $Files = Get-ChildItem -Path $MainFolder -Recurse | Where-Object {!$_.PSIsContainer -and $_.Extension -eq $Extension}
    $RelativePaths = $Files | ForEach-Object {$_.FullName.Replace($MainFolder, "").TrimStart("\")}

    $CommonFiles = $RelativePaths | ForEach-Object {
        $dlc3Resource = $_ -replace "^resources\\", "resources-dlc3\"
        $filePath = Join-Path -Path $OtherFolder -ChildPath $dlc3Resource
        if (Test-Path -Path $filePath) {
            Write-Output ($_ -replace "^resources-dlc3\\", "resources\")
        }
        else {
            $filePath = Join-Path -Path $OtherFolder -ChildPath $_
            if (Test-Path -Path $filePath) {
                Write-Output ($_ -replace "^resources-dlc3\\", "resources\")
            }
        }
    }

    return $CommonFiles
}

function Copy-CommonFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $File,
        [Parameter(Mandatory = $true)]
        [String] $FirstPath,
        [Parameter(Mandatory = $true)]
        [String] $SecondPath,
        [Parameter(Mandatory = $true)]
        [String] $FirstSuffix,
        [Parameter(Mandatory = $true)]
        [String] $SecondSuffix,
        [Parameter(Mandatory = $true)]
        [String] $DestinationPath
    )

    $firstFile = Join-Path -Path $FirstPath -ChildPath $($File -replace "^resources\\", "resources-dlc3\")
    if (!(Test-Path $FirstFile)) {
        $firstFile = Join-Path -Path $FirstPath -ChildPath $File
    }

    $secondFile = Join-Path -Path $SecondPath -ChildPath $($File -replace "^resources\\", "resources-dlc3\")
    if (!(Test-Path $SecondFile)) {
        $secondFile = Join-Path -Path $SecondPath -ChildPath $File
    }

    $fileDirectory = Split-Path -Path $File
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($File)
    $extension = [System.IO.Path]::GetExtension($File)

    $firstDestinationPath = Join-Path -Path $DestinationPath -ChildPath ($fileDirectory + '/' + $fileName + $FirstSuffix + $extension)
    $secondDestinationPath = Join-Path -Path $DestinationPath -ChildPath ($fileDirectory + '/' + $fileName + $SecondSuffix + $extension)
    $destinationDirectory = Split-Path -Path $firstDestinationPath

    if (!(Test-Path -Path $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force
    }

    Copy-Item -Path $firstFile -Destination $firstDestinationPath -Force
    Copy-Item -Path $secondFile -Destination $secondDestinationPath -Force
}

$FirstFolder = $($($(Read-Host 'Insert First Folder') -replace '/', '\') -replace '"', '').TrimEnd('\')
if ((!(Test-Path ($FirstFolder + "\resources"))) -and !(Test-Path($FirstFolder + "\resources-dlc3")))
{
    Write-Host("ERROR") -ForegroundColor Red -NoNewline
    Write-Host(": The specified path does not exist or does not contain a resources folder")
    return
}

$SecondFolder = $($($(Read-Host 'Insert Second Folder') -replace '/', '\') -replace '"', '').TrimEnd('\')
if ((!(Test-Path ($OtherFolder + "\resources"))) -and !(Test-Path($OtherFolder + "\resources-dlc3")))
{
    Write-Host("ERROR") -ForegroundColor Red -NoNewline
    Write-Host(": The specified path does not exist or does not contain a resources folder")
    return
}

$Copy = $(Read-Host('Copy Common Files? (Y/n)')).ToLower() -eq 'y'

if ($Copy) {
    $CopyFolder = $($($(Read-Host 'Insert Copy Folder') -replace '/', '\') -replace '"', '').TrimEnd('\')
    if (!(Test-Path ($CopyFolder)))
    {
        Write-Host("ERROR") -ForegroundColor Red -NoNewline
        Write-Host(": The specified path does not exist")
        return
    }

    $FirstSuffix = Read-Host('Insert Suffix for files from the first folder (example: _suffix1)')
    if (!(Test-ValidFileName $FirstSuffix))
    {
        Write-Host("ERROR") -ForegroundColor Red -NoNewline
        Write-Host(": The suffix contains invalid characters")
        return
    }

    $SecondSuffix = Read-Host('Insert Suffix for files from the second folder (example: _suffix2)')
    if (!(Test-ValidFileName $SecondSuffix))
    {
        Write-Host("ERROR") -ForegroundColor Red -NoNewline
        Write-Host(": The suffix contains invalid characters")
        return
    }

    if ($FirstSuffix -eq $SecondSuffix)
    {
        Write-Host("ERROR") -ForegroundColor Red -NoNewline
        Write-Host(": The two suffixes cannot be the same")
        return
    }
}

$Extension = Read-Host('Insert extension of the files (example: .png)')

$CommonFiles = Get-CommonFiles $FirstFolder $SecondFolder $Extension
foreach ($file in $CommonFiles) {
    $file
}

if ($Copy) {
    foreach ($file in $CommonFiles) {
        Copy-CommonFile $file $FirstFolder $SecondFolder $FirstSuffix $SecondSuffix $CopyFolder
    }
}