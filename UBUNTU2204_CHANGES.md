# Ubuntu2204 Support for Azure Kubernetes Service (AKS)

This document summarizes the changes made to add Ubuntu2204 support to the Azure Kubernetes Service (AKS) resources in the Terraform AzureRM provider.

## Overview

Ubuntu2204 (Ubuntu 22.04 LTS) is now supported by Azure AKS as confirmed by Microsoft documentation. This change adds support for the `Ubuntu2204` OS SKU to both the main Kubernetes cluster resource and node pool resources.

## Changes Made

### 1. Core Resource Files

#### `/internal/services/containers/kubernetes_cluster_node_pool_resource.go`
- **Line 265**: Added `"Ubuntu2204", // Ubuntu 22.04 LTS` to the validation list for `os_sku`
- **Lines 926-947**: Updated validation logic for in-place updates to include Ubuntu2204 as a valid option alongside Ubuntu and AzureLinux

#### `/internal/services/containers/kubernetes_nodepool.go`
- **Line 184**: Added `"Ubuntu2204", // Ubuntu 22.04 LTS` to the validation list for `os_sku` in the default node pool schema

#### `/internal/services/containers/kubernetes_cluster_resource.go`
- **Lines 2421-2442**: Updated validation logic for default node pool os_sku changes to include Ubuntu2204 as a valid option for in-place updates

### 2. Test Files

#### `/internal/services/containers/kubernetes_cluster_other_resource_test.go`
- **Lines 738-745**: Added test step for Ubuntu2204 in the `TestAccKubernetesCluster_osSkuUpdate` function

#### `/internal/services/containers/kubernetes_cluster_node_pool_resource_test.go`
- **Lines 787-800**: Added new test function `TestAccKubernetesClusterNodePool_osSkuUbuntu2204`

### 3. Documentation

#### `/website/docs/r/kubernetes_cluster.html.markdown`
- **Line 411**: Updated documentation to include `Ubuntu2204` in the list of possible values
- Updated the description to clarify that changes between `AzureLinux`, `Ubuntu`, or `Ubuntu2204` will not replace the resource

#### `/website/docs/r/kubernetes_cluster_node_pool.html.markdown`
- **Line 125**: Updated documentation to include `Ubuntu2204` in the list of possible values
- Updated the description to clarify that changes between `AzureLinux`, `Ubuntu`, or `Ubuntu2204` will not replace the resource

## Technical Details

### Validation Logic
The changes ensure that:
1. `Ubuntu2204` is accepted as a valid value for the `os_sku` parameter
2. In-place updates are supported when changing between `Ubuntu`, `Ubuntu2204`, and `AzureLinux`
3. Changes to/from Windows SKUs still require resource recreation (cycling)

### Backward Compatibility
- All existing functionality remains unchanged
- Existing configurations using `Ubuntu` continue to work
- The default behavior (when `os_sku` is not specified) remains `Ubuntu` for Linux nodes

### Azure API Support
According to Microsoft documentation, Ubuntu2204 is supported in Kubernetes versions 1.25 to 1.33, making it suitable for current AKS deployments.

## Testing
- Added comprehensive test coverage for Ubuntu2204 in both cluster and node pool scenarios
- Tests verify that the new OS SKU can be set and updated correctly
- Integration with existing test suites ensures no regression

## Impact
This change allows users to:
1. Specify `os_sku = "Ubuntu2204"` in their Terraform configurations
2. Perform in-place updates between Ubuntu variants and AzureLinux
3. Use Ubuntu 22.04 LTS for enhanced security and newer kernel features

The implementation follows the existing patterns in the codebase and maintains consistency with how other OS SKUs are handled.