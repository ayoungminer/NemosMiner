. .\Include.ps1
 
$Path = ".\Bin\NVIDIA-Gminer\miner.exe"
$Uri = "https://github.com/develsoftware/GMinerRelease/releases/download/1.33/gminer_1_33_minimal_windows64.zip"

$Commands = [PSCustomObject]@{
    "equihash144"  = " --devices $SelGPUDSTM --algo 144_5 --pers auto" #Equihash144
    "zhash"        = " --devices $SelGPUDSTM --algo 144_5 --pers auto" #Zhash
    "equihash192"  = " --devices $SelGPUDSTM --algo 192_7 --pers ZERO_PoW" #Equihash192
    "equihash-btg" = " --devices $SelGPUDSTM --algo 144_5 --pers BgoldPoW" # Equihash-btg
    "equihash96"   = " --devices $SelGPUDSTM --algo 96_5 --pers auto" #Equihash96
    #"beam"         = " --devices $SelGPUDSTM --algo 150_5 --pers Beam-PoW" #Equihash150
    "grincuckaroo29"  = " --devices $SelGPUDSTM --algo grin29 --pers auto" #Grincuckaroo29
    #"grincuckatoo31"  = " --devices $SelGPUDSTM --algo grin31 --pers auto" #Grincuckatoo31
 
}

$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
	$Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-t 95 --watchdog 0 --api 4068 --server $($Pools.($Algo).Host) --port $($Pools.($Algo).Port) --user $($Pools.($Algo).User) --pass $($Pools.($Algo).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .98} # substract 2% devfee
        API       = "gminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri    
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}