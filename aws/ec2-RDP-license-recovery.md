# RDP / RDS Licensing Recovery Runbook

## Issue

Users cannot log in to a Windows VM using Remote Desktop and see this error:

```text
The remote session was disconnected because there are no Remote Desktop License Servers available to provide a license.
Please contact the server administrator.
```

This usually happens when the server is configured as an **RDS Session Host** for multiple users, but it cannot contact a valid **Remote Desktop Licensing Server**, or the RDS grace period has expired.

## Environment Example

```text
RDS Session Host: 10.0.1.10
RDS License Server: server.com
License Server IP: 10.1.1.1
Domain: company.com
```

## Quick Access Workaround

If normal RDP fails, try an administrative RDP session:

```cmd
mstsc /admin
```

If RDP is completely unavailable, use **AWS Systems Manager Session Manager**.

## If Session Manager Is Not Connected

Ensure the EC2 instance has an IAM role with this AWS managed policy:

```text
AmazonSSMManagedInstanceCore
```

If the instance is in a private subnet, ensure it has outbound HTTPS access through NAT or VPC endpoints for:

```text
com.amazonaws.<region>.ssm
com.amazonaws.<region>.ssmmessages
com.amazonaws.<region>.ec2messages
```

Then restart the SSM agent if possible:

```powershell
Restart-Service AmazonSSMAgent
```

## Confirm RDS Licensing Configuration

Run from PowerShell on the affected VM:

```powershell
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\Licensing Core"
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
```

Expected policy values for Per User licensing:

```text
LicenseServers REG_SZ server.com
LicensingMode  REG_DWORD 0x4
```

Licensing mode values:

```text
2 = Per Device
4 = Per User
```

## Reapply RDS Licensing Settings

Run:

```powershell
$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
New-Item -Path $path -Force | Out-Null
Set-ItemProperty -Path $path -Name LicensingMode -Type DWord -Value 4
Set-ItemProperty -Path $path -Name LicenseServers -Type String -Value "vm00pap117.server.com"
gpupdate /force
```

## Check Domain Connectivity

Run:

```powershell
nltest /dsgetdc:server.com
nltest /sc_verify:server.com
Test-ComputerSecureChannel
```

Expected:

```text
The command completed successfully
Test-ComputerSecureChannel = True
```

If these fail, fix domain controller, DNS, routing, or firewall connectivity before troubleshooting RDS licensing further.

## Check License Server Connectivity

Run from the affected VM:

```powershell
Resolve-DnsName vm00pap117.server.com
Test-NetConnection vm00pap117.server.com -Port 135
Test-NetConnection vm00pap117.server.com -Port 445
Test-NetConnection vm00pap117.server.com -Port 49152
Test-NetConnection vm00pap117.server.com -Port 50000
Test-NetConnection vm00pap117.server.com -Port 65535
```

All required ports should succeed, especially TCP `135`, TCP `445`, and the dynamic RPC range.

## Required Firewall Rules

Request firewall rules from the RDS Session Host or its subnet to the RDS License Server.

| Source | Destination | Protocol/Port | Purpose |
|---|---:|---:|---|
| RDS Session Host IP or subnet | RDS License Server | TCP `135` | RPC Endpoint Mapper |
| RDS Session Host IP or subnet | RDS License Server | TCP `445` | SMB / RPC support |
| RDS Session Host IP or subnet | RDS License Server | TCP `49152-65535` | Windows dynamic RPC ports used by RDS Licensing |

For the example environment:

```text
Source: 10.0.1.10 or its subnet
Destination: 10.1.1.1
Allow: TCP 135, TCP 445, TCP 49152-65535
```

If the server was migrated between AWS accounts, VPCs, or subnets, ensure firewall rules, security groups, NACLs, routing, and Windows Firewall scopes allow the new source IP/subnet.

## Check RDS Event Logs

Run:

```powershell
Get-WinEvent -LogName "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Admin" -MaxEvents 50 |
  Select-Object TimeCreated, Id, LevelDisplayName, Message
```

Common licensing errors:

```text
50280: The RD Licensing grace period has expired and the service has not registered with a license server with installed licenses.
50282: The Remote Desktop Session Host server does not have a Remote Desktop license server specified.
```

## Restart Services After Fixing Firewall or Licensing

First try restarting Remote Desktop Services:

```powershell
gpupdate /force
Restart-Service TermService -Force
```

If the issue remains, reboot the server:

```powershell
Restart-Computer -Force
```

After reboot, test RDP again.

## License Server Checks

On the RDS License Server, verify:

```powershell
Get-Service TermServLicensing
Restart-Service TermServLicensing
Enable-NetFirewallRule -DisplayGroup "Remote Desktop Licensing"
```

Also confirm:

- The RDS License Server is activated.
- Valid RDS CALs are installed.
- The correct licensing mode is used: Per User or Per Device.
- Windows Firewall or network firewall rules are not scoped only to old IP ranges.

## Important Warning

Do **not** uninstall the `RDS-RD-Server` role if the server is supposed to support multiple RDP users.
Removing it will stop the server from functioning as a Remote Desktop Session Host and may break multi-user access or published RDS applications.
Only remove the role if the server is intended for normal administrative RDP access only.
