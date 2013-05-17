#!/system/bin/sh
#
# Author: François SIMOND @supercurio for StupidSU
# This is the installer

SRCDIR="/stupidsu/files"
DSTDIR="/system/xbin"

remount()
{
	mount -o remount,$1 /system
}

copy()
{
	cat $SRCDIR/$1 > $DSTDIR/$1
	chown root:root $DSTDIR/$1
	chmod 06755 $DSTDIR/$1
}

link_real_su()
{
	test -f /data/app/com.koushikdutta.superuser*.apk \
		&& PROVIDER="koush" \
		|| PROVIDER="supersu"

	rm $DSTDIR/su-real
	ln -s $DSTDIR/su-$PROVIDER $DSTDIR/su-real
}

remount rw

cd $SRCDIR
for x in *; do
	copy $x
done

link_real_su

remount ro
