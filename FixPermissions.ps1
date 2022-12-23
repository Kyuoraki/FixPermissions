$hostsList = @(Get-ADComputer -Filter {
Name -like "*MS-W*" -and
Name -notlike "MS-W031" -and
Name -notlike "MS-W033" -and
Name -notlike "MS-W100" -or 
Name -like "*MS-RD*"
} -Properties *| Sort Name | Select-Object -ExpandProperty Name) #get hostList of pc & terminal
foreach ($computer in  $hostsList) {
    $filter = 'Address="{0}" and Timeout={1}' -f $computer, 500 ## $computer - Hostname, 500 - ping timeout
    $availabilityCheck = Get-CimInstance -ClassName Win32_PingStatus -Filter $Filter #check online/ping
    if ( ($availabilityCheck.StatusCode) -eq 0 ) {
        ssh n.bobrov@$computer -p 33 powershell.exe -command "hostname;powershell -file 'C:\Program Files\OpenSSH\FixHostFilePermissions.ps1';powershell -file 'C:\Program Files\OpenSSH\FixUserFilePermissions.ps1'" | Out-File "C:\Fix\log.txt" -Force -Append
    }else{
        $foreach.MoveNext() | Out-Null
    }
}
