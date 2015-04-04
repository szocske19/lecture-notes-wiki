Scripts
=======

We provided ``compile_*.bat`` and ``compile_*.sh`` scripts for compiling the Markdown files to PDFs, e.g. the ``compile_bpmn`` script compiles the ``bpmn.md`` file to ``bpmn.pdf``.
The ``compile_full`` scripts compile all Markdown files.

Windows
-------

Tested on Windows 8 with both MiKTeX and TeX Live.

Install pandoc from <https://code.google.com/p/pandoc/downloads/list>.

Warning: TeXlive only works if your username is (1) at most 8 characters long (2) only contains latin alphanumeric characters (no whitespaces, no accented characters).

The release script requires a command-line SVN client:
- TortoiseSVN contains a command-line but does not install it by default -- run the TortoiseSVN installer again if you forgot it
- use a command-line only client such as SlikSVN <http://www.sliksvn.com/en/download>.

Linux
-----

Tested on Linux Mint 16 with TeX Live. Install the ``texlive-full`` package (``texlive`` alone is not sufficient, e.g. we use the ``fourier`` package) and the ``pandoc`` package.

Releasing
---------

Set the ``svn:mime-type`` property to ``application/pdf``. In command line, use the following command

```bash
svn propset svn:mime-type application/pdf document.pdf
```

If you use TortoiseSVN, right click the file and choose **TortoiseSVN** | **Properties**.

Troubleshooting
===============

The following error shows up:

```
pandoc: Error producing PDF from TeX source.
! Undefined control sequence.
l.58 \Oldincludegraphics
```

Solution: include any image. Like this :-).

![The logo of the Fault-Tolerant Systems Research Group](ftsrg_logo.png)

