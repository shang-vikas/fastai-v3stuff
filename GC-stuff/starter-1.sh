#! /bin/bash

dsk="$(lsblk -f|egrep -v "sda.*|NAME"|awk '{print $1;}'|head -n 1)"
var=$(lsblk -f|egrep -v "sda.*|NAME"|head -n 1|grep "/ext")

if [ "$var" = "" ];then
  mkdir -p /ext
  mount /dev/$dsk /ext
  chmod a+w -R /ext
  ln -s /ext /home/jupyter
fi
/opt/anaconda3/bin/conda update conda --yes
/opt/ananconda3/bin/conda update -c fastai fastai --yes
