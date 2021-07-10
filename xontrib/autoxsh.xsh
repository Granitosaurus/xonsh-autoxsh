import os
_AUTHORIZED_FILE = os.path.join(__xonsh__.env['XONSH_DATA_DIR'], 'xontrib_autoxsh_authorized.txt')
_IGNORE_FILE = os.path.join(__xonsh__.env['XONSH_DATA_DIR'], 'xontrib_autoxsh_ignore.txt')


@events.on_chdir
def auto_cd(olddir, newdir, **kw):
    for tdir, file in [(olddir, '.leave.xsh'), (newdir, '.autoxsh'), (newdir, '.enter.xsh')]:
        run_script(tdir, file)


def run_script(tdir, file):
    target = os.path.join(tdir, file)
    target = os.path.expanduser(target)
    if not os.path.isfile(target):
        return

    # deal with authorization
    open(_AUTHORIZED_FILE, 'a').close()
    open(_IGNORE_FILE, 'a').close()

    # check whether dir is ignored
    with open(_IGNORE_FILE, 'r') as ignore_file:
        for line in ignore_file.readlines():
            if target in line:
                return

    # check whether dir is authorized
    authorized = False
    with open(_AUTHORIZED_FILE, 'r') as trust_file:
        for line in trust_file.readlines():
            if target in line:
                authorized = True
                break

    if not authorized:
        printx(f'{{YELLOW}}Unauthorized "{file}" file found in this directory. Authorize and invoke? (y/n/ignore): {{RESET}}', end='')
        to_authorize = input().lower()
        if "y" in to_authorize:
            authorized = True
            with open(_AUTHORIZED_FILE, 'a') as trust_file:
                trust_file.write('{}\n'.format(target))
        if "ignore" in to_authorize:
            with open(_IGNORE_FILE, 'a') as ignore_file:
                ignore_file.write('{}\n'.format(target))

    if authorized:
        source @(target)


__all__ = ()
__version__ = 0.4
