. .\Include.ps1

$Path = ".\Bin\NVIDIA-EWBFv2\\miner.exe"
$Uri = "https://github.com/ayoungminer/miner-bin/raw/master/EWBFv2/EWBFv2.7z"

$Commands = [PSCustomObject]@{
    "equihash144" = " --cuda_devices $SelGPUDSTM --algo 144_5 --pers sngemPoW" #Equihash144
    "equihash192" = " --cuda_devices $SelGPUDSTM --algo 192_7 --pers ZERO_PoW" #Equihash192
    "equihash144btcz" = " --cuda_devices $SelGPUDSTM --algo 144_5 --pers BitcoinZ" #Equihash144btcz
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--api 127.0.0.1:4068 --server $($Pools.(Get-Algorithm($_)).Host) --port $($Pools.(Get-Algorithm($_)).Port) --fee 0 --eexit 1 --user $($Pools.(Get-Algorithm($_)).User) --pass $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --intensity 64"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "EWBF"
        Port = 4068
        Wrap = $false
        URI = $Uri
    
    }
}