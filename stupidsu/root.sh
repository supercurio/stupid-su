#!/system/bin/sh
#
# Author: François SIMOND @supercurio for StupidSU
# This is the installer

VERSION="`cat /stupidsu/VERSION`"
TAG="StupidSU #$VERSION"
SRCDIR="/stupidsu/files"
DSTDIR="/system/xbin"
SUPERSUBKPDIR="/system/bin/.ext"

_log()
{
	log -t "$TAG" $1
}

remount()
{
	_log "remount system as $1"
	mount -o remount,$1 /system
}

copy()
{
	DST="$DSTDIR/$1"
	_log "copy $1 to $DST"
	cat $SRCDIR/$1 > $DST
	chown root:root $DST
	chmod 06755 $DST
}

copy_supersu_backup()
{
	_log "copy backup su file for SuperSU"
	mkdir -p $SUPERSUBKPDIR
	chmod 755 $SUPERSUBKPDIR
	cat $SRCDIR/su > $SUPERSUBKPDIR/.su
	chmod 06755 $SUPERSUBKPDIR/.su
}

setup_real_su()
{
	test -f /data/app/com.koushikdutta.superuser*.apk \
		&& PROVIDER="koush" \
			&& _log "preparing su for Koush's Superuser" \
		|| PROVIDER="supersu" \
			&& copy_supersu_backup \
			&& _log "preparing su for SuperSU" \

	rm $DSTDIR/su-real
	ln -s $DSTDIR/su-$PROVIDER $DSTDIR/su-real
}

remount rw

cd $SRCDIR
for x in *; do
	copy $x
done

setup_real_su

remount ro
