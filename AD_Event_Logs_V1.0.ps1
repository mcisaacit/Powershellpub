<#PSScriptInfo
.DESCRIPTION 
 Gather event logs whilst logged onto domain controller
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
 
#>
$Daterange = 7
$Todaysdate = get-date
$Startdate = $Todaysdate.adddays(-$Daterange)
$outpath = "C:\logs\"
$createpath = Test-path $outpath
if ($createpath -eq $true)
    {
    write-host "'Continue'"
    }
elseif ($createpath -eq $false)
    {
    new-item -path $outpath -ItemType Directory
    }
$EVentrytype = "Error","Warning"
$EVdata = @(@{label="Logged";expression = {[string]$_.timewritten}},"EntryType","Source","EventID",@{label="Description";expression = {[string]$_.message}})
$EVlogs = "Application","System","Active Directory Web Services","DFS Replication","Directory Service","DNS Server"

foreach ($elog in $EVlogs)
    {
    Get-EventLog -LogName $elog -After $Startdate -EntryType $EVentrytype|select-object $EVdata|export-csv ($outpath + "EVLog_" + $elog + ".csv")
    start-sleep -s 20
    }