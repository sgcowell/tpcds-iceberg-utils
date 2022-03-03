#!/bin/zsh

SCRIPTDIR=${0:a:h}
SF=10
OUTDIR=~/warehouse/tpcds/text/sf$SF

pushd $SCRIPTDIR/../tpcds-kit/tools
mkdir $OUTDIR
./dsdgen -scale $SF -f -dir $OUTDIR -terminate n
popd

# gen query cmd for ref...
# ./dsqgen -input ../query_templates/templates.lst -directory ../query_templates/ -output ../../queries/sf10 -scale 10 -dialect netezza -qualify y