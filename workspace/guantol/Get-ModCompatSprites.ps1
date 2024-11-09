$Folder = $($($(Read-Host 'Insert Folder') -replace '\\', '/') -replace '"', '').TrimEnd('/')
if (!(Test-Path ($Folder + "/resources")))
{
    Write-Host("ERROR") -ForegroundColor Red -NoNewline
    Write-Host(": The specified path does not exist or does not contain a resources folder")
    return
}

$Files = Get-ChildItem -Path $Folder -Recurse | Where-Object {!$_.PSIsContainer -and $_.Name -like "*_modcompat.png"}

$FileList = @()

ForEach($file in $Files)
{
    $cleanName = $file.Name -replace "_modcompat.png", ".png"
    $fileEntry = $FileList | Where-Object {$_.FileName -eq $cleanName}

    if (-not $fileEntry)
    {
        $fileEntry = [PSCustomObject]@{FileName = $cleanName; HasRegular = $false; HasDelirium = $false}
        $FileList += $fileEntry
    }

    if ($file.FullName -match "deliriumforms")
    {
        $fileEntry.HasDelirium = $true
    }
    else
    {
        $fileEntry.HasRegular = $true
    }
}

Write-Host("")

ForEach($file in $FileList)
{
    $hasRegular = if ($file.HasRegular) { "true" } else { "false" }
    $hasDelirium = if ($file.HasDelirium) { "true" } else { "false" }
    $formattedOutput = '["{0}"] = {{hasRegular = {1}, hasDelirium = {2}}},' -f `
                        $file.FileName, $hasRegular, $hasDelirium
    Write-Host($formattedOutput)
}

Write-Host("")

ForEach($file in $Files)
{
    $truncatedPath = $($($file.FullName -replace '.*\\gfx', 'gfx') -replace "_modcompat.png", ".png") -replace '\\', '/'
    $formattedOutput = '["{0}"] = true,' -f `
                        $truncatedPath
    Write-Host($formattedOutput)
}