#!/bin/zsh

SCRIPTDIR=${0:a:h}
SF=100
OUTDIR=/mnt/data/tpcds/text/sf$SF
TPCDSTOOLSDIR=~/dev/tpcds/tpcds-kit/tools

pushd $TPCDSTOOLSDIR
mkdir -p $OUTDIR
./dsdgen -scale $SF -f -dir $OUTDIR -terminate n -verbose y
popd

# gen query cmd for ref...
# ./dsqgen -input ../query_templates/templates.lst -directory ../query_templates/ -output ../../queries/sf10 -scale 10 -dialect netezza -qualify y