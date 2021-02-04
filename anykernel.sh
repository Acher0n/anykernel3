# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

# set up working directory variables
test "$home" || home=$PWD;
bootimg=$home/boot.img;
bin=$home/tools;
patch=$home/patch;
ramdisk=$home/ramdisk;
split_img=$home/split_img;

## AnyKernel setup
eval $(cat $home/props | grep -v '\.')

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

if [ -d $ramdisk/.backup ]; then
    mv $home/overlay.d $ramdisk/overlay.d;
    chmod -R 750 $ramdisk/overlay.d/*;
    chown -R root:root $ramdisk/overlay.d/*;
    chmod -R 755 $ramdisk/overlay.d/sbin/*;
    chown -R root:root $ramdisk/overlay.d/sbin/*;
fi

install() {
  ## AnyKernel install
  dump_boot;

  # Install the boot image
  write_boot;
}

install;

case $is_slot_device in
  1|auto)
    ui_print " ";
    ui_print "Installing to the secondary slot";
    slot_select=inactive;
    unset block;
    eval $(cat $home/props | grep '^block=' | grep -v '\.')
    reset_ak;
    install;
  ;;
esac

## end install
