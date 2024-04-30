LSRPCore = {}
LSRPCore.Config = LSRPConfig
LSRPCore.Shared = LSRPShared
LSRPCore.ClientCallbacks = {}
LSRPCore.ServerCallbacks = {}

exports('GetCoreObject', function()
    return LSRPCore
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local LSRPCore = exports['lsrp-core']:GetCoreObject()
