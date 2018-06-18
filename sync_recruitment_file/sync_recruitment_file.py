#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import re
import datetime
import filecmp
import shutil
import logging
logging.basicConfig(level=logging.INFO)


LIVE_DIR = '/cveda/chroot/QC'
ARCHIVE_DIR = '/cveda/databank/framework/meta_data/_ARCHIVE/recruitment_files'

LIVE_REGEX = re.compile(r'recruitment_file_(\w+).xlsx')
ARCHIVE_REGEX = re.compile(r'recruitment_file_(\w+)_(\d{4})-(\d{2})-(\d{2}).xlsx')


def list_live(path):
    for recruitment_file in os.listdir(path):
        m = LIVE_REGEX.match(recruitment_file)
        if m:
            center = m.group(1)
            recruitment_file = os.path.join(path, recruitment_file)
            timestamp = os.path.getmtime(recruitment_file)
            modification_date = datetime.datetime.fromtimestamp(timestamp).date()
            yield center, modification_date, recruitment_file
        else:
            logging.error('%s: unexpected file name in: %s',
                          recruitment_file, LIVE_DIR)


def list_archive(path):
    result = {}
    for recruitment_file in os.listdir(path):
        m = ARCHIVE_REGEX.match(recruitment_file)
        if m:
            center = m.group(1)
            year = int(m.group(2))
            month = int(m.group(3).lstrip('0'))
            day = int(m.group(4).lstrip('0'))
            modification_date = datetime.date(year, month, day)
            recruitment_file = os.path.join(path, recruitment_file)
            yield center, modification_date, recruitment_file
        else:
            logging.error('%s: unexpected file name in: %s',
                          recruitment_file, LIVE_DIR)


def main():
    archive = {}
    for center, modification_date, path in list_archive(ARCHIVE_DIR):
        archive.setdefault(center, {})[modification_date] = path

    last = {center: (paths[max(paths)], max(paths))
            for center, paths in archive.items()}

    live = {}
    for center, modification_date, path in list_live(LIVE_DIR):
        live[center] = (path, modification_date)

    for center, (path, modification_date) in live.items():
        if center in last:
            last_path, last_modification_date = last[center]
            if not filecmp.cmp(path, last_path, False):
                if modification_date > last_modification_date:
                    archive_path = 'recruitment_file_{0}_{1:%Y-%m-%d}.xlsx'
                    archive_path = archive_path.format(center, modification_date)
                    archive_path = os.path.join(ARCHIVE_DIR, archive_path)
                    if os.path.exists(archive_path):
                        logging.warning('%s: file is already archived at this date: %s',
                                        path, archive_path)
                    else:
                        logging.info('%s: archiving file from %02d- into: %s',
                                      path, archive_path)
                        shutil.copyfile(path, archive_path)
                else:
                    logging.error('%s: file is older than archived file: %s',
                                  path, last_path)


if __name__ == '__main__':
    main()
