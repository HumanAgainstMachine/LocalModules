# LocalModules PowerShell Module

## Overview

**LocalModules** simplifies the installation of PowerShell modules under development on your local machine that are not yet ready for publishing, streamlining the development and testing process.

The minimal file structure for a PowerShell module in development is as follows:

    DevModulesFolder/
    |_ _ DevModuleName/          # Folder containing the module files
         |_ _ DevModuleName.psm1 # Module script file.


## Features

- Creates and manages a local repository behind the scene (`Developing`).
- Generates a minimal module manifest if one is not already provided.
- Removes all traces of the previously installed version before installing the latest edited version.
- Lists only installed development modules.

## Prerequisites

- PowerShell 5.1 or later.
- Administrator privileges may be required for certain actions.

## Installation

Install **LocalModules** from [Powershell Gallery](https://www.powershellgallery.com/packages/LocalModules).

```powershell
Install-Module -Name LocalModules
```

## Usage

### Configuration

Before using `LocalModules`, configure the path to the folder containing your development modules:

1. Locate the configuration file:
   ```powershell
   $env:APPDATA\LocalModules\config.json
   ```
2. Edit `config.json` and specify the folder containing your modules:
   ```json
   {
     "DevModulesPath": "C:\\Path\\To\\Your\\Development\\Modules"
   }
   ```

### Cmdlets

 1. Install a module from your development path:
```powershell
Install-DevModule -Name "DevModuleName"
```


2. List all modules installed from `Developing` repository:
```powershell
Get-InstalledDevModule
```

## Notes

This module is inspired by [Marc-André Moreau's article](https://blog.devolutions.net/2021/03/local-powershell-module-repository-no-server-required) on setting up a local PowerShell repository.


## Contribution

Feel free to contribute by submitting issues or pull requests to improve functionality and documentation.