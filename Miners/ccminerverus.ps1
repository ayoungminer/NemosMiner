. .\Include.ps1

$Path = ".\Bin\NVIDIA-Ccminerverus\ccminer.exe"
$Uri = "https://nemosminer.com/data/optional/CCMinerVerus-3.3.7z"

$Commands = [PSCustomObject]@{
     "verushash" = " -a verus -i 18.75 -d $SelGPUCC" #Verus
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
	$Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--cpu-priority 4 -b 4068 -N 2 -R 1 -o stratum+tcp://$($Pools.($Algo).Host):$($Pools.($Algo).Port) -u $($Pools.($Algo).User) -p $($Pools.($Algo).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day}
        API = "ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin    
    }
}