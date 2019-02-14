. .\Include.ps1
 
$Path = ".\Bin\NVIDIA-Gminer131\miner.exe"
$Uri = "https://nemosminer.com/data/optional/gminer_1_31_minimal_windows64.7z"
$Commands = [PSCustomObject]@{
    "equihash144"  = " --devices $SelGPUDSTM --algo 144_5 --pers auto" #Equihash144 (fastest)
    "zhash"        = " --devices $SelGPUDSTM --algo 144_5 --pers auto" #Zhash (fastest)
    "equihash192"  = " --devices $SelGPUDSTM --algo 192_7 --pers ZERO_PoW" #Equihash192 (fastest)
    "equihash-btg" = " --devices $SelGPUDSTM --algo 144_5 --pers BgoldPoW" # Equihash-btg (fastest)
    "equihash96"   = " --devices $SelGPUDSTM --algo 96_5 --pers auto" #Equihash96 (fastest)
    #"beam"         = " --devices $SelGPUDSTM --algo 150_5 --pers Beam-PoW" #Equihash150 (Bminer faster)
    "grincuckaroo29"  = " --devices $SelGPUDSTM --algo grin29 --pers auto" #Grincuckaroo29 (fastest)
   #"grincuckatoo31"  = " --devices $SelGPUDSTM --algo grin31 --pers auto" #Grincuckatoo31 requires 7.4GB VRam, will work on 8GB cards under Linux and Windows 7, will not work under Windows 10)
 
}
$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
	$Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-t 95 --watchdog 0 --api 4068 --server $($Pools.($Algo).Host) --port $($Pools.($Algo).Port) --user $($Pools.($Algo).User) --pass $($Pools.($Algo).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day * .98} # substract 2% devfee
        API       = "gminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri    
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}