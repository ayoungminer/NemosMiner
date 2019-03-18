. .\Include.ps1

$Path = ".\Bin\NVIDIA-CcminerKlausTr32\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminerKlausTyescrypt/releases/download/v9/ccminerKlausTyescryptv9.7z"

$Commands = [PSCustomObject]@{
    "yescryptR32" = " -i 12.5 -d $SelGPUCC" #YescryptR32
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--cpu-priority 4 -b 4068 -N 2 -R 1 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .86} # substract 14% account for staleshares
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
    }
}
