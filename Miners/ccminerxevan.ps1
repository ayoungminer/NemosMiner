. .\Include.ps1

$Path = ".\Bin\NVIDIA-ccminerxevan\ccminer_x86.exe"
$Uri = "https://github.com/nemosminer/ccminer-xevan/releases/download/ccminer-xevan/ccminer_x86.7z"

$Commands = [PSCustomObject]@{
    "xevan" = " -i 21 -N 2 -d $SelGPUCC" #Xevan
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
	$Algo = Get-Algorithm($_)
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b 4068 -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API = "ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
	User = $Pools.(Get-Algorithm($_)).User
	Host = $Pools.(Get-Algorithm($_)).Host
	Coin = $Pools.(Get-Algorithm($_)).Coin
    }
}