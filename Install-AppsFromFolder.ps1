function Install-AppsFromFolder {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ContainerName,
        [pscredential]$credential = (Get-Credential),
        [string]$SourcePath = (Get-Location)
    )

    Sort-AppFilesByDependencies -appFiles (gci $SourcePath -Recurse -Filter *.app | % {
            $_.FullName
        }) | % {
        try {
            Publish-BcContainerApp $ContainerName -appFile $_ -sync -upgrade -skipVerification -useDevEndpoint -credential $credential
        }
        catch {
            Publish-BcContainerApp $ContainerName -appFile $_ -sync -install -skipVerification -useDevEndpoint -credential $credential
        }
    }
}

Export-ModuleMember -Function Install-AppsFromFolder