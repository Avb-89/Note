 Get-GPO -All | ForEach-Object {
if ('S-1-5-11' -notin ($_ | Get-GPPermission -All).Trustee.Sid.Value) {
$_
}
} | Select DisplayName 
