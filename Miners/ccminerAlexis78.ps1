. .\Include.ps1

$Path = ".\Bin\NVIDIA-Alexis78\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminerAlexis78/releases/download/Alexis78-v1.5/ccminerAlexis78v1.5.7z"

$Commands = [PSCustomObject]@{
    #"hsr" = " -N 1 -r 0 -d $SelGPUCC --api-remote" #Hsr
    #"poly" = " -N 1 -r 0 -d $SelGPUCC --api-remote" #polytimos(fastest)
    #"bitcore" = "" #Bitcore
    #"blake2s" = " -r 0 -d $SelGPUCC --api-remote" #Blake2s
    #"x13" = " -d $SelGPUCC -r 0 -i 20 -N 1" #X13
    #"blakecoin" = " -d $SelGPUCC --api-remote" #Blakecoin
    #"vanilla" = "" #BlakeVanilla
    #"cryptonight" = "" #Cryptonight
    #"veltor" = " -i 23 -d $SelGPUCC --api-remote" #Veltor
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = "" #Groestl
    #"hmq1725" = "" #hmq1725
    #"keccak" = " -N 1 -r 0 -m 2 -i 29 -d $SelGPUCC" #Keccak
    #"keccakc" = " -N 1 -r 0 -i 29 -d $SelGPUCC --api-remote" #Keccakc
    #"lbry" = " -d $SelGPUCC --api-remote" #Lbry
    #"lyra2v2" = " -d $SelGPUCC --api-remote -i 23 -N 1" #Lyra2RE2
    #"lyra2z" = "" #Lyra2z
    #"myr-gr" = " -d $SelGPUCC --api-remote" #MyriadGroestl
    #"neoscrypt" = " -i 15 -d $SelGPUCC" #NeoScrypt
    #"nist5" = " -r 0 -d $SelGPUCC --api-remote" #Nist5
    #"pascal" = "" #Pascal
    #"qubit" = "" #Qubit
    #"scrypt" = "" #Scrypt
    #"sia" = "" #Sia
    #"sib" = " -i 21 -d $SelGPUCC --api-remote" #Sib
    #"skein" = " -N 1 -r 0 -d $SelGPUCC --api-remote" #Skein
    #"timetravel" = "" #Timetravel
    #"c11" = " -N 1 -r 0 -i 21 -d $SelGPUCC --api-remote" #C11
    #"veltor" = " -i 23 -d $SelGPUCC --api-remote" #Veltor
    #"x11evo" = " -N 1 -i 21 -d $SelGPUCC --api-remote" #X11evo
    #"x11gost" = " -i 21 -d $SelGPUCC --api-remote" #X11gost
    #"x17" = " -N 1 -r 0 -i 20 -d $SelGPUCC --api-remote" #X17
    #"yescrypt" = "-d $SelGPUCC --api-remote" #Yescrypt
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
