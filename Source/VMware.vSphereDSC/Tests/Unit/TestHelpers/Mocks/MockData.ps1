<#
Copyright (c) 2018 VMware, Inc.  All rights reserved

The BSD-2 license (the "License") set forth below applies to all parts of the Desired State Configuration Resources for VMware project.  You may not use this file except in compliance with the License.

BSD-2 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>

$script:constants = @{
    VIServerName = 'TestServer'
    VIServerUser = 'TestUser'
    VIServerPassword = 'TestPassword' | ConvertTo-SecureString -AsPlainText -Force
    InventoryItemName = 'TestInventoryItem'
    FolderType = 'Folder'
    DatacenterType = 'Datacenter'
    ResourcePoolType = 'Resource Pool'
    RootFolderValue = 'group-d1'
    InventoryRootFolderId = 'Folder-group-d1'
    InventoryRootFolderName = 'Datacenters'
    DatacenterLocationItemOneId = 'my-datacenter-folder-one-id'
    DatacenterLocationItemOne = 'MyDatacenterFolderOne'
    DatacenterLocationItemTwoId = 'my-datacenter-folder-two-id'
    DatacenterLocationItemTwo = 'MyDatacenterFolderTwo'
    DatacenterLocationItemThree = 'MyDatacenterFolderThree'
    DatacenterId = 'my-datacenter-inventory-root-folder-parent-id'
    DatacenterName = 'MyDatacenter'
    DatacenterHostFolderId = 'group-h4'
    DatacenterHostFolderName = 'HostFolder'
    InventoryItemLocationItemOneId = 'my-inventory-item-location-item-one'
    InventoryItemLocationItemOne = 'MyInventoryItemOne'
    InventoryItemLocationItemTwoId = 'my-inventory-item-location-item-two'
    InventoryItemLocationItemTwo = 'MyInventoryItemTwo'
    ResourcePoolId = 'my-resource-pool-id'
    ResourcePoolName = 'MyResourcePool'
    ClusterId = 'my-cluster-id'
    ClusterName = 'MyCluster'
    HAEnabled = $true
    HAAdmissionControlEnabled = $true
    HAFailoverLevel = 4
    HAIsolationResponse = 'DoNothing'
    HARestartPriority = 'High'
    DrsEnabled = $true
    DrsAutomationLevel = 'FullyAutomated'
    DrsMigrationThreshold = 5
    DrsDistribution = 0
    MemoryLoadBalancing = 100
    CPUOverCommitment = 500
}

$script:credential = New-Object System.Management.Automation.PSCredential($script:constants.VIServerUser, $script:constants.VIServerPassword)

$script:viServer = [VMware.VimAutomation.ViCore.Impl.V1.VIServerImpl] @{
    Name = $script:constants.VIServerName
    User = $script:constants.VIServerUser
    ExtensionData = [VMware.Vim.ServiceInstance] @{
        Content = [VMware.Vim.ServiceContent] @{
            RootFolder = [VMware.Vim.ManagedObjectReference] @{
                Type = $script:constants.FolderType
                Value = $script:constants.RootFolderValue
            }
        }
    }
}

$script:rootFolderViewBaseObject = [VMware.Vim.Folder] @{
    Name = $script:constants.InventoryRootFolderName
    MoRef = [VMware.Vim.ManagedObjectReference] @{
        Type = $script:constants.FolderType
        Value = $script:constants.RootFolderValue
    }
    ChildEntity = @(
        [VMware.Vim.ManagedObjectReference] @{
            Type = $script:constants.FolderType
            Value = $script:constants.DatacenterLocationItemOne
        }
    )
}

$script:inventoryRootFolder = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
    Id = $script:constants.InventoryRootFolderId
    Name = $script:constants.InventoryRootFolderName
    ExtensionData = [VMware.Vim.Folder] @{
        ChildEntity = @(
            [VMware.Vim.ManagedObjectReference] @{
                Type = $script:constants.FolderType
                Value = $script:constants.DatacenterLocationItemOne
            },
            [VMware.Vim.ManagedObjectReference] @{
                Type = $script:constants.DatacenterType
                Value = $script:constants.DatacenterName
            }
        )
    }
}

$script:datacenterLocationItemOne = [VMware.Vim.Folder] @{
    Name = $script:constants.DatacenterLocationItemOne
    ChildEntity = @(
        [VMware.Vim.ManagedObjectReference] @{
            Type = $script:constants.FolderType
            Value = $script:constants.DatacenterLocationItemTwo
        }
    )
}

