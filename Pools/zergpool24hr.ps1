. .\Include.ps1

try {
    $zergpool_Request = Invoke-WebRequest "http://api.zergpool.com:8080/api/status" -UseBasicParsing -Headers @{"Cache-Control" = "no-cache"} | ConvertFrom-Json 
}
catch { return }

if (-not $zergpool_Request) {return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Locations = "US", "Europe"

$Locations | ForEach {
    $Location = $_

	$zergpool_Request | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | foreach {
	    $zergpool_Host = If ($Location -eq "Europe"){$Location + ".mine.zergpool.com"}else{"mine.zergpool.com"}
	    $zergpool_Port = $zergpool_Request.$_.port
	    $zergpool_Algorithm = Get-Algorithm $zergpool_Request.$_.name
	    $zergpool_Coin = ""

    $Divisor = 1000000000 * [Double]$ZergPool_Request.$_.mbtc_mh_factor

	    if ((Get-Stat -Name "$($Name)_$($zergpool_Algorithm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($zergpool_Algorithm)_Profit" -Value ([Double]$zergpool_Request.$_.actual_last24h / $Divisor)}
	    else {$Stat = Set-Stat -Name "$($Name)_$($zergpool_Algorithm)_Profit" -Value ([Double]$zergpool_Request.$_.actual_last24h / $Divisor * (1 - ($zergpool_Request.$_.fees / 100)))}

	    if ($Wallet) {
		[PSCustomObject]@{
		    Algorithm     = $zergpool_Algorithm
		    Info          = $zergpool
		    Price         = $Stat.Live
		    StablePrice   = $Stat.Week
		    MarginOfError = $Stat.Fluctuation
		    Protocol      = "stratum+tcp"
		    Host          = $zergpool_Host
		    Port          = $zergpool_Port
		    User          = $Wallet
		    Pass          = "$WorkerName,c=$Passwordcurrency"
		    Location      = $Location
		    SSL           = $false
		}
	    }
	}
}
