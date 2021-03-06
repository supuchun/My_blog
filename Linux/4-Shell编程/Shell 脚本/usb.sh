#!/bin/bash
RULES=/etc/udev/rules.d/51-android.rules
TMP_USB_1=tmp_usb_1
TMP_USB_2=tmp_usb_2
TMP_USB=diff_usb

echo -n "请把手机链接电脑后,按回车:"

read user_input
lsusb > $TMP_USB_1
cat -n $TMP_USB_1

echo -n "请把手机拔掉后,按回车:"
read user_input

lsusb > $TMP_USB_2
cat -n $TMP_USB_2

diff $TMP_USB_1 $TMP_USB_2 > $TMP_USB

diff_usb_str=`sed -n '2p' $TMP_USB`
#echo ${diff_usb_str}

sub_str=${diff_usb_str:25:9}
#echo $sub_str

idVendor=${sub_str:0:4}
idProduct=${sub_str:5:4}

insert='SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"'${idVendor}'\", ATTRS{idProduct}==\"'${idProduct}'\",MODE=\"0666\"'

sudo touch $RULES
sudo sh -c "echo $insert >> $RULES"
sudo chmod a+x $RULES

echo -n "请再次把手机链接电脑,之后按回车:"
read user_input

adb kill-server && adb devices

echo "看到设备表示已经成功了,如果还是没有显示正常,重启一下电脑就好了"

rm $TMP_USB $TMP_USB_1 $TMP_USB_2
                                                                                  