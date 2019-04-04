. .\Include.ps1

$Path = ".\Bin\NVIDIA-TTMiner221\TT-Miner.exe"
$Uri = "https://tradeproject.de/download/Miner/TT-Miner-2.2.1.zip"

$Commands = [PSCustomObject]@{
       "progpow"    = " -a PROGPOW" #Progpow
       #"mtp"        = " -a MTP" #MTP
       #"ethash"     = " -a ETHASH-101"
       #"ubqhash"   = " -a UBQHASH-100"
       #"myr-gr"    = " -a MYRGR-100" 
       #"lyra2v3"    = " -a LYRA2V3-101" 
       #"lyra2rev3"  = " -a LYRA2V3-101" 
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    $Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-d $SelGPUCC --api-bind 127.0.0.1:4068 -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API       = "TTminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
    }
}