﻿function Set-PSMDModulePath
{
	<#
		.SYNOPSIS
			Sets the path of the module currently being developed.
		
		.DESCRIPTION
			Sets the path of the module currently being developed.
			This is used by several utility commands in order to not require any path input.
	
			This is a wrapper around the psframework configuration system, the same action can be taken by running this command:
			Set-PSFConfig -Module PSModuleDevelopment -Name "Module.Path" -Value $Path
		
		.PARAMETER Path
			The path to set as currently developed module.
		
		.PARAMETER EnableException
            Replaces user friendly yellow warnings with bloody red exceptions of doom!
            Use this if you want the function to throw terminating errors you want to catch.
		
		.EXAMPLE
			Set-PSMDModulePath -Path "C:\github\dbatools"
	
			Sets the current module path to "C:\github\dbatools"
	
		.EXAMPLE
			Set-PSMDModulePath -Path "C:\github\dbatools"
			Register-PSFConfig -FullName 'PSModuleDevelopment.Module.Path'
	
			Sets the current module path to "C:\github\dbatools"
			Then stores the setting in registry, causing it to be persisted acros multiple sessions.
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Path,
		
		[switch]
		$EnableException
	)
	
	$resolvedPath = Resolve-Path -Path $Path
	if (Test-Path -Path $resolvedPath)
	{
		if ((Get-Item $resolvedPath).PSIsContainer)
		{
			Set-PSFConfig -Module PSModuleDevelopment -Name "Module.Path" -Value $resolvedPath
			return
		}
	}
	
	Stop-PSFFunction -Target $Path -Message "Could not validate/resolve path: $Path" -EnableException $EnableException -Category InvalidArgument
	return
}