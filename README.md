# DSC-WinLab

A fully automated virtual lab environment built with PowerShell and Hyper-V to simulate a Windows infrastructure using **Infrastructure as Code (IaC)** principles.

This lab provisions a domain controller and a client machine, leveraging **DSC (Desired State Configuration)** for post-installation configuration, and optionally simulating PXE-based deployments for future scalability.

---

## 🧩 Features

- ✅ Automated Hyper-V lab deployment via PowerShell
- ✅ Configurable environment using a central `settings.ps1`
- ✅ Automatic creation and configuration of virtual switches and VMs
- ✅ ISO mounting and unattended Windows Server installation
- ✅ DSC-based configuration for domain controller setup
- ✅ Modular structure for future expansion (e.g., PXE boot, multi-tier networks)
- ✅ Extensible, readable code for learning and DevOps simulation

---

## 📁 Project Structure

```plaintext
DSC-WinLab/
├── dsc/                    # DSC configurations (e.g., SetupDC.ps1)
├── unattend/              # autounattend.xml files
├── vhd-unattend/          # VHDs with autounattend.xml
├── scripts/               # Execution steps (01 to 09)
├── ISOs/                  # Your Windows Server ISO goes here
├── settings.ps1           # Central configuration file
├── labpreparation.ps1     # Main orchestrator
└── README.md
````

---

## 🚀 How It Works

1. **Edit** `settings.ps1` to define paths, VM specs, and domain settings.
2. **Place** your `WinServer2022.iso` inside the `ISOs/` folder.
3. **Prepare** an `autounattend.xml` and put it in `unattend/DC01-autounattend.xml`.
4. Run the orchestrator:

```powershell
.\labpreparation.ps1
```

This script will:

* Validate your environment
* Create VMs and switches
* Mount ISO and attach unattend VHD
* Start installation on `DC01`
* Wait until installation completes
* Apply DSC configuration to promote it to a Domain Controller
* Provide a final status report

---

## ⚙️ Prerequisites

* Windows 10/11 Pro or Server with **Hyper-V** enabled
* PowerShell 5.1+ (preferably with `xActiveDirectory` module installed)
* Windows ADK + Windows SIM (if generating `autounattend.xml`)
* Windows Server 2022 ISO

---

## 🧪 VMs Deployed

| VM Name  | Role                           | RAM  | Disk  | Notes                             |
| -------- | ------------------------------ | ---- | ----- | --------------------------------- |
| DC01     | Domain Controller              | 4 GB | 60 GB | Installs via unattend + DSC       |
| CLIENT01 | Domain-joined client (planned) | 2 GB | 40 GB | Future: PXE + post-install config |

---

## 📌 Goals

This project aims to:

* Practice **Windows Infrastructure Automation**
* Demonstrate proficiency with **PowerShell**, **Hyper-V**, and **DSC**
* Lay the foundation for advanced lab scenarios: PXE, WDS, GPOs, multi-domain, etc.

---

## 📖 Future Ideas

* [ ] PXE boot support using WDS or custom DHCP/TFTP
* [ ] Automatic DSC for CLIENT01 after installation
---

## 📂 ISO Files (not included)

This project expects the following ISOs to be available locally:

- `WinServer2022.iso` in `C:\Labs\DSC-WinLab\ISOs`
- `DC01-Auto.iso` created manually from the original ISO and `autounattend.xml`

Due to GitHub limitations, these files are not included in the repository.

## 🙋 About

This project was built by [Pieri](https://github.com/Pieri1) as part of a personal study into Windows infrastructure automation and DevOps practices in PowerShell.
