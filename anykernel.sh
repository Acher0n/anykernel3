# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
eval $(cat /tmp/anykernel/props | grep -v '\.')

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel install
dump_boot;

# Use the provided dtb
mv /tmp/anykernel/dtb /tmp/anykernel/split_img/

# Change skip_initramfs to want_initramfs if Magisk is detected
if [ -e /sbin/pigz ]; then
  GZIP="pigz -p4";
else
  GZIP="gzip";
fi
if [ -d $ramdisk/.backup ]; then
  ui_print " ";
  ui_print "Magisk detected!";
  ui_print "Patching kernel so that reflashing Magisk is not necessary...";
  $GZIP -dc < /tmp/anykernel/Image.gz | sed -e 's/skip_initramfs/want_initramfs/g' | $GZIP > /tmp/anykernel/Image.gz.tmp;
  mv /tmp/anykernel/Image.gz.tmp /tmp/anykernel/Image.gz;
fi

# Install the boot image
write_boot;

## end install
