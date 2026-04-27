#!/bin/bash

TARGET=10
BASEDIR=/opt/cmdb/servers/server01
DOCBASE=/opt/cmdb/docs

SALDO=1
RESULT="RESULT: $SALDO"

# Check 2
grep '^Unattended-Upgrade::Automatic-Reboot' $BASEDIR/etc/apt/apt.conf.d/50unattended-upgrades | grep -q true
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 3
grep -i '^PasswordAuthentication' $BASEDIR/etc/ssh/sshd_config.d/* | grep -q no
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 4
grep -i '^PermitRootLogin' $BASEDIR/etc/ssh/sshd_config.d/* | grep -q no
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 5
grep -q ubuntu $BASEDIR/etc/passwd
if [ $? -ne 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 6
grep -q sam22 $BASEDIR/etc/passwd
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 7
find $BASEDIR/etc/systemd/system -type f -name "*.service" | xargs grep -l pm2 2>/dev/null | xargs grep -q ExecStart
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 8
find $BASEDIR/etc/apache2 -type f -name "*.conf" | xargs grep -l "Redirect" 2>/dev/null | xargs grep -q "\.git"
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 9
find $BASEDIR/etc/apache2 -type f -name "*.conf" | xargs grep -l "ServerTokens Prod" 2>/dev/null | grep -q .
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check 10
find $DOCBASE -type f | xargs grep -iq docker 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

if [ $SALDO -eq $TARGET ]; then
  echo "SUCCESS($RESULT)"
  exit 0
else
  echo "FAILED($RESULT)"
  exit 1
fi
