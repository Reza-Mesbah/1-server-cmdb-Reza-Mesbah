#!/bin/bash

TARGET=10
BASEDIR=/opt/cmdb/servers/server01
DOCBASE=/opt/cmdb/docs

SALDO=1

# Check 2 - Automatic reboot
grep '^Unattended-Upgrade::Automatic-Reboot' $BASEDIR/etc/apt/apt.conf.d/50unattended-upgrades 2>/dev/null | grep -q true
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 3 - PasswordAuthentication no
grep -i '^PasswordAuthentication' $BASEDIR/etc/ssh/sshd_config 2>/dev/null | grep -q no
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 4 - PermitRootLogin no
grep -i '^PermitRootLogin' $BASEDIR/etc/ssh/sshd_config 2>/dev/null | grep -q no
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 5 - ubuntu user not exist
grep -q ubuntu $BASEDIR/etc/passwd 2>/dev/null
if [ $? -ne 0 ]; then SALDO=$((SALDO+1)); fi

# Check 6 - sam22 user exists
grep -q sam22 $BASEDIR/etc/passwd 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 7 - pm2 service
find $BASEDIR/etc/systemd/system -type f -name "*.service" 2>/dev/null | xargs grep -l pm2 2>/dev/null | xargs grep -q ExecStart 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 8 - Apache git redirect
find $BASEDIR/etc/apache2 -type f -name "*.conf" 2>/dev/null | xargs egrep "^Redirect" 2>/dev/null | grep 40 2>/dev/null | grep -q git
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 9 - Apache ServerTokens Prod
find $BASEDIR/etc/apache2 -type f -name "*.conf" 2>/dev/null | xargs grep -l "ServerTokens" 2>/dev/null | xargs grep -q Prod 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

# Check 10 - docker in package listing
find $DOCBASE -type f 2>/dev/null | xargs grep -iq docker 2>/dev/null
if [ $? -eq 0 ]; then SALDO=$((SALDO+1)); fi

echo "Score: $SALDO / $TARGET"
if [ $SALDO -eq $TARGET ]; then
  echo "SUCCESS"
else
  echo "FAILED"
fi
