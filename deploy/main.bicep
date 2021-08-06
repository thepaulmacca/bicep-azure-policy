targetScope = 'subscription'

// PARAMETERS
@description('Environment name')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string
param policySource string = 'thepaulmacca/bicep-azure-policy'
param policyCategory string = 'Custom'
param assignmentEnforcementMode string = 'Default'
param listOfAllowedLocations array = [
  'uksouth'
  'ukwest'
]

// RESOURCES
// Deploy allowed locations policy
module allowedLocationsPolicy '../initiatives/allowedLocations/allowedLocations.bicep' = {
  name: 'allowedlocationspolicy-${environmentName}-${uniqueString(subscription().id)}'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    assignmentEnforcementMode: assignmentEnforcementMode
    listOfAllowedLocations: listOfAllowedLocations
  }
}
