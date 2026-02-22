#!/bin/bash

echo "=== Mint Server 24/7 Auto Optimization Script ==="

# Detect root device (e.g., sda, sdb)
ROOT_DEV=$(lsblk -no PKNAME $(findmnt -n -o SOURCE /))
echo "Detected root device: /dev/$ROOT_DEV"

# 1. Sysctl tuning (avoid duplicate entries)
echo "Applying sysctl tuning..."

sudo sed -i '/# Server 24\/7 tuning/,$d' /etc/sysctl.conf

sudo tee -a /etc/sysctl.conf > /dev/null <<EOF

# Server 24/7 tuning
vm.dirty_writeback_centisecs = 1500
vm.dirty_expire_centisecs = 15000
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.overcommit_memory = 1
vm.min_free_kbytes = 65536
EOF

sudo sysctl -p

# 2. Limit journald log size
echo "Configuring journald..."
sudo sed -i 's/^#*SystemMaxUse=.*/SystemMaxUse=100M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald

# 3. Disable sleep/hibernate
echo "Disabling sleep modes..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# 4. Set read-ahead to 2MB (4096 sectors)
echo "Setting read-ahead..."
sudo blockdev --setra 4096 /dev/$ROOT_DEV

# 5. Make read-ahead persistent
echo "Making read-ahead persistent..."
sudo tee /etc/udev/rules.d/60-read-ahead.rules > /dev/null <<EOF
ACTION=="add|change", KERNEL=="$ROOT_DEV", ATTR{queue/read_ahead_kb}="2048"
EOF

sudo udevadm control --reload
sudo udevadm trigger

echo "=== Optimization Complete for /dev/$ROOT_DEV ==="
