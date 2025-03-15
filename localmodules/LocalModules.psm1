<#
.SYNOPSIS
    LocalModules simplifies the installation of modules under development.

.DESCRIPTION
    LocalModules creates and manages a local repository named 'Developing' behind
    the scenes, streamlining the installation process for modules in develompment.

.NOTES
    Inspired by ideas and tips from the following article:
    "Local PowerShell Module Repository – No Server Required"
    Author: Marc-André Moreau
    Published: March 2021
    Source: https://blog.devolutions.net/2021/03/local-powershell-module-repository-no-server-required
#>

$moduleName = "LocalModules"

# Create module folder into roaming directory if not exist
New-Item -Path $env:APPDATA -Name "$ModuleName" -ItemType Directory -ErrorAction SilentlyContinue

# Set configuration file #
$configPath = Join-Path -Path $env:APPDATA -ChildPath $ModuleName 'config.json'
if (-not (Test-Path -Path $configPath -PathType Leaf)) {
    # Create an empty config.json file if not exist
    [PSCustomObject]@{DevModulesPath = ''} | ConvertTo-Json |
        Set-Content -Path $configPath -Encoding UTF8
}
# Import config.json
$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

function Test-Configuration {
    # Missing configuration value warning
    if (-not (Test-Path -Path $config.DevModulesPath -PathType Container)) {
        Write-Host "Missing or not valid configuration value for DevModulesPath`n" -ForegroundColor DarkYellow
        Write-Host "Edit the configuration file at $configPath and set the correct path to the folder containing your modules under development." -ForegroundColor DarkYellow
        Exit 67
    }
}

# Create DevRepository folder if not exist
$localRepoPath = Join-Path -Path $env:APPDATA -ChildPath $ModuleName 'DevelopingRepo'
New-Item -Path $localRepoPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# Register the local Developing repository
$parameters = @{
    Name = "Developing"
    SourceLocation = $localRepoPath
    InstallationPolicy = "Trusted"
    ErrorAction = "SilentlyContinue"
}
Register-PSRepository @parameters

function Install-DevModule {
    <#
    .SYNOPSIS
        Installs the specified module under development.

    .DESCRIPTION
        This cmdlet ensure a smooth installation by creating a minimal module manifest if missing,
        removing any traces of a previously installed version, and managing the local repository
        behind the scenes to install the latest modified version of the module under development.
    #>
    [CmdletBinding( DefaultParameterSetName='NameParameterSet',
                    SupportsShouldProcess=$true,
                    ConfirmImpact='Medium')]
    param(
        [Parameter( ParameterSetName='NameParameterSet',
                    Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Name})

    begin {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
                $PSBoundParameters['OutBuffer'] = 1
            }

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Install-Module', [System.Management.Automation.CommandTypes]::Function)

            # Set Developing as repository before calling Install-Module
            $PSBoundParameters += @{'Repository'= 'Developing'}

            $scriptCmd = {& $wrappedCmd @PSBoundParameters }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline()

            # START -----
            Test-Configuration

            $devModParentePath = $config.DevModulesPath
            $devModName = $Name

            # Search for dev-module(s)
            $devModItems =  Get-ChildItem -Path $devModParentePath -Directory -Recurse |
                            Where-Object { $_.Name -eq $devModName }

            $devModPaths = @()

            # Check each potential dev-module folder for the .psm1 file
            foreach ($folder in $devModItems) {
                $psmPath = Join-Path -Path $folder.FullName -ChildPath "$devModName.psm1"
                if (Test-Path -Path $psmPath -PathType Leaf) {
                    $devModPaths += $folder.FullName
                }
            }

            if ($devModPaths.Count -eq 1) {
                $devModulePath = $devModPaths[0]

                # Create minimal dev-module manifest if not exist
                $devManifestPath = Join-Path -Path $devModulePath -ChildPath "$devModName.psd1"
                if (-not (Test-Path -Path $devManifestPath)) {
                    $parameters = @{
                        Path = $devManifestPath
                        RootModule = ".\$devModName.psm1"
                        ModuleVersion = '0.0.1'
                        Author = "You Developer"
                        Description = "Default Dev minimal manifest"
                    }
                    New-ModuleManifest @parameters
                    Write-Host "Under-development module manifest is missing ..." -ForegroundColor DarkYellow
                    Write-Host "Minimal module manifest has been created" -ForegroundColor DarkYellow
                }

                # Unpublish (remove) from local repository previous dev-module if exist
                $publishedDevModule = Find-Module -Name $devModName -Repository Developing -ErrorAction SilentlyContinue
                if ($publishedDevModule) {
                    Remove-Item -Path (Join-Path $localRepoPath "$devModName.*.nupkg") -Force
                }

                # Publish to local repository current dev-module
                Publish-Module -Path $devModulePath -Repository Developing -WarningAction SilentlyContinue

                # Uninstall previous dev-module if installed
                Uninstall-Module -Name $devModName -ErrorAction SilentlyContinue
            }
            elseif ($devModPaths.Count -eq 0) {
                Write-Host "The under-development module $devModName was not found in $devModParentePath" -ForegroundColor DarkYellow
                return
            }
            elseif ($devModPaths.Count -gt 1) {
                Write-Host "Multiple under-development modules found:" -ForegroundColor DarkYellow
                $devModPaths
                return
            }
            # END -----

            $steppablePipeline.Begin($PSCmdlet)

        } catch {
            throw
        }
    }

    process {
        try {
            $steppablePipeline.Process($_)
        } catch {
            throw
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
            if ($devModPaths.Count -eq 1) {
                exit 1
            }
        } catch {
            throw
        }
    }

    clean
    {
        if ($null -ne $steppablePipeline) {
            $steppablePipeline.Clean()
        }
    }
}


function Get-InstalledDevModule {
    <#
    .SYNOPSIS
        Gets a list of modules installed from the local 'Developing' repository on the computer.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        ${Name})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }

            function command {
                Get-InstalledModule | Where-Object {$_.Repository -eq 'Developing'}
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand("command", [System.Management.Automation.CommandTypes]::Function)

            $scriptCmd = {& $wrappedCmd @PSBoundParameters }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
        } catch {
            throw
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }

    clean
    {
        if ($null -ne $steppablePipeline) {
            $steppablePipeline.Clean()
        }
    }
}
