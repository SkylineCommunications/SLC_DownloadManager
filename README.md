# SLC_VHD_DownloadManager

[...existing content before Usage...]

## Usage

[...existing Usage content...]

## Advanced Usage and Options

The main downloader script can be customized by editing its variables or invoking its internal functions with parameters:

- **Change Download URL:**  
  Edit the `$Url` variable at the top of `Get-OnlineFile.ps1` to point to the desired file.

- **Change Output File:**  
  Edit the `$OutputFile` variable at the top of the script to set the desired save location and filename.

- **Adjust Parallel Threads:**  
  The script uses a default of 16 concurrent download threads. You can change this by editing the call to `Start-Download` at the bottom of the script, or by modifying the default in the function definition:
  ```powershell
  $SegmentFiles = Start-Download -Url $Url -OutputFile $OutputFile -Threads 32
  ```

- **Retry Logic:**  
  Each segment will be retried up to 3 times before reporting an error. This is controlled in the `Get-Segment` helper function.

- **SHA256 Verification:**  
  After download, the script will fetch a `.sha256` file (from `$Url.sha256`) and compare the expected hash with the downloaded file.

For deeper customization, you can call helper functions like `Start-Download` with your own parameters from the PowerShell prompt, or integrate parts of the script into broader automation workflows.

[...any remaining README content...]
