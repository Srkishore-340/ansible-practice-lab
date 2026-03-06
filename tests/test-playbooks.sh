#!/usr/bin/env bash
set -euo pipefail

ansible-playbook -i inventories/dev/hosts.ini playbooks/ping.yml --syntax-check
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml --syntax-check
ansible-playbook -i inventories/dev/hosts.ini playbooks/deploy_nginx.yml --syntax-check

echo "All playbook syntax checks passed"
