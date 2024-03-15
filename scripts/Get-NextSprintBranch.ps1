# All errors are terminating errors
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

[Regex] $SprintBranchNameRegex = "^((AERIS|CDE)_Sprint_)([0-9])+$"
$PullRequestJsonProperties = "baseRefName,headRefName,mergedAt,number,state,title,url"

Write-Output "Checking for previous sprint branches"
$LatestSprintBranch = (gh pr list --state "merged" --json $PullRequestJsonProperties | ConvertFrom-Json -AsHashtable).Where({
        ($PSItem.baseRefName -eq "main") -and
        ($PSItem.headRefName -imatch $SprintBranchNameRegex)
    }
) | Sort-Object -Property mergedAt -Descending | Select-Object -First 1

if ($null -eq $LatestSprintBranch) {
    throw "Failed to find sprint branch"
}

Write-Output "Found latest sprint branch with name '$($LatestSprintBranch.headRefName)'"

[String] $SprintBranchPrefixName = $SprintBranchNameRegex.Match($LatestSprintBranch.headRefName).Groups.Where({ $PSItem.Name -eq "1" }).Value
[Int] $SprintBranchNumber = $SprintBranchNameRegex.Match($LatestSprintBranch.headRefName).Groups.Where({ $PSItem.Name -eq "3" }).Value

$NextSprintBranchName = "${SprintBranchPrefixName}$($SprintBranchNumber + 1)"
Write-Output "Generated next sprint branch with name '$NextSprintBranchName'"
Write-Output "SPRINT_BRANCH_NAME=$NextSprintBranchName" >> $env:GITHUB_OUTPUT
