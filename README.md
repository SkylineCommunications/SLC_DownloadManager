# SLC VHD Download Manager

A PowerShell-based tool for robust, segmented downloading of large VHD files, often used in virtualization or cloud deployment scenarios. This utility leverages PowerShell jobs to speed up downloads by splitting the target file into segments and downloading them in parallel. It also provides a cleanup facility to stop running jobs and remove temporary files.

## Features

- **Segmented Download:** The main script (`Get-OnlineFile.ps1`) downloads large files in parallel chunks for reliability and speed, checks integrity with SHA256, and supports retry logic for failed downloads.
- **Cleanup Utility:** The `Clear-Processes.ps1` script terminates all running PowerShell jobs and removes temporary files generated during segmented downloads.

## Requirements

- **Windows PowerShell 5.1 or PowerShell 7+**
- Network access to target file URLs

> Note: The scripts also work on PowerShell 4.0+ because they use `Get-FileHash` for checksum verification (introduced in 4.0). Windows PowerShell 5.1 is recommended and validated.

## Usage

> **Note:** The VHD download URL is defined near the top of `Get-OnlineFile.ps1` as `$Url`. You should update this URL when new images are released.

```powershell
# Default example (uses the URL set in the script)
.\Get-OnlineFile.ps1

# Custom output file
.\Get-OnlineFile.ps1 -OutputFile "MyVHD.vhd"

# Custom thread count
.\Get-OnlineFile.ps1 -Threads 8

# Custom output file and thread count
.\Get-OnlineFile.ps1 -OutputFile "MyVHD.vhd" -Threads 8
```

> Tip: Run the scripts with your default PowerShell. No special version switching is required for normal use.

### Clean Up Temporary Files and Jobs

If an interrupted or failed download leaves behind temporary files or lingering jobs, run:

```powershell
.\Clear-Processes.ps1
```

- This script stops all running PowerShell jobs in the current session.
- It deletes all temporary segment files (files prefixed with `segment_`) from the script’s directory.

## Window Titles

- The main window is labeled: "VHD Download Manager - Main Process".
- Each child job window is labeled: "VHD Download - Segment <N>" for clarity during parallel downloads.

## File Overview

- [`Get-OnlineFile.ps1`](https://github.com/SkylineCommunications/SLC_VHD_DownloadManager/blob/main/Get-OnlineFile.ps1) – Handles segmented download of large files, integrity check, and multi-thread job management.
- [`Clear-Processes.ps1`](https://github.com/SkylineCommunications/SLC_VHD_DownloadManager/blob/main/Clear-Processes.ps1) – Stops jobs and deletes leftover segment files after a download.

## Customization

Edit the top of `Get-OnlineFile.ps1` to change:
- The target `$Url` of the VHD file
- The output file name ($OutputFile)
- The thread count (parameter `$Threads` in `Start-Download`)

## Release Notes

See [RELEASE_NOTES.md](RELEASE_NOTES.md) for details on recent changes.

## License

Distributed under the relevant license specified by Skyline Communications. See the repository for more information.

---

For more details, see the code:
- [Get-OnlineFile.ps1](https://github.com/SkylineCommunications/SLC_VHD_DownloadManager/blob/main/Get-OnlineFile.ps1)
- [Clear-Processes.ps1](https://github.com/SkylineCommunications/SLC_VHD_DownloadManager/blob/main/Clear-Processes.ps1)
