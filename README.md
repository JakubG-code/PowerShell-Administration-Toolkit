# PowerShell Administration Toolkit

Collection of PowerShell scripts for Windows administration, system maintenance, monitoring and log analysis.

The project contains practical automation scripts for common administrative tasks such as file inventory, temporary file cleanup, resource monitoring and Windows log analysis.

## Included Scripts

### 01_list_files_gui.ps1

Graphical tool for exporting file names from a selected folder.

**Features**

- Folder selection dialog
- Export file names to TXT
- Simple Windows Forms GUI

---

### 02_temp_cleaner.ps1

Console utility for cleaning temporary Windows files.

**Features**

- Cleans user TEMP directory
- Cleans Windows TEMP directory
- Optional Prefetch cleanup
- Colored console output
- Error handling

---

### 02_temp_cleaner_gui.ps1

GUI version of the temporary file cleaner.

**Features**

- Windows Forms interface
- Real-time log output
- Optional Prefetch cleanup
- Colored status messages

---

### 03_parser_logow.ps1

Parses Windows CBS.log and classifies detected errors.

**Features**

- Detects error entries
- Categorizes common issues
- Assigns severity levels
- Displays summarized results

---

### 04_live_monit_cpu_hdd_ram.ps1

Real-time Windows system monitoring.

**Features**

- CPU utilization
- RAM usage
- Free disk space
- CSV logging
- Live console output

## Technologies

- PowerShell 5.1+
- Windows Forms
- WMI / CIM
- CSV reporting

## Requirements

- Windows 10 / Windows 11
- Windows PowerShell 5.1 or PowerShell 7
- Administrator privileges recommended for some scripts

## Usage

Run any script from PowerShell:

```powershell
.\01_list_files_gui.ps1

.\02_temp_cleaner.ps1

.\02_temp_cleaner_gui.ps1

.\03_parser_logow.ps1

.\04_live_monit_cpu_hdd_ram.ps1
```

## Future Improvements

- Event Log analysis
- Windows Update reporting
- Disk health monitoring (SMART)
- Email notifications
- HTML dashboard
- Scheduled task support
- Performance graphs

## License

MIT License
