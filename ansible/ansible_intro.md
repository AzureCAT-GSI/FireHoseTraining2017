# Pre-requisites:

1. Have Docker installed. You can download it [here](https://docs.docker.com/engine/installation/#supported-platforms)
2. Have an Azure Service Principal (you will need: SubscriptionId, TenantId, ClientId and ClientSecret) You can find the instructions to create one [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal)

# Tutorial
1. First thing we need to do is to get a Docker image with Ansible installed:

       docker pull claudh9/ansiblecentos:latest

2. Now we want to run the image and use an interactive terminal to interact with it 

       docker run -it claudh9/ansiblecentos:latest bash

3. Once inside the container we need to provide our Azure Credentials. Run the following lines inside the container to set the environment variables.

       export AZURE_SUBSCRIPTION_ID='Your-Subscription-Id'
       export AZURE_TENANT='Your-Tenant-Id'
       export AZURE_CLIENT_ID='Your-Client-Id'
       export AZURE_SECRET='Your-CLient-Secret'

4. The container has two Ansible playbooks in the /pb directory, one to deploy a VM using an ARM template (azurerm.yml) and another one to deploy a VM "from the ground up" using Ansible (azurevm.yml)

Using nano open azurerm.eyaml, you can see it references an ARM Template on GitHub and defines the Template parameters.

    nano azurerm.eyaml

Run the following line to deploy the VM to your subscription:

    ansible-playbook azurerm.eyaml

5. Now we can explore the playbook that builds everything from the ground up. It actually defines all the different resources needed to create a VM in Azure.
For this part, it's important to go into the template, and change the StorageAccountName, as they have to be unique across all Azure subscriptions. It has to be changed both in the storage account and VM definition. 

       nano azurevm.eyaml

Once you do, you can run the following command to make the deployment to Azure.

    ansible-playbook azurevm.eyaml
