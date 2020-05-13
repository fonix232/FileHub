#!/bin/sh

if ! [ -e /etc/telnetflag ]; then
	/usr/sbin/telnetd &
	touch /etc/telnetflag
	mod=1
else
	echo Telnet already active
fi
