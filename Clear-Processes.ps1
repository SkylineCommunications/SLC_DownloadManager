# Get all running jobs
$jobs = Get-Job
# Stop all running jobs
$jobs | ForEach-Object { Stop-Job -Job $_ }

# Remove all jobs
$jobs | ForEach-Object { Remove-Job -Job $_ }

# Get the script's directory
$ScriptDirectory = $PSScriptRoot

# Remove all files with "segment_" prefix in the script's directory
Get-ChildItem -Path $ScriptDirectory -Filter "segment_*" | Remove-Item -Force