#!/bin/bash
#
# 2010-07-22 Jeff McCune <jeff@puppetlabs.com>
#
# AffectedVersion: 2.6.0rc4
# FixedVersion: 2.6.0
#
# Description: using a defined type in the class it's declared in
# causes an error.
#
# 

set -u
source spec/setup.sh

execute_manifest cat <<'PP' | grep -q a_message_for_you
class foo {
  define do_notify($msg) {
    notify { "Message for $name: $msg": }
  }
  do_notify { 'test_one': msg => 'a_message_for_you' }
}
include foo
PP
rval=$?

if [ "$rval" -eq "0" ]; then
  exit $EXIT_OK
else
  exit $EXIT_FAILURE
fi

