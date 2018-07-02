. .\Include.ps1

$Path = ".\Bin\NVIDIA-CuBalloon\cuballoon.exe"
$Uri = "https://github.com/Belgarion/cuballoon/files/2143221/CuBalloon.1.0.2.Windows.zip"

$Commands = [PSCustomObject]@{
    "balloon" = "" #Balloon
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -b 4068 -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --cuda_devices 0,1,2,3,4,5,6,7,8,9,10,11 --cuda_threads 64,64,64,64,64,64,64,64,64,64,64,64 --cuda_blocks 48,48,48,48,48,48,48,48,48,48,48,48 --cuda_sync 0 -t 0"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .97} # substract about 3% fee
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}