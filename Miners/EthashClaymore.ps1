. .\Include.ps1

$Path = ".\\Bin\\Ethash-Claymore\\EthDcrMiner64.exe"
$Uri = "https://github.com/nemosminer/Claymores-Dual-Ethereum/releases/download/v11.7/ClaymoreEthMiner.v11.7.7z"
$Commands = [PSCustomObject]@{
    "ethash" = "" #Ethash
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -esm 3 -allpools 1 -allcoins 1 -platform 3 -mport -3333 -epool $($Pools.Ethash.Host):$($Pools.Ethash.Port) -ewal $($Pools.Ethash.User) -epsw $($Pools.Ethash.Pass)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .99} # substract 1% devfee
        API = "Claymore"
        Port = 3333
        Wrap = $false
        URI = $Uri
    }
}
