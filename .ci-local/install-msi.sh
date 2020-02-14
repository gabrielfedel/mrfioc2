#!/bin/sh
set -e -x


[ "$EPICS_BASE" ] || exit 0

CDIR=$EPICS_BASE/..
EPICS_HOST_ARCH=`sh $EPICS_BASE/startup/EpicsHostArch`

  case "$BASE" in
  *3.14*)
    ( cd "$CDIR" && wget https://www.aps.anl.gov/epics/download/extensions/extensionsTop_20120904.tar.gz && tar -xzf extensionsTop_*.tar.gz)

    ( cd "$CDIR" && wget https://www.aps.anl.gov/epics/download/extensions/msi1-7.tar.gz && tar -xzf msi1-7.tar.gz && mv msi1-7 extensions/src/msi)

    cat << EOF > "$CDIR/extensions/configure/RELEASE"
EPICS_BASE=$EPICS_BASE
EPICS_EXTENSIONS=\$(TOP)
EOF

    ( cd "$CDIR/extensions" && make )

    cp "$CDIR/extensions/bin/$EPICS_HOST_ARCH/msi" "$EPICS_BASE/bin/$EPICS_HOST_ARCH/"

    echo 'MSI:=$(EPICS_BASE)/bin/$(EPICS_HOST_ARCH)/msi' >> "$EPICS_BASE/configure/CONFIG_SITE"
    ;;
  *) ;;
  esac
