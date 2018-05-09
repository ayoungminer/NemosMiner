. .\Include.ps1

try {
    $blockmasters_Request = Invoke-WebRequest "http://blockmasters.co/api/status" -UseBasicParsing -Headers @{"Cache-Control" = "no-cache"} | ConvertFrom-Json 
}
catch { return }

if (-not $blockmasters_Request) {return}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Location = "US"

$blockmasters_Request | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | foreach {
	$blockmasters_Host = "blockmasters.co"
	$blockmasters_Port = $blockmasters_Request.$_.port
	$blockmasters_Algorithm = Get-Algorithm $blockmasters_Request.$_.name
	$blockmasters_Coin = ""

	$Divisor = 1000000

	switch ($blockmasters_Algorithm) {
		"equihash" {$Divisor /= 1000}
		"blake2s" {$Divisor *= 1000}
		"blakecoin" {$Divisor *= 1000}
		"decred" {$Divisor *= 1000}
		"keccak" {$Divisor *= 1000}
		"keccakc" {$Divisor *= 1000}
	}

	if ((Get-Stat -Name "$($Name)_$($blockmasters_Algorithm)_Profit") -eq $null) {$Stat = Set-Stat -Name "$($Name)_$($blockmasters_Algorithm)_Profit" -Value ([Double]$blockmasters_Request.$_.estimate_last24h / $Divisor)}
	else {$Stat = Set-Stat -Name "$($Name)_$($blockmasters_Algorithm)_Profit" -Value ([Double]$blockmasters_Request.$_.estimate_current / $Divisor * (1 - ($blockmasters_Request.$_.fees / 100)))}

	if ($Config.PoolsConfig.default.Wallet) {
		[PSCustomObject]@{
			Algorithm     = $blockmasters_Algorithm
			Info          = $blockmasters
			Price         = $Stat.Live
			StablePrice   = $Stat.Week
			MarginOfError = $Stat.Fluctuation
			Protocol      = "stratum+tcp"
			Host          = $blockmasters_Host
			Port          = $blockmasters_Port
			User          = $Wallet
			Pass          = "$WorkerName,c=$Passwordcurrency"
			Location      = $Location
			SSL           = $false
		}
	}
}

