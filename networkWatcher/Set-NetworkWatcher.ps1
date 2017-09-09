
param
(
       # Provide NetworkWatcher ResourceId
    [Parameter(Mandatory=$False,ParameterSetName='default')]
     [string]$NWID,

    # Provide StorageAccount ResourceId
    [Parameter(Mandatory=$False,ParameterSetName='default')]
    [string]$SAID,

      # Provide the region you want to set NetworkWatcher for
    [Parameter(Mandatory=$False,ParameterSetName='default')]
    [string]$Region
)

function Set-NetworkWatcher (
    [Parameter(Mandatory=$True)]
    [array]$NSGs
    
    )
{
   
    foreach($NSG in $NSGs) 
    {
       if ($Region -eq $NSG.Location){
       $NW1 = Get-AzureRMResource -ResourceId $NWID
       $NetworkWatcher = Get-AzureRmNetworkWatcher -Name $NW1.ResourceName -ResourceGroupName $NW1.ResourceGroupName

       Set-AzureRmNetworkWatcherConfigFlowLog -NetworkWatcher $NetworkWatcher -TargetResourceId $NSG.ResourceId -StorageAccountId $SAID -EnableFlowLog $True -EnableRetention $True -RetentionInDays 1
        }
        else{
        Write-Host $NSG.Name "did not match region"
        }
    }
}

$NSGs =  Find-AzureRmResource -ResourceType Microsoft.Network/NetworkSecurityGroups
Set-NetworkWatcher -NSGs $NSGs


