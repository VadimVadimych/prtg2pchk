# Powershell script to trigger PRTG alerts in Pachka messenger 

# Notes
# Copy the line below (exluding the hash) into the parameters field in the PRTG notification template
# '%probe' '%device' '%sensor' '%group' '%home' '%host' '%status' '%colorofstate' '%down' '%priority' '%message' '%datetime'

# Ingest the alert payload from PRTG
Param(
    [string]$probe,
    [string]$device,
    [string]$sensor,
    [string]$group,
    [string]$prtg_home,
    [string]$prtg_host,
    [string]$status,
    [string]$colorofstate,
    [string]$down,
    [string]$priority,
    [string]$message,
    [string]$datetime
)



# Determine the Severity
switch ($colorofstate) {
    "#b4cc38"	{ $Severity = "info" }
    "#ffcb05"	{ $Severity = "warning" }
    "#808282"	{ $Severity ="unknown"}
    "#d71920"	{ $Severity = "critical" }
    default { $Severity = "critical" }
}


$Url = "<here Webhook URL from Pachka (Пачка)>"



$AlertPayload = [ordered]@{
            prtg_server  = $prtg_home
            probe        = $probe
            group        = $group
            device       = $device
            sensor       = $sensor
            status       = $status
	        url          = $prtg_host
            severity     = $Severity
            down         = $down
            priority     = $priority
            message      = $message
            datetime     = $datetime
            
        }

# Convert Events Payload to JSON

$json = ConvertTo-Json -InputObject $AlertPayload

$logEvents = "C:\Temp\prtg2pchk.log"

# Send to Pachka and Log Results

$LogMtx = New-Object System.Threading.Mutex($False, "LogMtx")
$LogMtx.WaitOne() | Out-Null

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"
try {
    Invoke-RestMethod	-Method Post `
        -ContentType "application/json" `
        -Body $json `
        -Uri $Url `
    | Out-File $logEvents -Append
}

finally {
    $LogMtx.ReleaseMutex() | Out-Null
}
