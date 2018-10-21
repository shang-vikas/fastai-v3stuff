#! /bin/bash

mkdir -p /ext
mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mount /dev/sdb /ext

