#!/system/bin/sh

echo 10 > /proc/sys/vm/dirty_background_ratio
echo 3000 > /proc/sys/vm/dirty_expire_centisecs
echo 0 > /proc/sys/vm/page-cluster

echo 1000 > /dev/blkio/blkio.weight
echo 200 > /dev/blkio/background/blkio.weight
echo 2000 > /dev/blkio/blkio.group_idle
echo 0 > /dev/blkio/background/blkio.group_idle

for i in dm-0 sda sdb sdc sdd sde sdf ; do
  [ -e /sys/block/$i/queue/read_ahead_kb ] && echo 128 > /sys/block/$i/queue/read_ahead_kb
  [ -e /sys/block/$i/queue/iosched/back_seek_penalty ] && echo 1 > /sys/block/$i/queue/iosched/back_seek_penalty
  [ -e /sys/block/$i/queue/iosched/quantum ] && echo 16 > /sys/block/$i/queue/iosched/quantum
done

echo 0 > /sys/class/kgsl/kgsl-3d0/force_no_nap 
echo 1 > /sys/class/kgsl/kgsl-3d0/bus_split 
echo 0 > /sys/class/kgsl/kgsl-3d0/force_bus_on 
echo 0 > /sys/class/kgsl/kgsl-3d0/force_clk_on 
echo 0 > /sys/class/kgsl/kgsl-3d0/force_rail_on

 echo 0 > /sys/block/vbswap0/queue/read_ahead_kb

# Set swappiness reflecting the device's RAM size
RamStr=$(cat /proc/meminfo | grep MemTotal)
RamMB=$((${RamStr:16:8} / 1024))
if [ $RamMB -le 6144 ]; then
  echo 160 > /proc/sys/vm/rswappiness
else
  echo 130 > /proc/sys/vm/rswappiness
fi

# UFS powersave
echo 1 > /sys/devices/platform/soc/1d84000.ufshc/clkgate_enable
echo 1 > /sys/devices/platform/soc/1d84000.ufshc/hibern8_on_idle_enable

# lpm_level
echo N > /sys/module/lpm_levels/parameters/sleep_disabled
echo N > /sys/module/lpm_levels/parameters/lpm_ipi_prediction
echo N > /sys/module/lpm_levels/parameters/lpm_prediction

# net
echo 262144 > /proc/sys/net/core/rmem_max
echo 262144 > /proc/sys/net/core/wmem_max

# dm_verity
echo 0 > /sys/module/dm_verity/parameters/prefetch_cluster

# Report max freq to unity tasks
echo "UnityMain,libunity.so" > /proc/sys/kernel/sched_lib_name
echo 255 > /proc/sys/kernel/sched_lib_mask_force
