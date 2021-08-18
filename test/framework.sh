#!/usr/bin/env zsh

function not_ok() {
  MSG=$1
  if [[ ! $MSG == "" ]]; then
    MSG="# $MSG"
  fi
  echo "NOT OK $MSG"
}

function result() {
  RESULT=$1
  MSG=$2
  if [[ ! $MSG == "" ]]; then
    MSG="# $MSG"
  fi
  echo "$RESULT $MSG"
}

function ok() {
  result "OK" "$1"
}
function not_ok() {
  result "NOT OK" "$1"
}

function comment() {
  echo "# $@"
}

function compare() {
  comment "Actual: $1"
  comment "Expected: $2"
}

function assert_not_ok() {
  if [[ "$1" =~ ^NOT\ OK ]]; then
    ok "$2"
  else
    not_ok "$2"
    comment "Expected failure"
  fi
}

function assert_equal() {
  if [[ "$1" == "$2" ]]; then
    return 0
  else
    compare "$1" "$2"
    return 1
  fi
}

function run_tests() {
  typeset tests=()
  for fn in ${(ok)functions}; do
    if [[ $fn =~ ^test:: ]]; then
    tests+=$fn
    fi
  done
  readonly totalTests=${#tests} 
  echo "1..$totalTests"
  typeset testNum=0
  for fn in $tests; do
    testNum=$(($testNum + 1))
    output=$(eval $fn)
    code=$?
    if [[ $code -eq 0 ]]; then
      echo "ok $testNum # $fn"
    else
      echo "not ok $testNum # $fn"
      echo $output
    fi
  done
}
