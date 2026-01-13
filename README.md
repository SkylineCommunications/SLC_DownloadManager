# SLC Download Manager (C#)

Production-grade parallel VHD/file downloader with real-time heatmap progress visualization, automatic retry logic, and configurable concurrency.

## Features

- **Parallel segment downloads** with configurable thread count (1-256+)
- **Real-time heatmap** showing per-segment status:
  - **Green (0)**: Segment completed successfully
  - **Yellow (1-3)**: Segment retrying after failure (shows retry count)
  - **Red (3+)**: Segment failed after exhausting max retries
  - **Gray (0)**: Segment in progress or queued
- **File integrity verification** with SHA256 hash comparison
- **Automatic retry logic** with 3 attempts per segment and 2-second backoff
- **HTTP range request support** for efficient parallel downloads
- **Progress tracking** with percentage and bytes downloaded
- **Segment merging** with progress display
- **Automatic cleanup** of temporary segment files
- **Chaos mode** for testing failure scenarios
- **Async/await** patterns with proper cancellation support

## Quick Start

### For Developers

#### Build
```bash
dotnet build
```

#### Usage
```bash
dotnet run -- [URL] [THREADS] [OUTPUT_PATH] [--chaos] [--retries=N] [--hash=HASH]
```

**Examples:**
```bash
dotnet run -- "https://github.com/szalony9szymek/large/releases/download/free/large" 64 "test.bin"
dotnet run -- "https://github.com/szalony9szymek/large/releases/download/free/large" 8 "test.bin" --chaos
dotnet run -- "https://stgpublicdownloads.blob.core.windows.net/cnt-selfhosteddma-vmimages/10.5/mgdsk-selfhosted-dma-Images-1005000900.vhdx" 256 "SLC_DMA.vhdx" --hash=a18b22343405cb97be56bef0832d09687f8408d5466dc8e251d435a0f65a70e3
```

### For End Users

#### Publish Self-Contained Executable (Windows)
```bash
dotnet publish -c Release -r win-x64 --self-contained -p:PublishSingleFile=true
```

The executable will be in: `bin\Release\net8.0\win-x64\publish\SLC_DownloadManager.exe`

#### Usage
```bash
SLC_DownloadManager.exe [URL] [THREADS] [OUTPUT_PATH] [--chaos] [--retries=N] [--hash=HASH]
```

**Examples:**
```bash
SLC_DownloadManager.exe "https://github.com/szalony9szymek/large/releases/download/free/large" 64 "test.bin"
SLC_DownloadManager.exe "https://github.com/szalony9szymek/large/releases/download/free/large" 8 "test.bin" --chaos
SLC_DownloadManager.exe "https://stgpublicdownloads.blob.core.windows.net/cnt-selfhosteddma-vmimages/10.5/mgdsk-selfhosted-dma-Images-1005000900.vhdx" 256 "SLC_DMA.vhdx" --hash=a18b22343405cb97be56bef0832d09687f8408d5466dc8e251d435a0f65a70e3
```

## Command-Line Arguments

| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| URL | string | required | Download URL (must support HTTP range requests) |
| THREADS | int | `8` | Number of parallel segments (recommended: 8-64) |
| OUTPUT_PATH | string | `downloaded_file.bin` | Local file path to save |
| --chaos | flag | disabled | Enable chaos mode (injects failures for testing) |
| --retries=N | int | `3` | Maximum retry attempts per segment (minimum: 1) |
| --hash=HASH | string | none | SHA256 hash for file integrity verification after download |

## Project Structure

```
src/
  Program.cs           - Entry point, command-line parsing
  DownloadManager.cs   - Core download logic, heatmap rendering, retry handling
SLC_DownloadManager.csproj
.vscode/tasks.json    - VS Code build/run tasks
```

## Progress Display

During download, the heatmap updates every 500ms to show per-segment state and overall throughput:
```
Segment Status:
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
Progress: 25% | 250.00 MB / 1000.00 MB
```

Legend: **green** = success, **yellow** = retrying (number shows retry count), **red** = failed after max retries, **gray** = in progress/queued.

After download completes, the final segment heatmap is displayed as a summary, followed by a single-line merge progress indicator that updates in-place (0% → 100%) without scrolling:
```
Download Complete - Final Segment Status:
0 0 0 0 0 0 0 0

100% | 1996.20 MB / 1996.20 MB

Merging segments into final file...
Merging:  75%
Successfully created: test.bin
```

## Chaos Mode

Chaos mode (`--chaos`) purposely injects failures to validate retry logic and resilience:
- **Segment 0**: Simulated immediate failure on first attempt, forces retry path
- **Segment 1**: Simulated timeout (5-second limit), exercises cancellation handling

Use chaos mode to verify:
- Heatmap color transitions (gray → yellow [1] → green or red)
- Retry counter increments in yellow segments
- Merge executes successfully after all retries complete
- Single-line merge progress updates cleanly without scrolling

Example output during chaos (retries in progress):
```
Segment Status:
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
Progress: 12% | 120.00 MB / 1000.00 MB
```

After segment retries complete (all segments green):
```
Download Complete - Final Segment Status:
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

100% | 1000.00 MB / 1000.00 MB
```

Tip: Increase `--retries` if segments exceed max attempts (e.g., `--retries=6`) for more aggressive retry behavior.

## Error Handling

- **HTTP errors (403, 404, 500)**: Retried 3 times with 2-second delays
- **Timeout errors**: 5-second per-attempt timeout
- **File I/O errors**: Caught and reported
- **Failed segments**: Download aborts if exhausted all retries
- **Merge failures**: Temporary file cleanup on error

## Performance Notes

- **Optimal thread count**: 8-64 threads
- **Segment size**: Calculated as `fileSize / threadCount`
- **Memory usage**: Minimal—streams written directly to disk

## Testing

### Test Scenarios

1. **Successful download**:
   ```bash
   dotnet run -- "https://github.com/szalony9szymek/large/releases/download/free/large" 8
   ```

2. **Chaos mode** (test retry/fail):
   ```bash
   dotnet run -- "https://github.com/szalony9szymek/large/releases/download/free/large" 8 "test.bin" --chaos
   ```

3. **High concurrency** (128 threads):
   ```bash
   dotnet run -- "https://github.com/szalony9szymek/large/releases/download/free/large" 128
   ```

## Requirements

- **.NET 8.0** or later
- **Spectre.Console** 0.49.1+ (NuGet auto-restore)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Server did not return Content-Length" | URL doesn't support HTTP range requests |
| "HTTP 403 Forbidden" | Server is restricting access or requires authentication |
| "Segment files missing" | Disk space exhausted or permission issue |
| Slow download | Reduce thread count or check network bandwidth |

## License

Internal use. Built for Skyline Communications.
