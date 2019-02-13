. .\Include.ps1

$Path = ".\Bin\NVIDIA-trex\t-rex.exe"
$Uri = "https://github.com/trexminer/T-Rex/releases/download/0.9.2/t-rex-0.9.2-win-cuda10.0.zip"

$Commands = [PSCustomObject]@{
    "astralhash" = " -i 23" #Astralhash
    "balloon" = " -i 23" #Balloon
    "bcd" = "" #BCD
    "bitcore" = "" #Bitcore
    "c11" = "" #C11
    "dedal" = "" #Dedal
    #"geek" = "" #Geekcash
    "hmq1725" = "" #Hmq1725
    "hsr" = "" #Hsr
    "jeonghash"  = " -i 23" #Jeonghash
    "lyra2z" = "" #Lyra2z
    "padihash"   = " -i 23" #Padihash
    "pawelhash"  = " -i 23" #Pawelhash
    "phi"= "" #Phi
    "polytimos" = "" #Poly
    #"sha256t" = "" #Sha256t
    "skunk" = "" #Skunk
    "sonoa" = "" #SonoA
    "timetravel" = "" #Timetravel
    "tribus" = "" #Tribus
    "x17" = "" #X17
    "x16s" = " -i 24" #X16s
    "x16r" = " -i 23.5" #X16r
    #"x16rt"     = " -i 24" #X16rt (test net/ only trex 091-gin is compatible)
    "x22i" = "" #X21i
    "x21s" = "" #X21s
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 127.0.0.1:4068 -d $SelGPUCC -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --quiet -r 10 --cpu-priority 5"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}