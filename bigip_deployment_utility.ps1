### Connect to Azure Subscription
Login-AzureRmAccount
Set-AzureSubscription  -SubscriptionId 2c21b548-88aa-459e-813f-056d0d2ec8a7
clear

########### Parameters #############
$RGName = "bigip2"
$vmName = "bigip"
$dnsPrefix = "gcbigip2"
$deployName = $RGName
$location ="West US"
$TemplateFile="C:\Users\grego_000\Documents\ARM\bigipdeploy.json"
$ParameterFile="C:\Users\grego_000\Documents\ARM\bigipdeploy.parameters.json"


### Read the values from the parameters file and create a hashtable. Do this if needed to modify parameters.
### otherwise we could pass the file directly to New-AzureResourceGroupDeployment.
$parameters = New-Object -TypeName hashtable
$jsonContent = Get-Content $ParameterFile -Raw | ConvertFrom-Json
$jsonContent.parameterValues | Get-Member -Type NoteProperty | ForEach-Object {
   $parameters.Add($_.Name, $jsonContent.parameterValues.($_.Name))
}

### Set the msdeployPackageUri parameter to the URL of the package. This is referenced in the template file.
$parameters.f5publicDnsName = $dnsPrefix
$parameters.bigipName = $vmName

### create resource group
New-AzureRmResourceGroup -Name $RGName -Location $location

### deploy webserver and bigip
New-AzureRMResourceGroupDeployment -Name $deployName -ResourceGroupName $RGName -TemplateFile $TemplateFile -TemplateParameterObject $parameters
write-host '############### ' $vmName ' has been deployed. ##############'