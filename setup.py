from distutils.core import setup

setup(
    name='xonsh-autoxsh',
    version='0.1',
    url='https://github.com/Granitas/xonsh-autoxsh',
    license='GPLv3',
    author='Bernardas Ališauskas',
    author_email='bernardas.alisauskas@gmail.com',
    description="Auto launcher of `.autoxsh` scripts for Xonsh shell's `cd` function",
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    platforms='any',
    classifiers=[
        'Environment :: Console',
        'Intended Audience :: End Users/Desktop',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Desktop Environment',
        'Topic :: System :: Shells',
        'Topic :: System :: System Shells',
]
)
