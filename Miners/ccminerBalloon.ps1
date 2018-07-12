. .\Include.ps1

$Path = ".\Bin\NVIDIA-ccminerBalloon\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminer--v2balloon/releases/download/v2.3-9.2/ccminer.balloon.v2.3.monkins9.2.zip"

$Commands = [PSCustomObject]@{
    "balloon" = " -d $($Config.SelGPUCC) --cuda_threads 256 --cuda_blocks 100" #Balloon
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 4068 -R 1 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}