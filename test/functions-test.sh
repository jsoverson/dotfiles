#!/usr/bin/env zsh

TESTDIR=$0:A:h

source $TESTDIR/framework.sh
source $TESTDIR/../source/functions.zshrc

function test::dedupe_pathlike() {
  typeset actual=$(dedupe_pathlike "a:b:c:d")
  assert_equal "$actual" "a:b:c:d" "dedupe should not alter string with no duplicates"
}

function test::test_prepend_to_pathlike() {
  readonly newstring=$(prepend_to_pathlike "a:b:c" "new")
  assert_equal "$newstring" "new:a:b:c" 'should append to path'
  $? && assert_equal "$newstring" "new:a:b:c" 'should append to path'
}

function test::test_append_to_pathlike() {
  readonly newstring=$(append_to_pathlike "a:b:c" "new")
  assert_equal "$newstring" "a:b:c:new" 'should append to path'
}

run_tests
