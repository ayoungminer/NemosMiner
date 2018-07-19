. .\Include.ps1

$Path = ".\Bin\NVIDIA-trex\t-rex.exe"
$Uri = "http://nemos.dx.am/opt/nemos/t-rex-0.5.1-win-cuda9.1.7z"

$Commands = [PSCustomObject]@{
    "hsr" = "" #Hsr
    "phi"= "" #Phi
    #"phi2" = "" #Phi2
    "lyra2z" = "" #Lyra2z
    "tribus" = "" #Tribus
    "c11" = "" #C11
    "x17" = "" #X17
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 127.0.0.1:4068 -d $SelGPUCC -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) -r 5"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}