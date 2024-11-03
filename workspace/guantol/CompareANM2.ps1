function GetCommonANM2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $Folder1,
        [Parameter(Mandatory = $true)]
        [String] $Folder2
    )

    $Files = Get-ChildItem -Path $Folder1 -Recurse | Where-Object {!$_.PSIsContainer -and $_.Extension -eq ".anm2"}
    $RelativePaths = $Files | ForEach-Object {$_.FullName.Replace($Folder1, "").TrimStart("\")}

    $CommonFiles = $RelativePaths | ForEach-Object {
        $dlc3Resource = $_ -replace "^resources\\", "resources-dlc3\"
        $filePath = Join-Path -Path $Folder2 -ChildPath $dlc3Resource
        if (Test-Path -Path $filePath) {
            Write-Output ($_ -replace "^resources-dlc3\\", "resources\")
        }
        else {
            $filePath = Join-Path -Path $Folder2 -ChildPath $_
            if (Test-Path -Path $filePath) {
                Write-Output ($_ -replace "^resources-dlc3\\", "resources\")
            }
        }
    }

    return $CommonFiles
}

function AreXMLAttributesDifferent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element1,
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element2
    )

    $attributes1 = $Element1.Attributes | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Value = $_.Value } } | Sort-Object Name
    $attributes2 = $Element2.Attributes | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Value = $_.Value } } | Sort-Object Name

    if ($null -eq $attributes1 -or $null -eq $attributes2) {
        return $attributes1 -ne $attributes2
    }

    if ($attributes1.Count -ne $attributes2.Count) {
        return $true
    }

    for ($i = 0; $i -lt $attributes1.Count; $i++) {
        if ($null -ne $(Compare-Object $attributes1[$i] $attributes2[$i] -Property Name, Value)) {
            return $true
        }
    }

    return $false
}

function GetChildNodesCount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Element
    )

    if ($null -eq $rootAnimation1) {
        return 0
    }

    return $Element1.ChildNodes.Count
}

function AreFramesDifferent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Element1,
        [Parameter(Mandatory = $true)]
        $Element2
    )

    $childCount1 = GetChildNodesCount($Element1)
    $childCount2 = GetChildNodesCount($Element2)

    if ($childCount1 -ne $childCount2) {
        return $true
    }

    if ($childCount1 -eq 0) {
        return $false
    }

    $children1 = $Element1.ChildNodes | ForEach-Object { $_ } | Sort-Object { $_.Name }
    $children2 = $Element2.ChildNodes | ForEach-Object { $_ } | Sort-Object { $_.Name }

    for ($i = 0; $i -lt $children1.Count; $i++) {
        if (AreXMLAttributesDifferent $children1[$i] $children2[$i]) {
            return $true
        }
    }

    return $false
}

function AreLayerAnimationsDifferent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element1,
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element2
    )

    $layers1 = $Element1.SelectNodes("LayerAnimation") | Where-Object { $_.ChildNodes.Count -gt 0 }
    $layers2 = $Element2.SelectNodes("LayerAnimation") | Where-Object { $_.ChildNodes.Count -gt 0 }

    if ($layers1.Count -ne $layers2.Count) {
        return $true
    }

    for ($i = 0; $i -lt $layers1.Count; $i++) {
        if (AreXMLAttributesDifferent $layers1[$i] $layers2[$i]) {
            return $true
        }
    }

    return $false
}

function AreNullAnimationsDifferent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element1,
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element2
    )

    $layers1 = $Element1.SelectNodes("NullAnimation") | Where-Object { $_.ChildNodes.Count -gt 0 }
    $layers2 = $Element2.SelectNodes("NullAnimation") | Where-Object { $_.ChildNodes.Count -gt 0 }

    if ($layers1.Count -ne $layers2.Count) {
        return $true
    }

    for ($i = 0; $i -lt $layers1.Count; $i++) {
        if (AreXMLAttributesDifferent $layers1[$i] $layers2[$i]) {
            return $true
        }
    }

    return $false
}

function AreAnimationsDifferent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element1,
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement] $Element2
    )

    if (AreXMLAttributesDifferent $Element1 $Element2) {
        return $true
    }

    if (AreFramesDifferent $Element1.SelectSingleNode("RootAnimation") $Element2.SelectSingleNode("RootAnimation")) {
        return $true
    }

    if (AreLayerAnimationsDifferent $Element1.SelectSingleNode("LayerAnimations") $Element2.SelectSingleNode("LayerAnimations")) {
        return $true
    }

    if (AreNullAnimationsDifferent $Element1.SelectSingleNode("NullAnimations") $Element2.SelectSingleNode("NullAnimations")) {
        return $true
    }

    # Not technically frames but it works either way
    if (AreFramesDifferent $Element1.SelectSingleNode("Triggers") $Element2.SelectSingleNode("Triggers")) {
        return $true
    }

    return $false
}

