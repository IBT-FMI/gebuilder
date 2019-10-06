.TH GEBUILD 8
.SH NAME
gebuild \- generates software environments based on an ebuild specification
.SH SYNOPSIS
.B gebuild
.IR /path/to/.gentoo | stemgentoo
.I command
.SH DESCRIPTION
.B gebuild
is a Gentoo system and image builder which can produce system tarballs, OpenStack Images, and Docker containers based on the .gentoo live package distribution standard.

.SH OPTIONS

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
.
include(/dev/stdin)
.
.SH SEE ALSO
A more extensive description of the background for this project and the .gentoo specification is laid out in the summary of the semester project during which this project was initially launched (http://chymera.eu/docs/dominik_semesterarbeit.pdf).
Additionally, see the
.BR dotgentoo (5)
specification
