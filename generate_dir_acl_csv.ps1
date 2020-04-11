$InputPath = "C:\Users\ray\Desktop"
$OutputFile = "C:\Users\ray\Desktop\powershell\ACLs.csv"

$Items = (Get-ChildItem $InputPath -Recurse -Force | Where { $_.PSIsContainer } | select fullname | %{$_.fullname.trim()})
#$Items = (Get-ChildItem $InputPath -Recurse -Force | select fullname | %{$_.fullname.trim()})

$Table = @()
$Record = [ordered]@{
  "Directory" = ""
  "Owner" = ""
  "FileSystemRights" = ""
  "AccessControlType" = ""
  "IdentityReference" = ""
  "IsInherited" = ""
  "InheritanceFlags" = ""
  "PropagationFlags" = ""
}

Foreach ($Item in $Items)
{

  $ACL = (Get-Acl -Path $Item)

  $Record."Directory" = $ACL.path | %{$_.trimstart("Microsoft.PowerShell.Core\FileSystem::")}
  $Record."Owner" = $ACL.Owner

  Foreach ($SItem in $ACL.access)
  {
    $Record."FileSystemRights" = $SItem.FileSystemRights
    $Record."AccessControlType" = $SItem.AccessControlType
    $Record."IdentityReference" = $SItem.IdentityReference
    $Record."IsInherited" = $SItem.IsInherited
    $Record."InheritanceFlags" = $SItem.InheritanceFlags
    $Record."PropagationFlags" = $SItem.PropagationFlags


    $objRecord = New-Object PSObject -property $Record
    $Table += $objrecord
  }

  # Add empty row after processing each directory
  $Table += New-Object PSObject -property @{}
}

$Table | Export-Csv -Path $OutputFile -NoTypeInformation

Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
