#!/bin/bash
RESULT=task4_1.out

echo '--- Hardware ---' > $RESULT
CPU_INFO=`cat /proc/cpuinfo | grep 'model name' | awk -F ":" '{print $2}' | head -n 1 | xargs`
MEM_INFO=`cat /proc/meminfo | grep 'MemTotal' | awk -F ":" '{print $2}' | head -n 1 | xargs`
BOARD_MAN=`dmidecode | grep -A4 '^Base Board Information' | grep "Manufacturer" | awk -F ":" '{print $2}' | xargs`
if [ -z $BOARD_Man ] 
 then BOARD_MAN="Unknown"
fi
BOARD_NUM=`dmidecode | grep -A4 '^Base Board Information' | grep "Product Name" | awk -F ":" '{print $2}' | xargs`
if [ -z $BOARD_NUM ] 
 then BOARD_NUM="Unknown"
fi
BOARD_VER=`dmidecode | grep -A4 '^Base Board Information' | grep "Version" | awk -F ":" '{print $2}' | xargs`
if [ -z $BOARD_VER ] 
 then BOARD_VER="Unknown"
fi
BOARD_SER=`dmidecode | grep -A4 '^Base Board Information' | grep "Serial" | awk -F ":" '{print $2}' | xargs`
if [ -z $BOARD_SER ] 
 then BOARD_SER="Unknown"
fi

echo "CPU: $CPU_INFO" >> $RESULT
echo "RAM: $MEM_INFO" >> $RESULT
echo "Motherboard: $BOARD_MAN/$BOARD_NUM/$BOARD_VER" >> $RESULT
echo "System Serial Number: $BOARD_SER" >> $RESULT

echo '--- System ---' >> $RESULT
OS=`cat /etc/lsb-release | grep 'DESCRIPTION' | sed 's/DISTRIB_DESCRIPTION=//' | sed 's/"//g'`
KERNEL=`uname -r`
INSTALL=`ls -alct /|tail -1|awk '{print $6, $7, $8}'`
HOSTNAME=`hostname`
UPTIME=`uptime | grep -P 'days' | xargs | cut -d ' ' -f 3`
if [ -z $UPTIME ] 
 then
  UPTIME=`uptime -p | sed 's/up //'`
else
 UPTIME='$UPTIME days'
fi
PROCESSES=`ps -A --no-headers | wc -l`
USERS=`who -q | tail -n1 | sed 's/[^0-9]*//g'`

echo "OS Distribution: $OS" >> $RESULT
echo "Kernel version: $KERNEL" >> $RESULT
echo "Installation date: $INSTALL" >> $RESULT
echo "Hostname: $HOSTNAME" >> $RESULT
echo "Uptime: $UPTIME" >> $RESULT
echo "Processes running: $PROCESSES" >> $RESULT
echo "User logged in: $USERS" >> $RESULT

echo '--- Network ---' >> $RESULT
IFACES=$(ifconfig -s | sed '1d' | cut -d ' ' -f 1)
for iface in $IFACES
	do
	 IP=`ifconfig $iface | grep -Eo 'inet addr:[0-9\.]*' | cut -d ':' -f 2`
	 MASK=`ifconfig $iface | grep -Eo 'Mask:[0-9\.]*' | cut -d ':' -f 2`
	if [ -z $IP ]  
	then IP="-"
	fi
echo "$iface: $IP/$MASK" >> $RESULT
done
