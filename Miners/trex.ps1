. .\Include.ps1

$Path = ".\Bin\NVIDIA-trex\t-rex.exe"
$Uri = "https://github.com/trexminer/T-Rex/releases/download/0.9.2/t-rex-0.9.2-win-cuda10.0.zip"

$Commands = [PSCustomObject]@{
    "astralhash" = " -i 23" #Astralhash
    "balloon" = " -i 23" #Balloon
    "bcd" = " -i 24" #BCD
    "bitcore" = " -i 25" #Bitcore
    "c11" = " -i 23.5" #C11
    "dedal" = " -i 23" #Dedal
    "geek" = " -i 23" #Geekcash
    #"hmq1725" = " -i 23" #Hmq1725
    "hsr" = "" #Hsr
    "jeonghash"  = " -i 23" #Jeonghash
    "lyra2z" = "" #Lyra2z
    "padihash"   = " -i 23" #Padihash
    "pawelhash"  = " -i 23" #Pawelhash
    "phi"= "" #Phi
    "polytimos" = " -i 25" #Poly
    "sha256t" = " -i 26" #Sha256t
    #"skunk" = "" #Skunk
    "sonoa" = " -i 23" #SonoA
    "timetravel" = " -i 25" #Timetravel
    "tribus" = "" #Tribus
    "x17" = " -i 24" #X17
    "x16s" = " -i 24" #X16s
    "x16r" = " -i 23.5" #X16r
    "x16rt" = " -i 24" #X16rt
    "x21s" = " -i 23" #X21s
    "x22i" = " -i 23" #X22i
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--no-nvml -b 127.0.0.1:4068 -d $SelGPUCC -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --quiet -r 10 --cpu-priority 5"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}