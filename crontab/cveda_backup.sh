#!/bin/sh

# this script is executed daily in NeuroSpin at 02:10 AM CE(S)T
#
# It copies c-VEDA raw and processed data from NIMHANS to NeuroSpin.

rsync -rlt --delete cveda:/cveda/databank/PUBLICATION /neurospin/cveda/
rsync -rlt --delete cveda:/cveda/databank/documentation /neurospin/cveda/
rsync -rlt --delete cveda:/cveda/databank/RAW /neurospin/cveda/
rsync -rlt --delete cveda:/cveda/databank/processed /neurospin/cveda/
rsync -rlt cveda:/cveda/databank/framework/psc /neurospin/cveda/framework/
rsync -rlt cveda:/cveda/databank/framework/meta_data /neurospin/cveda/framework/
rsync -rlt cveda:/cveda/databank/framework/INSTALL.txt /neurospin/cveda/framework/
