. .\Include.ps1

$Path = ".\Bin\NVIDIA-CcminerKlaustorig\ccminer.exe"
$Uri = "https://github.com/KlausT/ccminer/releases/download/8.21/ccminer-821-cuda91-x64.zip"

$Commands = [PSCustomObject]@{
    #"bitcore" = "" #Bitcore
    #"blake2s" = "" #Blake2s
    #"blakecoin" = " -r 0 -d $SelGPUCC -q" #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"cryptonight" = "" #Cryptonight
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = " -r 0 -d $SelGPUCC" #Groestl
    #"hmq1725" = "" #hmq1725
    #"keccak" = " -d $SelGPUCC -q" #Keccak
    #"lbry" = "" #Lbry
    #"lyra2v2" = " -d $SelGPUCC" #Lyra2RE2
    #"lyra2z" = "" #Lyra2z
    #"myr-gr" = " -r 0 -d $SelGPUCC" #MyriadGroestl
    "neoscrypt" = " -r 0 -d $SelGPUCC" #NeoScrypt
    #"nist5" = " -d $SelGPUCC" #Nist5
    #"pascal" = "" #Pascal
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib" = "" #Sib
    #"skein" = " -d $SelGPUCC" #Skein
    #"timetravel" = "" #Timetravel
    #"x11" = "" #X11
    #"veltor" = "" #Veltor
    #"x11evo" = "" #X11evo
    #"c11" = " -d $SelGPUCC" #C11
    #"yescrypt" = " -r 0 -d $SelGPUCC" #yescrypt
    #"yescryptR8" = " -r 0 -d $SelGPUCC"
    #"yescryptR16" = " -r 0 -d $SelGPUCC" #YescryptR16 #Yenten
    #"yescryptR16v2" = " -r 0 -d $SelGPUCC" #PPN
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 4068 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
    }
}