$script:datacenterLocationItemTwo = [VMware.Vim.Folder] @{
    Name = $script:constants.DatacenterLocationItemTwo
    ChildEntity = @(
        [VMware.Vim.ManagedObjectReference] @{
            Type = $script:constants.FolderType
            Value = $script:constants.DatacenterLocationItemThree
        }
    )
    MoRef = [VMware.Vim.ManagedObjectReference] @{
        Type = $script:constants.FolderType
        Value = $script:constants.DatacenterLocationItemTwoId
    }
}

$script:datacenterLocationItemThree = [VMware.Vim.Folder] @{
    Name = $script:constants.DatacenterLocationItemThree
}

$script:datacenterChildEntity = [VMware.Vim.Datacenter] @{
    Name = $script:constants.DatacenterName
}

$script:locationDatacenterLocationItemOne = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
    Id = $script:constants.DatacenterLocationItemOneId
    Name = $script:constants.DatacenterLocationItemOne
    ParentId = $script:constants.InventoryRootFolderId
}

$script:locationDatacenterLocationItemTwo = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
    Id = $script:constants.DatacenterLocationItemTwoId
    Name = $script:constants.DatacenterLocationItemTwo
    ParentId = $script:constants.DatacenterLocationItemOneId
}

$script:datacenterWithInventoryRootFolderAsParent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.DatacenterImpl] @{
    Id = $script:constants.DatacenterId
    Name = $script:constants.DatacenterName
    ParentFolderId = $script:constants.InventoryRootFolderId
}

$script:datacenterWithDatacenterLocationItemOneAsParent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.DatacenterImpl] @{
    Id = $script:constants.DatacenterId
    Name = $script:constants.DatacenterName
    ParentFolderId = $script:constants.DatacenterLocationItemOneId
    ExtensionData = [VMware.Vim.Datacenter] @{
        HostFolder = [VMware.Vim.ManagedObjectReference] @{
            Type = $script:constants.FolderType
            Value = $script:constants.DatacenterHostFolderId
        }
    }
}

$script:datacenterWithDatacenterLocationItemTwoAsParent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.DatacenterImpl] @{
    Id = $script:constants.DatacenterId
    Name = $script:constants.DatacenterName
    ParentFolderId = $script:constants.DatacenterLocationItemTwoId
}

$script:datacenterHostFolderViewBaseObject = [VMware.Vim.Folder] @{
    Name = $script:constants.DatacenterHostFolderName
    MoRef = [VMware.Vim.ManagedObjectReference] @{
        Type = $script:constants.FolderType
        Value = $script:constants.DatacenterHostFolderId
    }
}

$script:datacenterHostFolder = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
    Id = $script:constants.DatacenterHostFolderId
    Name = $script:constants.DatacenterHostFolderName
    Parent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.DatacenterImpl] @{
        Name = $script:constants.DatacenterName
    }
}

$script:inventoryItemLocationItemOne = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
    Id = $script:constants.InventoryItemLocationItemOneId
    Name = $script:constants.InventoryItemLocationItemOne
    ParentId = $script:constants.DatacenterHostFolderId
}

$script:foundLocations = @(
    [VMware.VimAutomation.ViCore.Impl.V1.Inventory.ResourcePoolImpl] @{
        Id = $script:constants.InventoryItemLocationItemTwoId
        Name = $script:constants.InventoryItemLocationItemTwo
        Parent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
            Id = $script:constants.InventoryItemLocationItemOneId
            Name = $script:constants.InventoryItemLocationItemOne
        }
    }
)

$script:foundLocationsForCluster = @(
    [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
        Id = $script:constants.InventoryItemLocationItemTwoId
        Name = $script:constants.InventoryItemLocationItemTwo
        Parent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl] @{
            Id = $script:constants.InventoryItemLocationItemOneId
            Name = $script:constants.InventoryItemLocationItemOne
        }
        ExtensionData = [VMware.Vim.Folder] @{
            Name = $script:constants.InventoryItemLocationItemTwo
            MoRef = [VMware.Vim.ManagedObjectReference] @{
                Type = $script:constants.FolderType
                Value = $script:constants.InventoryItemLocationItemTwoId
            }
        }
    }
)

$script:inventoryItemLocationViewBaseObject = [VMware.Vim.ResourcePool] @{
    Name = $script:constants.InventoryItemLocationItemTwo
    Parent = [VMware.Vim.ManagedObjectReference] @{
        Type = $script:constants.ResourcePoolType
        Value = $script:constants.InventoryItemLocationItemOneId
    }
}

