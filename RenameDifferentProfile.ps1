$hostUsersSIDs = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-21-574784187-2233042446-2247385851-*' -Name #получение (AD) сидов из реестра 
$excludeList="" # здесь должны быть сиды для исключения из списка
foreach ($item in $excludeList) { 
    $hostUsersSIDs = $hostUsersSIDs.Where{$_ -ne $item}} # исключение сидов из списка
$hostUsersSIDs # остались нужные сиды
foreach ($item in $hostUsersSIDs) { 
    $getADName=(Get-AdUser -Identity $item).'SamAccountName' # получение имени юзера по сиду из AD
    $nameSids=(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$item").ProfileImagePath #путь профиля юзера по сиду в реестре
    $nameSids=$nameSids.Trim("C:\Users\") # папка профиля
    if($getADName -ne $nameSids){
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$item" -Name ProfileImagePath -Value "C:\Users\$getADName" # задан путь профиля из AD
        Rename-Item -Path "C:\Users\$nameSids" -NewName $getADName # задана папка профиля из AD
        echo "$nameSids now is $getADName"
    }else{echo "$nameSids is alright"}
}
Write-Host ″Press any key to continue … or Ctrl+C to abort″
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
