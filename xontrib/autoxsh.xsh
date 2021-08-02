import os
from pathlib import Path
_AUTHORIZED_FILE = os.path.join(__xonsh__.env['XONSH_DATA_DIR'], 'xontrib_autoxsh_authorized.txt')
_IGNORE_FILE = os.path.join(__xonsh__.env['XONSH_DATA_DIR'], 'xontrib_autoxsh_ignore.txt')
_ENTER_FILE = '.enter.xsh'
_LEAVE_FILE = '.leave.xsh'


# create auth / ignore files
open(_AUTHORIZED_FILE, 'a').close()
open(_IGNORE_FILE, 'a').close()


@events.on_chdir
def auto_cd(olddir, newdir, **kw):
    olddir = Path(olddir).expanduser().resolve()
    newdir = Path(newdir).expanduser().resolve()
    commonpath = Path(os.path.commonpath([olddir, newdir]))

    tlist = []

    if __xonsh__.env.get('AXSH_CHECK_PARENTS', False):
        # directories left
        if olddir > commonpath:
            tlist += [(olddir, _LEAVE_FILE)]

        tlist += [(parent, _LEAVE_FILE) for parent in olddir.parents if parent > commonpath]

        # directories entered
        tlist += [(parent, _ENTER_FILE) for parent in reversed(newdir.parents) if parent > commonpath]

        if newdir > commonpath:
            tlist += [(newdir, _ENTER_FILE)]
    else:
        tlist += [(olddir, _LEAVE_FILE), (newdir, '.autoxsh'), (newdir, _ENTER_FILE)]

    for tdir, file in tlist:
        run_script(tdir, file)


def run_script(tdir, file):
    debug = __xonsh__.env.get('AXSH_DEBUG', False)

    target = tdir / file

    if debug:
        printx(f'{{YELLOW}}[axsh]{{RESET}} checking file: {target}')

    if not os.path.isfile(target):
        return

    if debug:
        printx(f'{{YELLOW}}[axsh]{{RESET}} ... file found')

    # check whether dir is ignored
    with open(_IGNORE_FILE, 'r') as ignore_file:
        for line in ignore_file.readlines():
            if target in line:
                return

    # check whether dir is authorized
    authorized = False
    with open(_AUTHORIZED_FILE, 'r') as trust_file:
        for line in trust_file.readlines():
            if str(target) in line:
                authorized = True
                break

    if not authorized:
        printx(f'{{INTENSE_YELLOW}}[axsh]{{RESET}} Unauthorized "{{INTENSE_RED}}{file}{{RESET}}" file found in this directory. Authorize and invoke? (y/n/ignore): ', end='')
        to_authorize = input().lower()
        if "y" in to_authorize:
            authorized = True
            with open(_AUTHORIZED_FILE, 'a') as trust_file:
                trust_file.write('{}\n'.format(target))
        if "ignore" in to_authorize:
            with open(_IGNORE_FILE, 'a') as ignore_file:
                ignore_file.write('{}\n'.format(target))

    if authorized:
        if debug:
            printx(f'{{YELLOW}}[axsh]{{RESET}} executing')
        source @(target)


__all__ = ()
__version__ = 0.4
