.TH GEBUILD 8
.
.SH NAME
gebuild \- generates software environments based on an ebuild specification
.
.SH SYNOPSIS
.B gebuild
.IR /path/to/.gentoo | stemgentoo
.I command
.
.SH DESCRIPTION
.B gebuild
is a Gentoo system and image builder which can produce system tarballs, OpenStack Images, and Docker containers based on the .gentoo live package distribution standard.
.
.SH OPTIONS
.
.TP
.I /path/to/.gentoo|stemgentoo
Either a path to a .gentoo directory, or the literal stemgentoo, where the latter
is the parent image that serves as a basis for all the specialized .gentoo systems.
.TP
.I command
The command to execute.
These commands are defined in the scripts directory of the gebuilder installation.
If gebuild is called with \fI"command"\fP as second argument, then all the scripts
inside scripts/command/default/ (or scripts/command/stemgentoo/, if the first
argument is "\fIstemgentoo\fP") are executed in alphabetic order.
For a high-level description what these script-chains do, refer to the rest of this manual.
.SH NOTES
gebuild is a collection of shell\-scripts that automate the creation,
maintenance and format changes of a Gentoo System.
.PP
Each Gentoo\-System is stored in a directory \f[C]IMAGESDIR/roots/<ID>/root/\f[].
\f[C]<ID>\f[] is one of:
.IP \[bu] 2
\f[C]stemgentoo\f[]
.IP \[bu] 2
An ID corresponding to the \f[C].gentoo\f[]\-directory the image is based off
.SS
Initialization
.PP
To initialize gebuild, you need to run \f[C]gebuild stemgentoo initialize\f[].
This command builds the \f[C]stemgentoo\f[] and sets up all the necessary variables.
.PP
To update the stemgentoo, use the command \f[C]gebuild stemgentoo update\f[]
.SS
Machine Types
.PP
The machine\-type decides which set of scripts get executed.
Currently, there are two machine types defined:
.IP \[bu] 2
stemgentoo
.IP \[bu] 2
default
.PP
The latter get based off the stemgentoo when initializing them.
.SS
Commands
.PP
Commands are defined in \f[C]GEBUILDER_ROOT/scripts/\f[]. If we want to execute \f[C]command\f[] for
a machine of type \f[C]machinetype\f[],
all scripts in \f[C]GEBUILDER_ROOT/scripts/command/machinetype/\f[] are executed in lexical order.
.SS
Scripts
.PP
Scripts are executable files stored in \f[C]GEBUILDER_ROOT/scripts/command/machinetype/\f[].
If their name ends in \f[C].chroot\f[], the BuildServer will chroot to the specific root
before executing the commands.
If their name ends in \f[C].nolog\f[], logging is turned off for the script, otherwise a file
is generated in the root directory of the images for every script.
If it is a directory (or even a symlink to a directory), all executable files contained
therein will be executed.
.SS
Error Handling
.PP
Error handling is provided with the shell.
We track whether a command fails with \f[C]trap <func> ERR\f[].
This means that as soon as any command ends with a non\-zero exit status, we jump to \f[C]<func>\f[]
.PP
We can add cleanup\-tasks to this error\-handler with the shell\-function
\f[C]on_error "<str>"\f[].
This function adds the string \f[C]<str>\f[] to a stack.
In the case of an error these strings get popped from the stack and evaluated.
.SS
Cleanup
.PP
Cleanup works exactly the same as error\-handling, but it gets executed always before exiting the shell,
and functions are added with \f[C]on_exit "<str>"\f[]
.PP
In case of an error, first the cleanup\-stack and then the error\-stack get processed.
.SS
Configuration
.PP
Configuration files are shell\-scripts that end in \f[C].conf\f[].
They get sourced just before executing the command scripts.
The following directories are searched for \f[C].conf\f[] files.
.IP \[bu] 2
\f[C]GEBUILDER_ROOT/config/\f[]
.IP \[bu] 2
\f[C]IMAGESDIR/roots/<ID>/config/\f[]
.SS
You can copy example configuration files from the default \f[C]GEBUILDER_ROOT/config/\f[] location to \f[C]IMAGESDIR/roots/<ID>/config/\f[] to customize settings for specific systems.

Chroot\-configuration
.PP
If you want to use these configuration parameters inside a chrootet script,
make sure to export them into the environment variables first!
.SS
Hooks
.PP
The images allow for configuration inside their directories.
.PP
There are two types of hooks:
.IP \[bu] 2
pre and post command hooks: these are additional scripts executed in a command
.IP \[bu] 2
command chains: these allow executing another command after one has finished
.SS
Pre and Post Hooks
.PP
Images can hook into the commands via \f[C]IMAGESDIR/roots/<ID>/hooks/<command>/pre\f[]
and \f[C]post\f[].
Everything in \f[C]pre\f[] gets executed before the scripts in \f[C]IMAGESDIR/hooks/<command>/<machinetype>\f[],
everything in \f[C]post\f[] afterwords.
.SS
Command\-Chaining
.PP
If you wish to execute a command after another command has finished, you can specify that via \f[C]IMAGESDIR/roots/<ID>/hooks/<command>/chain\f[]
which is a file containing all the commands that should be executed after \f[C]command\f[].
Every command should stand in its own line (\f[C]\en\f[]\-separated)
.SS
Logging
.PP
Logging is done in the directory specified in the config files
By default, this has the form \f[C]IMAGESDIR/roots/<ID>/logs/<command>/\f[]
.PP
Every script that is executed generates its own log\-file, into which the script stdout and stderr are piped.
For example, if a command contains a script called \f[C]00\-setup.sh\f[], its output will be written to the file \f[C]00\-setup.sh.log\f[].
.
.SH COMMANDS
The rest of this document is a list of all the available commands and a description of them
include(/dev/stdin)
.
.SH SEE ALSO
A more extensive description of the background for this project and the .gentoo specification is laid out in the summary of the semester project during which this project was initially launched (http://chymera.eu/docs/dominik_semesterarbeit.pdf).
Additionally, see the
.BR dotgentoo (5)
specification
