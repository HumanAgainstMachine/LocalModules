#
# Module manifest for 'LocalModules'
#
# Generated by: Human.Against.Machine
#
# Generated on: 23/06/2024
#

@{

# Script module or binary module file associated with this manifest.
RootModule = '.\LocalModules.psm1'

# Version number of this module.
ModuleVersion = '2.0.1'

# Supported PSEditions
CompatiblePSEditions = @('Core')

# ID used to uniquely identify this module
GUID = '0013d4ee-4b5f-4bed-b54d-69b9b56ab8d9'

# Author of this module
Author = 'Human.Against.Machine'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) Human.Against.Machine. All rights reserved.'

# Description of the functionality provided by this module
Description = @'
LocalModules simplifies the installation of PowerShell modules under development.

LocalModules creates and manages a local repository named 'Developing' behind
the scenes, streamlining the installation process for modules in develompment.
'@

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '7.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Install-DevModule', 'Get-InstalledDevModule')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Powershell', 'DevOps', 'PackageManagement', 'Modules', 'PS', 'Local', 'Development')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/HumanAgainstMachine/LocalModules?tab=MIT-1-ov-file'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/HumanAgainstMachine/LocalModules'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = @'
[ver 2.0.1] - 2025-03-15
* Fix null object method call error
* Enhance console user messages
* Refactor code for clarity
* Support searching nested dev-module folders
* Add console message for multiple dev-modules

[ver 2.0.0] - 2025-03-13
- Breaking Changes
  * This release is not backward compatible with version 1.x.
  * The module has been completely redesigned for simplified usage and better maintainability.

[ver 1.0.1] - 2024-10-20
* Fix Get-LInstalledModule displaying non-installed local modules in certain cases.
* Fix Uninstall-LModule preventing the uninstallation of a local module when a repository version is present.
* Find workaround to PS session cache refresh

[ver 1.0.0] - 2024-10-20
* Improve vars and cmdlets names
* Improve manifest
* Under-development modules are now installed in a separate folder named 0.0.0 as they were version 0.0.0.
  Any configuration files outside the 0.0.0 folder will be preserved.

[ver 0.9.1] - 2024-07-01
Improve cmdlets Set-LocalRepo and Remove-LocalRepo

[ver 0.9.0] - 2024-06-23
Initial release
'@

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

