#! /bin/bash

mkdir -p /ext
mount /dev/sdb /ext
chmod a+w -R /ext
/opt/anaconda3/bin/conda update conda --yes
/opt/ananconda3/bin/conda update -c fastai fastai --yes
