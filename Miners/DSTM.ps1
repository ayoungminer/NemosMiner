. .\Include.ps1

$Path = ".\Bin\NVIDIA-DSTM\zm.exe"
$Uri = "http://nemos.dx.am/opt/nemos/zm_0.6.1_win.7z"

$Commands = [PSCustomObject]@{
    "equihash" = " -d $SelGPUDSTM" #Equihash
}
$Port = 2222
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "--telemetry=127.0.0.1:4068 --server $($Pools.(Get-Algorithm($_)).Host) --port $($Pools.(Get-Algorithm($_)).Port) --user $($Pools.(Get-Algorithm($_)).User) --pass $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_) --color --time"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day * .98} # substract 2% devfee
        API = "DSTM"
        Port = 4068
        Wrap = $false
        URI = $Uri    
    }
}
