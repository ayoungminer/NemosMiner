@echo off
REM Mandatory parameters >>> Update in the below command line
REM     -Pool = "PoolName"
REM     -Wallet = "YourWalletAddress"

REM Optional parameters >>> Could be added in the below command line    
REM     -APIUri = "http://www.ahashpool.com/api/walletEx?address="
REM     -PaymentThreshold = 0.01
REM     -Interval = 10
REM     -ShowText = $true
REM     -ShowRawData = $false

REM		Replace Pool name and Wallet below with your info

powershell -version 5.0 -noexit -executionpolicy bypass -windowstyle Normal -command "&.\EarningsTracker.ps1 -Pool zergpool -Wallet 3FJxLvN1XTjN5zH78YMVDdPSNrTzN44DeB -APIUri http://api.zergpool.com:8080/api/walletEx?address=
