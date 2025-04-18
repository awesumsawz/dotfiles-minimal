
# SSH Hardening and Passwordless sudo on Ubuntu Server

This document provides step-by-step instructions for:

1. **Hardening SSH** by setting up public key authentication and disabling password login.
2. **Enabling passwordless sudo** for your user account.

---

## 1. Passwordless sudo Setup

1. **Log in** as the target user (or as root) via SSH.

2. **Create a sudoers drop-in file** using `visudo`:
   ```bash
   sudo visudo -f /etc/sudoers.d/90-nopasswd
   ```

3. **Add the NOPASSWD rule**:
   - For a specific user:
     ```
     yourusername ALL=(ALL) NOPASSWD: ALL
     ```
   - For all members of the `sudo` group:
     ```
     %sudo ALL=(ALL) NOPASSWD: ALL
     ```

4. **Save and exit**:
   - In `visudo`: `Ctrl+O`, `Enter` to save, `Ctrl+X` to exit.

5. **Secure the file permissions**:
   ```bash
   sudo chmod 0440 /etc/sudoers.d/90-nopasswd
   ```

6. **Test** in a new SSH session:
   ```bash
   sudo whoami
   ```
   You should see `root` without a password prompt.

---

## 2. SSH Key-Based Authentication

### 2.1 Generate an SSH Key Pair (Client Side)

On your local machine, run:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
- **`-t ed25519`**: Uses a modern, secure key type.  
- **`-C`**: Adds a comment (e.g., your email).  
- Accept the default file location (`~/.ssh/id_ed25519`) and optionally provide a passphrase.

### 2.2 Copy the Public Key to the Server

Use `ssh-copy-id`:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub yourusername@server_ip
```

Alternatively, manually copy the key:
```bash
cat ~/.ssh/id_ed25519.pub | ssh yourusername@server_ip 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'
```

Ensure proper permissions on the server:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### 2.3 Disable Password Authentication (Server Side)

Edit the SSH server configuration:
```bash
sudo nano /etc/ssh/sshd_config
```

Set the following options:
```
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
PermitRootLogin prohibit-password
```

### 2.4 Reload SSH Service

```bash
sudo systemctl reload sshd
```

### 2.5 Verify Key-Only Login

From a new terminal session:
```bash
ssh yourusername@server_ip
```
You should log in without being prompted for a password. If you still get a password prompt, double-check `sshd_config` settings and file permissions.

---

**Result:**
- SSH logins now require key-based authentication, and password login is disabled.
- Your user can now run `sudo` commands without entering a password.

