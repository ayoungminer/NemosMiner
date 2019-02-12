. .\Include.ps1

$Path = ".\Bin\NVIDIA-CryptoDredge\CryptoDredge.exe"
$Uri = "https://github.com/technobyl/CryptoDredge/releases/download/v0.16.2/CryptoDredge_0.16.2_cuda_10.0_windows.zip"

$Commands = [PSCustomObject]@{
    #"allium" = " -a allium" #Allium
    #"blake2s" = " -a blake2s" #Blake2s
    #"cnv8" = " -a cnv8" #CryptoNightv8
    #"cryptonightheavy" = " -a cryptonightheavy" #CryptoNightHeavy
    #"cryptonightv7" = " -a cryptonightv7" #CryptoNightV7
    #"cryptonightmonero" = " -a cryptonightv7" #Cryptonightmonero
    "exosis" = " -a exosis" #Exosis
    "hmq1725" = " --intensity 8 -a hmq1725" #Hmq1725
    "lbk3" = " -a lbk3 -i 4" #Lbk3
    #"lyra2v2" = " -a lyra2v2" #Lyra2RE2
    "lyra2vc0ban" = " -a lyra2vc0ban" #Lyra2vc0banHash
    #"lyra2z" = " -a lyra2z" #Lyra2z
    #"lyrarev3" = " -a lyrarev3" #Lyra2REv3 
    #"lyra2v3" = " -a lyrarev3" #Lyra2v3
    "neoscrypt" = " -a neoscrypt" #NeoScrypt
    #"phi" = " -a phi" #Phi
    "phi2" = " -a phi2" #Phi2
    "pipe" = " -a pipe" #Pipe
    #"skein" = " -a skein" #Skein
    #"skunk" = "" #Skunk
    #"tribus" = " -a tribus" #Tribus
    #"x22i" = " -a x22i" #X22i
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = " --retry-pause 1 -b 127.0.0.1:4068 -d $SelGPUCC --no-watchdog -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) -R 1 -q -N 1"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Week * .99} # substract 1% devfee
        API       = "ccminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
    }
}