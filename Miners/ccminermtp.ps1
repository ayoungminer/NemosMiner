. .\Include.ps1

$Path = ".\Bin\NVIDIA-ccminermtp\ccminer.exe"
$Uri = "https://github.com/nemosminer/ccminerMTP/releases/download/v1.1.17/ccminerMTP1.1.17.7z"

$Commands = [PSCustomObject]@{
    "mtp" = " -i 20.75 -d $SelGPUCC" #mtp
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
	$Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--cpu-priority 4 -N 2 -R 1 -b 4068 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --quiet -r 10"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
    }
}