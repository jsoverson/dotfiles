#!/usr/bin/env zsh

TESTDIR=$0:A:h

source $TESTDIR/framework.sh

echo "# Testing positive cases"

ok "test ok()"
assert_equal "aaaa" "aaaa" "basic strings"

echo "# Testing negative cases"

assert_not_ok "$(not_ok)" "testing not_ok()"
assert_not_ok "$(assert_equal "aaaa" "bbbb")" "basic string inequality"
