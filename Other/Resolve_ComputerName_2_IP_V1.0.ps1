<#PSScriptInfo
.DESCRIPTION 
 Resolve computer names to IP address.
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
 Requires AD module to be avaliable. 
.RELEASENOTES
 Tested on Windows Server 2012 R2
#>
$comp =@();$rep =@();$cp =@()#Declare empty arrays
$IPNull = "N/A"
$PingSuccess ="Online"
$PingnonSuccess ="Offline"
$comp = Get-ADComputer -Filter * |Where-Object {$_.enabled -eq $true}|select DNSHostName
foreach ($cp in $comp)
    {#Loop through each computer found
        $t=@()
        $catcherror=@()
        $t= Test-Connection -ComputerName $cp.DNSHostName -Count 1 -ErrorAction SilentlyContinue -ErrorVariable CatchError
        if ([string]::IsNullOrEmpty($catcherror))
            {#Test Connection received reply. Write IP to csv
            write-host "null"
            $rep += $t|select @{Name="Computer";exp={[string]$_.Address}},IPv4Address,ipv6address,@{Name="Status";exp={[string]$PingSuccess}}
            }
        else
            {#Write error to csv
            write-host "not null"
            $rep += $cp|select @{Name="Computer";exp={$cp.DNSHostName}},@{Name="IPv4Address";exp={[string]$IPNull}},@{Name="IPv6Address";exp={[string]$IPNull}},@{Name="Status";exp={[string]$PingnonSuccess}}
            }   
    }
$rep|export-csv -NoTypeInformation C:\computer_2_ip_report.csv