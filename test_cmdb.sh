#!/bin/bash

TARGET=10
BASEDIR=/opt/cmdb/servers/server01
DOCBASE=/opt/cmdb/docs

SALDO=1
RESULT="RESULT: $SALDO"

# Check for automatic reboot
grep '^Unattended-Upgrade::Automatic-Reboot' $BASEDIR/etc/apt/apt.conf.d/50unattended-upgrades 2>/dev/null | grep -q true
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check for password auth
grep -i '^PasswordAuthentication' $BASEDIR/etc/ssh/sshd_config 2>/dev/null | grep -q no
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check for root login
grep -i '^PermitRootLogin' $BASEDIR/etc/ssh/sshd_config 2>/dev/null | grep -q no
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check for ubuntu user (should NOT exist)
grep -q ubuntu $BASEDIR/etc/passwd 2>/dev/null
if [ $? -ne 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check for sam22 user
grep -q sam22 $BASEDIR/etc/passwd 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check for pm2 service
find $BASEDIR/etc/systemd/system -type f -name "*.service" 2>/dev/null | xargs grep -l pm2 2>/dev/null | xargs grep -q ExecStart 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

# Check Apache git redirect
if [ -d "$BASEDIR/etc/apache2" ]; then
  find $BASEDIR/etc/apache2 -type f -name "*.conf" 2>/dev/null | xargs grep -l "Redirect" 2>/dev/null | xargs grep "40" 2>/dev/null | grep -q git
  if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
fi
RESULT="$RESULT - $SALDO"

# Check Apache ServerTokens
if [ -d "$BASEDIR/etc/apache2" ]; then
  find $BASEDIR/etc/apache2 -type f -name "*.conf" 2>/dev/null | xargs grep -l "ServerTokens" 2>/dev/null | xargs grep -q Prod
  if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
fi
RESULT="$RESULT - $SALDO"

# Check for docker in package listing
find $DOCBASE -type f 2>/dev/null | xargs grep -iq docker 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$(($SALDO+1)); fi
RESULT="$RESULT - $SALDO"

echo "Score: $SALDO / $TARGET"
if [ $SALDO -eq $TARGET ]; then
  echo "SUCCESS ($RESULT)"
else
  echo "FAILED ($RESULT)"
fi