$script:inventoryItemLocationWithDatacenterHostFolderAsParent = [VMware.Vim.Folder] @{
    Name = $script:constants.DatacenterHostFolderName
    Parent = [VMware.Vim.ManagedObjectReference] @{
        Type = $script:constants.FolderType
        Value = $script:constants.DatacenterHostFolderId
    }
}

$script:inventoryItemLocationWithInventoryItemLocationItemOneAsParent = [VMware.Vim.Folder] @{
    Name = $script:constants.InventoryItemLocationItemOne
    Parent = [VMware.Vim.ManagedObjectReference] @{
        Type = $script:constants.FolderType
        Value = $script:constants.InventoryItemLocationItemOneId
    }
}

$script:inventoryItemWithInventoryItemLocationItemTwoAsParent = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.ResourcePoolImpl] @{
    Id = $script:constants.ResourcePoolId
    Name = $script:constants.ResourcePoolName
    ParentId = $script:constants.InventoryItemLocationItemTwoId
}

$script:cluster = [VMware.VimAutomation.ViCore.Impl.V1.Inventory.ClusterImpl] @{
    Id = $script:constants.ClusterId
    Name = $script:constants.ClusterName
    ParentId = $script:constants.InventoryItemLocationItemTwoId
    HAEnabled = $script:constants.HAEnabled
    HAAdmissionControlEnabled = $script:constants.HAAdmissionControlEnabled
    HAFailoverLevel = $script:constants.HAFailoverLevel
    HAIsolationResponse = $script:constants.HAIsolationResponse
    HARestartPriority = $script:constants.HARestartPriority
    ExtensionData = [VMware.Vim.ClusterComputeResource] @{
        ConfigurationEx = [VMware.Vim.ClusterConfigInfoEx] @{
            DrsConfig = [VMware.Vim.ClusterDrsConfigInfo] @{
                Enabled = $true
                DefaultVmBehavior = 'Manual'
                VmotionRate = 3
                Option = @(
                    [VMware.Vim.OptionValue] @{
                        Key = 'LimitVMsPerESXHostPercent'
                        Value = '10'
                    },
                    [VMware.Vim.OptionValue] @{
                        Key = 'PercentIdleMBInMemDemand'
                        Value = '200'
                    },
                    [VMware.Vim.OptionValue] @{
                        Key = 'MaxVcpusPerClusterPct'
                        Value = '400'
                    }
                )
            }
        }
    }
}

$script:clusterSpecWithoutDrsSettings = [VMware.Vim.ClusterConfigSpecEx] @{
    DrsConfig = [VMware.Vim.ClusterDrsConfigInfo] @{
        Option = @(
        )
    }
}

$script:clusterSpecWithDrsSettings = [VMware.Vim.ClusterConfigSpecEx] @{
    DrsConfig = [VMware.Vim.ClusterDrsConfigInfo] @{
        Enabled = $script:constants.DrsEnabled
        DefaultVmBehavior = $script:constants.DrsAutomationLevel
        VmotionRate = $script:constants.DrsMigrationThreshold
        Option = @(
            [VMware.Vim.OptionValue] @{
                Key = 'LimitVMsPerESXHostPercent'
                Value = ($script:constants.DrsDistribution).ToString()
            },
            [VMware.Vim.OptionValue] @{
                Key = 'PercentIdleMBInMemDemand'
                Value = ($script:constants.MemoryLoadBalancing).ToString()
            },
            [VMware.Vim.OptionValue] @{
                Key = 'MaxVcpusPerClusterPct'
                Value = ($script:constants.CPUOverCommitment).ToString()
            }
        )
    }
}

$script:clusterComputeResource = [VMware.Vim.ClusterComputeResource] @{
    ConfigurationEx = [VMware.Vim.ClusterConfigInfoEx] @{
        DrsConfig = [VMware.Vim.ClusterDrsConfigInfo] @{
            Enabled = $true
            DefaultVmBehavior = 'Manual'
            VmotionRate = 3
            Option = @(
                [VMware.Vim.OptionValue] @{
                    Key = 'LimitVMsPerESXHostPercent'
                    Value = '10'
                },
                [VMware.Vim.OptionValue] @{
                    Key = 'PercentIdleMBInMemDemand'
                    Value = '200'
                },
                [VMware.Vim.OptionValue] @{
                    Key = 'MaxVcpusPerClusterPct'
                    Value = '400'
                }
            )
        }
    }
}
