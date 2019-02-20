. .\Include.ps1

$Path = ".\Bin\NVIDIA-EnergiMiner\energiminer.exe"
$Uri = "https://nemosminer.com/data/optional/energiminer-2.2.1-Windows.7z"

$Commands = [PSCustomObject]@{
    "nrghash" = "" #Nrghash
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "--response-timeout 10 --cuda-parallel-hash 8 --cuda-block-size 256 --cuda-devices $SelGPUDSTM -U stratum://$($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)@$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API       = "Ccminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
        Host      = $Pools.(Get-Algorithm($_)).Host
        Coin      = $Pools.(Get-Algorithm($_)).Coin
    }
}