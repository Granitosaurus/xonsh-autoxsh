import os
_AUTHORIZED_FILE = os.path.expanduser('~/.autoxonsh_authorized')
_IGNORE_FILE = os.path.expanduser('~/.autoxonsh_ignore')

@events.on_chdir
def auto_cd(olddir, newdir, **kw):
    target = os.path.join(newdir, '.autoxsh')
    target = os.path.expanduser(target)
    has_envfile = os.path.isfile(target)
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

__all__ = ()
__version__ = 0.3
