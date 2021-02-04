#!/system/bin/sh

# UFS powersave
echo 0 > /sys/devices/platform/soc/1d84000.ufshc/clkgate_enable
echo 0 > /sys/devices/platform/soc/1d84000.ufshc/hibern8_on_idle_enable

# lpm_level
echo Y > /sys/module/lpm_levels/parameters/sleep_disabled

# Replace msm_irqbalance.conf
echo "PRIO=1,1,1,1,0,0,0,0
# arch_timer,arch_mem_timer,arm-pmu,kgsl-3d0,glink_lpass
IGNORED_IRQ=19,38,21,332,188" > /dev/msm_irqbalance.conf
chmod 644 /dev/msm_irqbalance.conf
mount --bind /dev/msm_irqbalance.conf /vendor/etc/msm_irqbalance.conf
chcon "u:object_r:vendor_configs_file:s0" /vendor/etc/msm_irqbalance.conf

killall msm_irqbalance
