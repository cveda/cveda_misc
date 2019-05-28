#!/bin/sh

# this script is executed daily by databank@cveda.nimhans.ac.in at 04:10 AM IST
#
# 1. It downloads data from the Delosis server into raw CSV files.
# 2. It pseudonynmizes the raw CSV files.
# 3. It derives the pseudoymized CSV files.
# 4. It temporarily derives the raw CSV files, for QC purposes only.

/cveda/databank/framework/cveda_databank/psytools/cveda_psytools_download.py 2>&1 | ts '%Y-%m-%d %H:%M:%S %Z' >> /var/log/databank/cveda_psytools_download.log
/cveda/databank/framework/cveda_databank/psytools/cveda_psytools_deidentify.py 2>&1 | ts '%Y-%m-%d %H:%M:%S %Z' >> /var/log/databank/cveda_psytools_deidentify.log
/cveda/databank/framework/cveda_r/R/cveda_psytools_derive.R 2>&1 | ts '%Y-%m-%d %H:%M:%S %Z' >> /var/log/databank/cveda_psytools_derive.log
/cveda/databank/framework/tmp/cveda_psytools_derive.R
