# openbabel gem

GEM for [OpenBabel](http://openbabel.sf.net), a chemical library by Geoff Hutchison and others.

openbabel gem has been tested with ruby 1.9 and 2.0. It compiles only on POSIX systems and requires the following programs and libraries (details at http://openbabel.org/docs/2.3.0/Installation/install.html#compiling-open-babel):

  * cmake 2.4.8 or later
  * curl
  * tar, sed, make (those should be present anyway)
  * libxml2 (optional)
  * zlib (optional)
  * Eigen 2.0.3 or later (optional)

## Install
gem install openbabel

It downloads the sources, compiles and installs OpenBabel (if not installed system wide) and ruby bindings.
If OpenBabel is not yet installed installation may last very long - please be patient.

Check out [http://cs.maunz.de](http://cs.maunz.de) for more information.
