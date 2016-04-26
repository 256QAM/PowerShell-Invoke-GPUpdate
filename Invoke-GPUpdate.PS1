function Invoke-GPUpdate {
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
		[string[]]$Computer=($Env:COMPUTERNAME),
		[System.Management.Automation.CredentialAttribute()]$Credential,
		[switch]$Force
    )
	
	begin {
		if ($Force) {
			$ScriptBlock = {echo n | gpupdate /force /wait:0}
			$VerboseInfo = '(GPUpdate /Force)'
		} else {
			$ScriptBlock = {echo n | gpupdate /wait:0}
			$VerboseInfo = '(GPUpdate)'
		}
	}
	
	process {
		foreach ($ComputerName in ($Computer)){
			if (test-connection -ComputerName $ComputerName -Count 1 -Quiet){
				write-output ("Attempting "+$VerboseInfo+" on "+$ComputerName)
				try {
					$Result = invoke-command -ComputerName $ComputerName -Credential $Credential -ScriptBlock $ScriptBlock
					Return $Invoke
				} catch {
					$Error = $_.exception.message
					Return $Error
				}
			}
		}
	}
	
	end {}

}