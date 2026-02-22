# Mint Server 24/7 Optimization Kit

Version: V1.0

Author: hotrokythuat79-xiaozhi

---

## 🎯 Mục tiêu

Tối ưu Linux Mint chạy 24/7 theo hướng:

- Ổn định lâu dài
- Giảm ghi HDD
- Giảm freeze khi RAM gần đầy
- Phù hợp Home Server / Docker / Arduino build
- Tối ưu cho laptop cũ

---

## 🖥 Cấu hình đã test

- Máy: ASUS X451CA
- CPU: i3-3217U
- RAM: 6GB DDR3
- Ổ chính: HDD 320GB (ROTA=1)
- IO Scheduler: mq-deadline
- ZRAM: bật
- SSH push enabled

---

## ⚙ Các tối ưu đã áp dụng

### Kernel tuning

vm.dirty_writeback_centisecs = 1500  
vm.dirty_expire_centisecs = 15000  
vm.swappiness = 10  
vm.vfs_cache_pressure = 50  
vm.overcommit_memory = 1  
vm.min_free_kbytes = 65536  

---

### HDD tuning

- noatime mount
- Read-ahead = 2MB
- Udev rule persistent

---

### Log control

SystemMaxUse=100M

---

### Disable sleep

sleep.target  
suspend.target  
hibernate.target  
hybrid-sleep.target  

---

## 🚀 Cách dùng sau khi cài mới

Clone repo:
git clone git@github.com:hotrokythuat79-xiaozhi/mint-server-247.git
cd mint-server-247

Cấp quyền:
chmod +x scripts/mint-server-247-auto.sh

Chạy tối ưu:
sudo ./scripts/mint-server-247-auto.sh

---

## 📌 Ghi chú

Đây là bản V1.0.

Các phiên bản sau có thể thêm:

- Docker mode
- Health check script
- Auto update
- Backup automation
