$hostsList = @(Get-ADComputer -Filter{
OperatingSystem -like '*Server*'
-and Name -notlike '*MS-DB*'
-and Name -notlike '*MS-CS*'
-and Name -notlike '*MS-AP02*'
-and Name -notlike '*MS-AP03*'
} -Properties * | Select-Object -ExpandProperty Name)
ForEach($computer in  $hostsList){
$filter = 'Address="{0}" and Timeout={1}' -f $computer, 500 ## $computer - Hostname, 500 - ping timeout
$availabilityCheck = Get-CimInstance -ClassName Win32_PingStatus -Filter $Filter #check online/ping
if(($availabilityCheck.StatusCode)-eq 0){
    Write-Host "$computer online" -f DarkGreen}
        else{Write-Host "$computer offline" -f Red}}
