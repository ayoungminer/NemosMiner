. .\Include.ps1

$Path = ".\Bin\NVIDIA-CryptoDredge\CryptoDredge.exe"
$Uri = "https://github.com/technobyl/CryptoDredge/releases/download/v0.18.0/CryptoDredge_0.18.0_cuda_10.0_windows.zip"

$Commands = [PSCustomObject]@{
    "argon2d-dyn" = " --intensity 8 -a argon2d" #Argon2d-dyn
    "allium" = " --intensity 8 -a allium" #Allium
    "c11" = " --intensity 8 -a c11" #C11
    #"cnv8" = " -a cnv8" #CryptoNightv8
    #"cryptonightheavy" = " -a cryptonightheavy" #CryptoNightHeavy
    #"cryptonightv7" = " -a cryptonightv7" #CryptoNightV7
    #"cryptonightmonero" = " -a cryptonightv7" #Cryptonightmonero
    "grincuckaroo29" = " --intensity 8 -a cuckaroo29" #Grincuckaroo29
    "hmq1725" = " --intensity 8 -a hmq1725" #Hmq1725
    "lbk3" = " -a lbk3 -i 4" #Lbk3
    #"lyra2v2" = " -a lyra2v2" #Lyra2RE2
    #"lyra2vc0ban" = " -a lyra2vc0ban" #Lyra2vc0banHash
    #"lyra2z" = " -a lyra2z" #Lyra2z
    "lyra2zz " = " --intensity 8 -a lyra2zz" #Lyra2zz
    "lyra2REv3" = " --intensity 8 -a lyrarev3" #Lyra2REv3 
    "lyra2v3" = " --intensity 8 -a lyra2v3" #Lyra2v3
    "lyra2vc0ban" = " --intensity 8 -a lyra2vc0ban" #Lyra2vc0banHash
    "mtp" = " --intensity 8 -a mtp" #Mtp
    "neoscrypt" = " --intensity 6 -a neoscrypt" #NeoScrypt
    "phi" = " --intensity 8 -a phi" #Phi
    "phi2" = " --intensity 7 -a phi2" #Phi2
    "pipe" = " --intensity -a pipe" #Pipe
    #"skein" = " -a skein" #Skein
    "skunk" = " --intensity 8 -a skunk" #Skunk
    #"tribus" = " -a tribus" #Tribus
    #"x17" = " --intensity 8 -a x17" #X17
    #"x16s" = " --intensity 8 -a x16s" #X16s
    #"x16r" = " --intensity 8 -a x16r" #X16r
    #"x16rt" = " --intensity 8 -a x16rt" #X16rt
    #"x22i" = " --intensity 8 -a x22i" #X22i
    #"x21s" = " --intensity 8 -a x21s" #X21s
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = " --no-nvml --api-type ccminer-tcp --cpu-priority 4 --no-watchdog -r 1 -R 1 -b 127.0.0.1:4068 -d $SelGPUCC -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) -q"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API       = "ccminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
    }
}