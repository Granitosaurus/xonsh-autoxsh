# xonsh-autoxsh
Xontrib for Xonsh that allows automatic executions of xonsh scripts for specific directories.

<hr>

This extension automatically executes code in `.autoxsh` as xonsh script whenever you cd into a directory that contains it.
e.g.
```
cd testing
echo "print('it works!')" > .autoxsh
cd .
>> it works!
```

Some use cases:

virtual-environments with Xonsh's Vox:
```
echo "vox activate my_project" > my_project/.autoxsh
cd my_project
# virtualenvironment will activate here
```

## Installation
Just do a
```console
pip install xonsh-autoxsh
```

or you can clone the repo with pip
```console
pip install git+https://github.com/Granitas/xonsh-autoxsh
```

## Configuration
To automatically load autoxsh at startup, put
```console
xontrib load autoxsh
```

in your `.xonshrc`