function CopyAnm2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $Anm2File,
        [Parameter(Mandatory = $true)]
        [String] $IsaacPath,
        [Parameter(Mandatory = $true)]
        [String] $NewPath
    )

    $OriginalANM2 = Join-Path -Path $IsaacPath -ChildPath $($Anm2File -replace "^resources\\", "resources-dlc3\")
    if (!(Test-Path $OriginalANM2)) {
        $OriginalANM2 = Join-Path -Path $IsaacPath -ChildPath $Anm2File
    }

    $destinationPath = Join-Path -Path $NewPath -ChildPath $Anm2File
    $destinationFolder = Split-Path -Path $destinationPath

    if (!(Test-Path -Path $destinationFolder)) {
        New-Item -ItemType Directory -Path $destinationFolder -Force
    }

    Copy-Item -Path $OriginalANM2 -Destination $destinationPath -Force
}

function PrintAnm2Differences {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $Anm2File,
        [Parameter(Mandatory = $true)]
        [String] $IsaacPath,
        [Parameter(Mandatory = $true)]
        [String] $ModPath
    )

    $OriginalANM2 = Join-Path -Path $IsaacPath -ChildPath $($Anm2File -replace "^resources\\", "resources-dlc3\")
    if (!(Test-Path $OriginalANM2)) {
        $OriginalANM2 = Join-Path -Path $IsaacPath -ChildPath $Anm2File
    }

    $NewANM2 = Join-Path -Path $ModPath -ChildPath $($Anm2File -replace "^resources\\", "resources-dlc3\")
    if (!(Test-Path $NewANM2)) {
        $NewANM2 = Join-Path -Path $ModPath -ChildPath $Anm2File
    }

    [xml]$originalXML = Get-Content $OriginalANM2
    [xml]$newXML = Get-Content $NewANM2

    $animations = @{}
    foreach ($animation in $originalXML.AnimatedActor.Animations.Animation) {
        if ($animation.Name -ne '') {
            $animations[$animation.Name] = $animation
        }
    }

    foreach ($animation in $newXML.AnimatedActor.Animations.Animation) {
        if ($null -ne $animations[$animation.Name]) {
            if (AreAnimationsDifferent -Element1 $animations[$animation.Name] -Element2 $animation) {
                Write-Host("{0} Animation '{1}' is different" -f $Anm2File, $animation.Name)
            }
            $animations.Remove($animation.Name)
        }
    }

    foreach ($animation in $animations.Keys) {
        Write-Host("{0} Animation '{1}' is " -f $Anm2File, $animation) -NoNewline
        Write-Host("missing") -ForegroundColor Red
    }
}

$ModFolder = $($($(Read-Host 'Insert Mod Folder') -replace '/', '\') -replace '"', '').TrimEnd('\')
if (!(Test-Path ($ModFolder + "\metadata.xml")))
{
    Write-Host("ERROR") -ForegroundColor Red -NoNewline
    Write-Host(": The specified path does not exist or does not contain a metadata.xml file")
    return
}

$IsaacFolder = $($($(Read-Host 'Insert Isaac Folder') -replace '/', '\') -replace '"', '').TrimEnd('\')
if (!(Test-Path ($IsaacFolder)))
{
    Write-Host("ERROR") -ForegroundColor Red -NoNewline
    Write-Host(": The specified path does not exist")
    return
}

$Copy = $(Read-Host('Copy Common ANM2s? (Y/n)')).ToLower() -eq 'y'

if ($Copy) {
    $CopyFolder = $($($(Read-Host 'Insert Copy Folder') -replace '/', '\') -replace '"', '').TrimEnd('\')
    if (!(Test-Path ($CopyFolder)))
    {
        Write-Host("ERROR") -ForegroundColor Red -NoNewline
        Write-Host(": The specified path does not exist")
        return
    }
}

$CommonFiles = GetCommonANM2 -Folder1 $ModFolder -Folder2 $IsaacFolder
foreach ($file in $CommonFiles) {
    PrintAnm2Differences -Anm2File $file -IsaacPath $IsaacFolder -ModPath $ModFolder
}

if ($Copy) {
    foreach ($file in $CommonFiles) {
        CopyAnm2 $file $IsaacFolder $CopyFolder
    }
}