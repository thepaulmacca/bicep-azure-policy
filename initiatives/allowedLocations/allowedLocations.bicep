targetScope = 'subscription'

// Parameters
param policySource string
param policyCategory string
param assignmentEnforcementMode string
param listOfAllowedLocations array

// Variables
var initiative1Name = 'allowedLocations'
var initiative1DisplayName = 'Allowed Locations'
var assignment1Name = 'allowedLocations'
var assignment1DisplayName = 'Allowed Locations'

// RESOURCES
resource initiative1 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: initiative1Name
  properties: {
    policyType: 'Custom'
    displayName: initiative1DisplayName
    description: '${initiative1Name} via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        metadata: ({
          description: 'The List of Allowed Locations for Resource Groups and Resources.'
          strongtype: 'location'
          displayName: 'Allowed Locations'
        })
      }
    }
    policyDefinitions: [
      {
        //Allowed locations
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'listOfAllowedLocations\')]'
          }
        }
      }
      {
        //Allowed locations for resource groups
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'listOfAllowedLocations\')]'
          }
        }
      }
    ]
  }
}

resource assignment1 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: assignment1Name
  properties: {
    displayName: assignment1DisplayName
    policyDefinitionId: initiative1.id
    notScopes: [
      '/subscriptions/54b7b0cf-a59e-4c8b-b51f-3283bf778a15/resourceGroups/cloud-shell-storage-westeurope'
      '/subscriptions/54b7b0cf-a59e-4c8b-b51f-3283bf778a15/resourceGroups/NetworkWatcherRG'
    ]
    parameters: {
      listOfAllowedLocations: {
        value: listOfAllowedLocations
      }
    }
    description: '${assignment1Name} via ${policySource}'
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    enforcementMode: assignmentEnforcementMode
    nonComplianceMessages: [
      {
        message: 'Resource or Resource Group is not in an allowed location'
      }
    ]
  }
}

// Outputs
output initiative1ID string = initiative1.id
output assignment1ID string = assignment1.id
