#! /bin/bash

dsk="$(lsblk -f|egrep -v "sda.*|NAME"|awk '{print $1;}'|head -n 1)"
frmt=$(lsblk -f|egrep -v "sda.*|NAME"|head -n 1|grep "ext4")
atch=$(lsblk -f|egrep -v "sda.*|NAME"|head -n 1|grep "/ext")

if [ "$frmt" = "" ];then
  echo "$date: filesystem not found on $dsk . creating new ext4 fs" >> /home/jupyter/creation.log
  mkfs.ext4 -m 0 -F -E -N 200000000 lazy_itable_init=0,lazy_journal_init=0,discard /dev/$dsk
fi

if [ "$atch" = "" ];then
  echo "$date $dsk not mounted. mounting at /ext" >> /home/jupyter/creation.log
  mkdir -p /ext
  mount /dev/$dsk /ext
  chmod a+w -R /ext
  lnk=$(ls /home/jupyter|grep ext)
  if [ "$lnk" = "" ];then
    echo "$date Linking disk to /home/jupyter/ext" >> /home/jupyter/creation.log
    ln -s /ext /home/jupyter
  fi
fi

/opt/anaconda3/bin/conda update conda --yes
/opt/ananconda3/bin/conda update -c fastai fastai --yes
