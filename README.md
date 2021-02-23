# xonsh-autoxsh

Automatically execution of `.autoxsh` xonsh script after entering (cd-ing) into the directory.

[![PyPi version](https://img.shields.io/pypi/v/xonsh-autoxsh.svg?style=flat-square)](https://pypi.python.org/pypi/xonsh-autoxsh) [![PyPi license](https://img.shields.io/pypi/l/xonsh-autoxsh.svg?style=flat-square)](https://pypi.python.org/pypi/xonsh-autoxsh) [![PyPi license](https://img.shields.io/pypi/pyversions/xonsh-autoxsh.svg?style=flat-square)](https://pypi.python.org/pypi/xonsh-autoxsh)  

## Installation
```python
pip install xonsh-autoxsh
# OR: pip install git+https://github.com/Granitas/xonsh-autoxsh
echo 'xontrib load autoxsh' >> ~/.xonshrc
```

## Use cases

### Run xonsh script after entering (cd-ing) into the directory

```python
mkdir -p /tmp/dir
echo "print('it works!')" > /tmp/dir/.autoxsh
cd /tmp/dir
# Unauthorized ".autoxsh" file found in this directory. Authorize and invoke? (y/n/ignore): y
# it works!
cd /
cd /tmp/dir
# it works!
```

### Activate Python virtual environment with vox

```python
xontrib load vox
vox new myenv
mkdir -p /tmp/dir
echo "vox activate myenv" > /tmp/dir/.autoxsh
cd /tmp/dir
# Activated "myenv".
```

## Links 
* This package is the part of [ergopack](https://github.com/anki-code/xontrib-ergopack) - the pack of ergonomic xontribs.
* This package was created with [xontrib cookiecutter template](https://github.com/xonsh/xontrib-cookiecutter).
