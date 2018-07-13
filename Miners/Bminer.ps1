. .\Include.ps1
 
$Path = ".\Bin\NVIDIA-Bminer\bminer.exe"
$Uri = "https://www.bminercontent.com/releases/bminer-lite-v9.0.0-199ca8c-amd64.zip"
$Commands = [PSCustomObject]@{
    "equihash" = " -max-temperature 94 -devices $SelGPUCC" #Equihash(fastest no dev fee)
}
$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -api 127.0.0.1:4068 -nofee -uri stratum://$($Pools.(Get-Algorithm($_)).User):$($Pools.(Get-Algorithm($_)).Pass.ToString().replace(',','%2C'))@$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day} 
        API = "Wrapper"
        Port = 4068
        Wrap = $true
        URI = $Uri    
        User = $Pools.(Get-Algorithm($_)).User
    }
}