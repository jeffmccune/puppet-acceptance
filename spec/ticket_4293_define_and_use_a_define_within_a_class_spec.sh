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

set -u
source spec/setup.sh

OUTPUT=/tmp/puppet-$$.output
MANIFEST=/tmp/puppet-$$-master/manifests/site.pp

trap '{ test -n "${master_pid:-}" && kill "${master_pid}" ; }' EXIT

driver_master_and_agent_locally_using_old_executables

puppet_conf <<'CONF'
[main]
  logdir=$vardir/log
  ssldir=$vardir/ssl
[puppetd]
  certname=puppetclient
  report=true
[puppetmasterd]
  reports=store
CONF

mkdir -p "$(dirname ${MANIFEST})"
cat <<'PP' >"${MANIFEST}"
class foo {
  define do_notify($msg) {
    notify { "Message for $name: $msg": }
  }
  do_notify { 'test_one': msg => 'a_message_for_you' }
}
node default {
  include foo
}
PP

puppetmasterd \
  --vardir /tmp/puppet-$$-master-var \
  --confdir /tmp/puppet-$$-master \
  --rundir /tmp/puppet-$$-master \
  --no-daemonize --autosign=true \
  --verbose --debug --color false \
  --certname=localhost --masterport 18140 2>&1 >"${OUTPUT}" &
master_pid=$!

# Wait for the master port to be availalbe
wait_until_master_is_listening $master_pid

start_puppetd

killwait ${master_pid}

trap '' EXIT
if grep -q a_message_for_you "${OUTPUT}"; then
  exit $EXIT_OK
else
  exit $EXIT_FAILURE
fi

