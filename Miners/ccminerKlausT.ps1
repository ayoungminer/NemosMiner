. .\Include.ps1

$Path = ".\Bin\NVIDIA-CcminerKlausTv10\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminer-KlausT-8.21-mod-r18-src-fix/releases/download/8.21-r18-fix%2Blyra2v3/ccminer-8.21-yescrypt-algos+lyra2v3.7z"

$Commands = [PSCustomObject]@{
    "lyra2v3" = " -a lyra2v3 -d $SelGPUCC" #Lyra2v3 -i 24 max
    "lyra2rev3" = " -a lyra2v3 -d $SelGPUCC" #Lyra2rev3 -i 24 max
    "neoscrypt" = " -i 17 -d $SelGPUCC" #NeoScrypt
    "yescrypt" = " -i 12.5 -d $SelGPUCC" #Yescrypt
    "yescryptR8" = " -i 12.5 -d $SelGPUCC" #YescryptR8
    "yescryptR16" = " -i 12.5 -d $SelGPUCC" #YescryptR16
    "yescryptR16v2" = " -i 12.5 -d $SelGPUCC" #YescryptR16v2
    "yescryptR24" = " -i 12.5 -d $SelGPUCC" #YescryptR24
    #"yescryptR32" = " -i 12.5 -d $SelGPUCC" #YescryptR32
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--cpu-priority 5 -b 4068 -N 1 -R 1 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
    }
}
