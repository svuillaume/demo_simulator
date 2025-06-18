#!/usr/bin/env bash
set -euo pipefail

echo "[5] Cleaning up simulation artifacts..."

# Stop XMRig miner
echo "  [-] Stopping XMRig miner..."
pkill -f xmrig || echo "    [i] No XMRig process found."

# List of users to delete (edit if needed)
CREATED_USERS=("malicioususer1" "malicioususer2")

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

# Optional: Set this if you use a backdoor file
BACKDOOR_FILE=""

# Remove backdoor file if defined
if [ -n "$BACKDOOR_FILE" ]; then
  echo "  [-] Removing backdoor file..."
  rm -f "$BACKDOOR_FILE"
fi

echo "[✔] Cleanup completed successfully."
