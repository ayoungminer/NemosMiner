. .\Include.ps1

$Path = ".\Bin\NVIDIA-trex\t-rex.exe"
$Uri = "https://github.com/RainbowMiner/miner-binaries/releases/download/v0.12.1-trex/t-rex-0.12.1-win-cuda10.0.zip"

$Commands = [PSCustomObject]@{
    "astralhash" = " -a astralhash -i 23" #Astralhash
    "balloon" = " -a balloon -i 23" #Balloon
    "bcd" = " -a bcd -i 23.5" #BCD
    "bitcore" = " -a bitcore -i 25" #Bitcore
    #"c11" = " -a c11 -i 23.5" #C11
    "dedal" = " -a dedal -i 23" #Dedal
    "geek" = " -a geek -i 23" #Geekcash
    "honeycomb" = " -a honeycomb -i 23" #Honeycomb
    #"hmq1725" = " -a hmq1725 -i 23" #Hmq1725
    "jeonghash" = " -a jeonghash -i 23" #Jeonghash
    "mtp" = " -a mtp -i 23" #MTP 
    "padihash"   = " -a padihash -i 23" #Padihash
    "pawelhash"  = " -a pawelhash -i 23" #Pawelhash
    "polytimos" = " -a polytimos -i 25" #Poly
    "sha256t" = " -a sha256t -i 26" #Sha256t
    "sha256q"    = " -a sha256q -i 23" #Sha256q
    #"skunk" = " -a skunk" #Skunk
    "sonoa" = " -a sonoa -i 23" #SonoA
    "timetravel" = " -a timetravel -i 25" #Timetravel
    "tribus" = " -a tribus -i 23" #Tribus
    "veil" = " -a x16rt -i 23" #Veil
    "x17" = " -a x17 -i 24" #X17
    "x16s" = " -a x16s -i 23" #X16s
    "x16r" = " -a x16r -i 23" #X16r
    "x16rt" = " -a x16rt -i 23" #X16rt
    "x21s" = " -a x21s -i 23" #X21s
    "x22i" = " -a x22i -i 23" #X22i
    "x25x" = " -a x25x -i 23" #X25x
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 127.0.0.1:4068 --api-bind-http 0 -d $SelGPUCC -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --quiet -r 10 --cpu-priority 3"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}