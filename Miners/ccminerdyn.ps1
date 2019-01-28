. .\Include.ps1

$Path = ".\Bin\NVIDIA-ccminerdyn101\ccminer.exe"
$Uri = "https://github.com/nemosminer/Dynamic-GPU-Miner-Nvidia/releases/download/v1.0.1/ccminerdyn-1.0.1.7z"

$Commands = [PSCustomObject]@{
    "argon2d-dyn" = " -i 13.7" #argon2d-dyn
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-R 1 -b 4068 -o stratum+tcp://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -a argon2d -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API       = "ccminer"
        Port      = 4068
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
    }
}