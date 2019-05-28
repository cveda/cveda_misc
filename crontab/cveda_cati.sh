#!/bin/sh

# this script is executed daily by databank@cveda.nimhans.ac.in at 06:00 AM IST
#
# 1. It sends new imaging datasets to the CATI team for QC.
# 2. It dumps the database of the upload portal to a JSON file.

/cveda/databank/virtualenvs/scripts/qualicati/sync_qc_res.sh
/cveda/databank/framework/cveda_misc/dump_rql_upload/dump_rql_upload.sh
