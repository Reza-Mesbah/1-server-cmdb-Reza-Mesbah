#!/bin/bash
echo "=== CMDB Verification ==="

# Check 2
if grep -q 'Unattended-Upgrade::Automatic-Reboot "true"' servers/server01/etc/apt/apt.conf.d/50unattended-upgrades; then
    echo "[PASS] Check 2: Automatic reboot enabled"
else
    echo "[FAIL] Check 2: Automatic reboot NOT enabled"
fi

# Check 3
if grep -q 'PasswordAuthentication no' servers/server01/etc/ssh/sshd_config.d/*; then
    echo "[PASS] Check 3: Password authentication disabled"
else
    echo "[FAIL] Check 3: Password authentication NOT disabled"
fi

# Check 4
if grep -q 'PermitRootLogin no' servers/server01/etc/ssh/sshd_config.d/*; then
    echo "[PASS] Check 4: Root login disabled"
else
    echo "[FAIL] Check 4: Root login NOT disabled"
fi

# Check 5
if ! grep -q ubuntu servers/server01/etc/passwd; then
    echo "[PASS] Check 5: Ubuntu user removed"
else
    echo "[FAIL] Check 5: Ubuntu user still exists"
fi

# Check 6
if grep -q sam22 servers/server01/etc/passwd; then
    echo "[PASS] Check 6: sam22 user exists"
else
    echo "[FAIL] Check 6: sam22 user missing"
fi

# Check 7
if grep -q ExecStart servers/server01/etc/systemd/system/*.service 2>/dev/null; then
    echo "[PASS] Check 7: PM2 service with ExecStart exists"
else
    echo "[FAIL] Check 7: PM2 service missing"
fi

# Check 8
if grep -q 'RedirectMatch 404 /\.git' servers/server01/etc/apache2/conf-available/security.conf; then
    echo "[PASS] Check 8: Apache hides .git directory"
else
    echo "[FAIL] Check 8: Apache .git protection missing"
fi

# Check 9
if grep -q 'ServerTokens Prod' servers/server01/etc/apache2/conf-available/security.conf; then
    echo "[PASS] Check 9: Apache hides server info"
else
    echo "[FAIL] Check 9: Apache server info protection missing"
fi

# Check 10
if grep -q docker docs/installed_packages.txt; then
    echo "[PASS] Check 10: Docker in package list"
else
    echo "[FAIL] Check 10: Docker missing from package list"
fi

echo ""
echo "=== Full Test ==="
bash /tmp/test-cmdb.sh
