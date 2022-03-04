#! /usr/bin/env python2
from subprocess import check_output

def get_pass(account):
    return check_output("PASSWORD_STORE_DIR=/home/rixx/.local/share/password-store pass Mail/" + account, shell=True).splitlines()[0].decode()


if __name__ == '__main__':
    print(get_pass('cutebit'))
