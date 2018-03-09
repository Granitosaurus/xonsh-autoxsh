#!/usr/bin/env xonsh
import os as _os
_AUTHORIZED_FILE = _os.path.expanduser('~/.autoxonsh_authorized')
_IGNORE_FILE = _os.path.expanduser('~/.autoxonsh_ignore')
del _os

@events.on_chdir
def _auto_cd(olddir, newdir, **kw):
    import os as _os
    target = _os.path.join(newdir, '.autoxsh')
    target = _os.path.expanduser(target)
    has_envfile = _os.path.isfile(target)
    del _os
    if not has_envfile:
        return
    # Deal with authorization
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
        msg = 'Unauthorized ".autoxsh" file found in this directory. Authorize and invoke? (y/n/ignore): '
        to_authorize = input(msg).lower()
        if "y" in to_authorize:
            authorized = True
            with open(_AUTHORIZED_FILE, 'a') as trust_file:
                trust_file.write('{}\n'.format(target))
        if "ignore" in to_authorize:
            with open(_IGNORE_FILE, 'a') as ignore_file:
                ignore_file.write('{}\n'.format(target))
    if authorized:
        source @(target)
