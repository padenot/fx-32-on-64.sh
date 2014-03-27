# fx-32-on-64.sh
This automates the steps for compiling a 32bits Firefox on a 64bits Ubuntu
machine.

# Why ?

To debug Firefox with <http://rr-project.org/>.

# How ?

Read the top of the script `./fx-32-on-64.sh`, maybe tweak a couple variables,
and then run it.

This uses a chroot, because these days, getting all the 32bits packages to
compile a Firefox 32 on Ubuntu 64 is not trivial.

# License

MPL
