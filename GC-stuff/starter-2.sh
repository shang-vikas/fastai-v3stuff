#! /bin/bash

mkdir -p /ext
mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mount /dev/sdb /ext
chmod a+w -R /ext
/opt/anaconda3/bin/conda update conda --yes
/opt/ananconda3/bin/conda update -c fastai fastai --yes
