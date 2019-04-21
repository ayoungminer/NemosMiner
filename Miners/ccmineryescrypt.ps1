. .\Include.ps1

$Path = ".\Bin\NVIDIA-Ccmineryescrypt\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminerKlausTyescrypt/releases/download/v9/ccminerKlausTyescryptv9.7z"

$Commands = [PSCustomObject]@{
    "yescrypt" = " -d $SelGPUCC" #Yescrypt
    "yescryptR8" = " -d $SelGPUCC" #YescryptR8
    "yescryptR16" = " -i 13.25 -d $SelGPUCC" #YescryptR16
    "yescryptR16v2" = " -d $SelGPUCC" #YescryptR16v2
    "yescryptR24" = " -d $SelGPUCC" #YescryptR24
    #"yescryptR32" = " -i 12.49 -d $SelGPUCC" #YescryptR32
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
        $Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--cpu-priority 4 -b 4068 -N 2 -R 1 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day * (1 - $Fee)} # account for 1% stale shares
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}
