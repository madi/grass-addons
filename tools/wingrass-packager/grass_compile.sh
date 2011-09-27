#!/bin/sh
# Compile GRASS 6.4, 6.5 and 7.0 (update source code from SVN repository)

SRC=/osgeo4w/usr/src
PACKAGEDIR="mswindows/osgeo4w/package"

function update {
    echo "Updating $1..."     
    cd $SRC/$1
    svn up || (svn cleanup && svn up)
}

function rm_package_7 {
    for f in `/c/OSGeo4W/apps/msys/bin/find $PACKAGEDIR/grass*.tar.bz2 -mtime +7 2>/dev/null`; do
        rm -rfv $f
    done
}

function rsync_package {
    dst="/c/Users/landa/grass_packager/grass$1"
    rm -rf $dst/package
    cp -r $PACKAGEDIR $dst
}

function compile {
    cd $SRC/$1
    rm_package_7 
    curr=`ls -t $PACKAGEDIR/ 2>/dev/null | head -n1 | cut -d'-' -f3 | cut -d'.' -f1`
    if [ $? -eq 0 ]; then
	package=$(($curr+1))
    else
	package=1
    fi
    echo "Compiling $1 ($package)..."
    rm -f mswindows/osgeo4w/configure-stamp
    svn up || (svn cleanup && svn up)
    ./mswindows/osgeo4w/package.sh $package
    rsync_package $2
}

export PATH=$PATH:/c/OSGeo4W/apps/msys/bin

update grass_addons

compile grass64_release 64
compile grass6_devel 65
compile grass_trunk 70

exit 0
