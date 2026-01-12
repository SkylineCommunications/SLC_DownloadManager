# Release Notes

## Version 1.1.0 (2026-01-12)

### Added
- Window titles for clarity:
  - Main: "VHD Download Manager - Main Process"
  - Children: "VHD Download - Segment <N>"

### Changed
- Removed PID-based tracking/cleanup; replaced with job-based cleanup using `Get-Job`, `Stop-Job`, and `Remove-Job`.
- Fixed Unix-style stderr redirection (`2>/dev/null`) to PowerShell semantics.
- Updated README: requirements now state Windows PowerShell 5.1 or PowerShell 7+, usage examples, and cleanup behavior.

### Fixed
- Error where `Get-Process -Id $job.ChildJobs[0].Location` attempted to use `Location` (e.g., `localhost`) as a PID.

### Compatibility
- Validated on Windows PowerShell 5.1 and PowerShell 7.
- Minimum PowerShell 4.0 due to `Get-FileHash`; 5.1+ recommended. Use your default PowerShell for normal operation.

---

## Prior Versions

### Version 1.0.0
- Initial segmented download implementation with retry logic and SHA-256 verification.
- Basic cleanup script to remove segment files and stop lingering jobs.
