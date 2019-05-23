. .\Include.ps1

$Path = ".\Bin\NVIDIA-TPruvot\ccminer-x64.exe"
$Uri = "https://github.com/tpruvot/ccminer/releases/download/2.3.1-tpruvot/ccminer-2.3.1-cuda10.7z"

$Commands = [PSCustomObject]@{
    #"exosis"  = " -a exosis -i 25.75" #Exosis
    #"allium"  = " -a allium -i 22" #Allium
    #"keccak"  = " -a keccak -i 29" #Keccak
    #"keccakc" = " -a keccakc -i 29" #Keccakc
    #"phi2" = " -a phi2 -i 22.25" #Phi2
    #"skein2" = -a skein2" #Skein2
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 4068 -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User      = $Pools.($Algo).User
        Host      = $Pools.($Algo).Host
        Coin      = $Pools.($Algo).Coin
    }
}
