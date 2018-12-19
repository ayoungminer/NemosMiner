. .\Include.ps1

$Path = ".\Bin\NVIDIA-trex\t-rex.exe"
$Uri = "https://github.com/trexminer/T-Rex/releases/download/0.8.9/t-rex-0.8.9-win-cuda10.0.zip"

$Commands = [PSCustomObject]@{
    "balloon" = "" #Balloon
    "bcd" = "" #BCD
    "bitcore" = "" #Bitcore
    "c11" = "" #C11
    "dedal" = "" #Dedal
    #"geek" = "" #Geekcash
    "hmq1725" = "" #Hmq1725
    "hsr" = "" #Hsr
    "lyra2z" = "" #Lyra2z
    "phi"= "" #Phi
    "polytimos" = "" #Poly
    #"sha256t" = "" #Sha256t
    "skunk" = "" #Skunk
    "sonoa" = "" #SonoA
    #"timetravel" = "" #Timetravel
    "tribus" = "" #Tribus
    "x17" = "" #X17
    #"x16s" = "" #X16s
    #"x16r" = "" #X16r
    "x22i" = "" #X21i
    #"x21s" = "" #X21s
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 127.0.0.1:4068 -d $SelGPUCC -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}