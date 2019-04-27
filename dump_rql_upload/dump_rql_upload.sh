#!/bin/sh

DIRNAME=`dirname $0`

. ~/virtualenvs/cveda_upload/bin/activate
cubicweb-ctl shell cveda_upload "$DIRNAME/dump_rql_upload.py" > /cveda/chroot/data/tmp/cati/dump_rlq_upload.json
