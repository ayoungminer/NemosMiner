. .\Include.ps1

$Path = ".\Bin\NVIDIA-Hsrminer\hsrminer_neoscrypt_fork_hp.exe"
$Uri = "https://github.com/justaminer/hsrm-fork/raw/master/hsrminer_neoscrypt_fork_hp.zip"

$Commands = [PSCustomObject]@{
    #"neoscrypt" = " -d $SelGPUCC" #NeoScrypt
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-a $_ -b 4068 -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
    }
}
