# Structured Learning Notes: Ansible from Beginner to Intermediate

## 1) Why Ansible is Needed in DevOps
Ansible is needed because modern software runs on many servers (or VMs/containers), and manual configuration does not scale.

### Common manual problems
- Engineers log in server by server and run commands.
- Small mistakes create different configurations on each host (configuration drift).
- Deployments become slow and risky.

### Ansible value
- **Automation**: Run one playbook instead of repeating manual steps.
- **Consistency**: Same desired state on every server.
- **Speed**: Faster deployments and patching.
- **Agentless**: Uses SSH, no extra agent required on target hosts.

---

## 2) Real Company Problems Ansible Solves
In real companies, teams manage multiple environments:
- R&D/Dev
- QA
- UAT
- Staging
- Production

Each environment needs repeatable setup:
1. Install language/runtime
2. Create users/folders
3. Install packages
4. Pull code
5. Install dependencies
6. Create `systemd` services
7. Enable/start services

Ansible turns these into reusable code.

---

## 3) How Ansible Works Internally (Step-by-Step)
1. You run `ansible-playbook` from the **control node**.
2. Ansible reads the **inventory** (target host list).
3. It connects over **SSH** (key or password auth).
4. It executes modules on managed nodes.
5. Modules enforce desired state (idempotent behavior).
6. Ansible prints results (`ok`, `changed`, `failed`).

### Push model vs Pull model
- **Push (Ansible)**: Control node sends changes to targets.
- **Pull (e.g., Puppet/Chef agents)**: Target nodes periodically fetch changes.

---

## 4) Core Building Blocks

### Inventory
Server list and grouping (example: `webservers`, `appservers`).

### Playbook
YAML file containing automation steps.

### Module
A single unit of work (e.g., `package`, `service`, `user`, `file`, `template`).

### Role
Reusable bundle of tasks/handlers/templates/default vars.

### YAML
Human-friendly format used to define automation declaratively.

---

## 5) SSH in Ansible
Ansible usually uses SSH port 22 with:
- Host IP/DNS
- Username
- Authentication (SSH key preferred)

Example ad-hoc command:
```bash
ansible -i inventories/dev/hosts.ini all -m ping
```

---

## 6) Practical Scenario: Deploy Nginx on 10 Servers
### Business situation
You must deploy and start Nginx across 10 production web servers.

### Inventory group
Put all 10 servers in `[webservers]`.

### Playbook logic
- Install Nginx
- Copy config
- Enable + start service

### Why serial rollout matters
Use `serial: 3` (or similar) to avoid changing all servers at once.

---

## 7) Before vs After Automation

### Before Ansible
- 10 SSH sessions
- Repeated commands
- 30–60 minutes
- Higher human error

### After Ansible
- 1 command
- Standardized output
- Minutes to execute
- Better reliability

---

## 8) Command Examples (Interview-Friendly)
```bash
# Connectivity check
ansible -i inventories/dev/hosts.ini all -m ping

# Run full site playbook
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml

# Dry run (what will change)
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml --check --diff

# Limit to one group
ansible-playbook -i inventories/prod/hosts.ini playbooks/deploy_nginx.yml --limit webservers
```

---

## 9) Sample Playbook (Minimal)
```yaml
---
- name: Deploy Nginx
  hosts: webservers
  become: true
  tasks:
    - name: Install package
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Ensure service is running
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

---

## 10) Idempotency (Critical Concept)
Idempotency means running the same playbook many times gives the same final state.
- If already configured, Ansible reports `ok`.
- If changes are needed, it reports `changed`.

This solves repeated script execution problems.

---

## 11) Beginner to Intermediate Roadmap
1. Linux basics + SSH
2. YAML syntax
3. Inventory + ad-hoc commands
4. Playbooks + modules
5. Variables + templates
6. Roles + handlers
7. Environments (dev/qa/staging/prod)
8. Validation (`--syntax-check`, `--check`, `ansible-lint`)
9. CI integration
10. Vault/secrets + production rollout strategies

---

## 12) Interview Questions
### Basic
- What is Ansible and why agentless matters?
- Difference between inventory and playbook?

### Intermediate
- What is idempotency?
- Difference between playbook and role?
- What are handlers and when do they run?

### Scenario
- How do you safely deploy to 200 servers?
- How do you handle one failed host in a rollout?
- How do you separate dev/qa/prod configs?

