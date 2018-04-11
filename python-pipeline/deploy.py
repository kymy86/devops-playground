from __future__ import print_function
from ftplib import FTP
import os
import subprocess

HOST = os.getenv('FTP_HOST')
PASSW = os.getenv('FTP_PASS')
USER = os.getenv('FTP_USER')
PATH = os.getenv('DEPLOY_PATH')

def init_repo():
    """
    Init repo if this is the first deployment
    """
    res = subprocess.check_output(['git', 'ftp', 'init', '-u', USER, "-p", PASSW, "-v", "ftp://"+HOST+PATH])
    print(res)

def push_repo():
    """
    Push changes in staging/production environment
    """
    res = subprocess.check_output(['git', 'ftp', 'push', '-u', USER, "-p", PASSW, "-v", "ftp://"+HOST+PATH])
    print(res)

def main():
    """
    if files exist, push otherwise init
    """
    with FTP(host=HOST, passwd=PASSW, user=USER) as ftp:
        ftp.cwd(PATH)
        names = ftp.nlst(PATH)
        names = [x for x in names if x not in ['.', '..', 'cgi-bin']]
        if len(names) != 0:
            push_repo()
        else:
            init_repo()


if __name__ == '__main__':
    main()
