<#
.NOTES
===========================================================================
       
Created on:        26/07/2019
Created by:        Kajal Sacheti [kajal.sacheti@wipro.com]
Organization:      Wipro
Filename:          Add an Attachment to a record in Service now
Version:           2.0
===========================================================================

.SYNOPSIS
    
     This Script will add any attachment to the record.


.INPUTS

    We need to pass a few parameters like InstanceName, path of fileToattach, table name & sysid of the record.


.OUTPUTS
    
    The script will attach the file in the record in Service Now.
    
#>


Function Add_Attachment{

#Script Path
$ScriptPath = $PSScriptRoot

#Read the jsonfile
$jsonfile = Get-Content "$ScriptPath\config.json" | ConvertFrom-Json

# Eg. User name="admin", Password="admin" for this code sample.
$user = $jsonfile.username
$pass = $jsonfile.password

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')
$headers.Add('Content-Type','text/plain')

#Instance Name
$Instance_name = $jsonfile.InstanceName

#Parameters from the json
$fileToattach = $jsonfile.fileToAttach
$sys_id = $jsonfile.sys_id_record
$table_name = $jsonfile.table_name
$file_name = "test.txt"

#$sys_id = "c286d61347c12200e0ef563dbb9a71df"

# Specify endpoint uri
$uri = "$Instance_name/api/now/attachment?sysparm_query=table_sys_id%3D$sys_id&sysparm_limit=1"

# Specify HTTP method
$method = "get"

# Send HTTP request
$response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri 

# Print response
$result = $response.content | ConvertFrom-Json
$result.result

if($($result.result) -eq $null){
    Write-Host "No attachment is there.. Adding an attachment now.."
        $method_post = "POST"
        $uri_to_attach = "$Instance_name/api/now/attachment/file?table_name=$table_name&table_sys_id=$sys_id&file_name=$file_name"
        
        # Send HTTP request
        $response = Invoke-WebRequest -Headers $headers -Method $method_post -Uri $uri_to_attach -ContentType "multipart/form-data" -InFile $fileToattach
        #$Err
        #$response
}
else{
    Write-Host "Attachment exists"
}


}
Add_Attachment