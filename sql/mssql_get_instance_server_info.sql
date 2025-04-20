SELECT 
    SERVERPROPERTY('MachineName') AS HostName,
    SERVERPROPERTY('ServerName') AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('IsClustered') AS IsClustered,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS PhysicalComputerName,
    SERVERPROPERTY('EngineEdition') AS EngineEdition;
