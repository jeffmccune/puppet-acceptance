#!/bin/bash
#
#  test that the string 'false' evaluates to true
#
source lib/setup.sh

OUTFILE="/tmp/spec-$$.log"

puppet <<PP | tee $OUTFILE
if 'false' {
  notice('true')
} else {
  notice('false')
}
PP
grep 'true' $OUTFILE
