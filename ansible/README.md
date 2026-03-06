# Ansible Nginx Playbook Guide

This folder now includes an example playbook (`01-playbook.yaml`) that installs and runs **nginx** with clear inline comments.

## Playbook with Comments

```yaml
# This is a Play (top-level definition)
- name: install and run nginx          # Play name (just description)
  hosts: web                           # Target group from inventory
  become: yes                          # Use sudo (run tasks as root)

  tasks:                               # List of tasks to execute

    - name: install nginx              # Task 1 description
      ansible.builtin.package:         # Generic package module (works for apt/yum automatically)
        name: nginx                    # Package name
        state: present                 # Ensure nginx is installed

    - name: start nginx                # Task 2 description
      ansible.builtin.service:         # Service management module
        name: nginx                    # Service name
        state: started                 # Ensure service is running
        enabled: yes                   # Ensure service starts on boot
```

## Step-by-Step Explanation

### 1) `- name: install and run nginx`
Defines a **Play**.

A play contains:
- Target servers
- Tasks
- Privilege settings

Think: one play = apply these steps to these servers.

### 2) `hosts: web`
Refers to an inventory group.

Example:

```ini
[web]
10.0.0.1
10.0.0.2
10.0.0.3
```

So the play runs on all hosts in group `web`.

### 3) `become: yes`
Runs tasks with sudo privileges.

Without this, package/service tasks may fail due to permission issues.

### 4) `tasks:`
Tasks run **top to bottom**, sequentially.

## Task 1: Install nginx

```yaml
- name: install nginx
  ansible.builtin.package:
    name: nginx
    state: present
```

- Uses the generic `package` module.
- Automatically maps to OS package manager:
  - Ubuntu/Debian → `apt`
  - RHEL/CentOS → `yum`/`dnf`

`state: present` means:
- Install if missing
- Do nothing if already installed

This is **idempotent** behavior.

## Task 2: Start and enable nginx

```yaml
- name: start nginx
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: yes
```

Equivalent to:

```bash
systemctl start nginx
systemctl enable nginx
```

- `state: started` ensures the service is running.
- `enabled: yes` ensures it starts after reboot.

## Internal Execution Flow

When running:

```bash
ansible-playbook 01-playbook.yaml -i inventory.ini
```

Ansible will:
1. Read inventory
2. Select hosts in `web`
3. Connect over SSH
4. Check/install nginx
5. Check/start nginx service
6. Enable service on boot
7. Print summary

## Example Result

- First run: likely `changed=2`
- Second run: likely `changed=0`

Second run shows no changes because desired state is already met.

## Key Concept

You declare **desired state**, not imperative shell steps.

Desired state here:
- nginx package is installed
- nginx service is running
- nginx service is enabled at boot

## Interview Practice Questions

1. What is idempotency in Ansible?
2. Why use `package` instead of `apt` directly?
3. What does `become: yes` do?
4. What happens if nginx is already running?
5. How does Ansible choose apt/yum/dnf?

## Final Summary

This playbook:
1. Targets `web` servers
2. Uses sudo privileges
3. Ensures nginx is installed
4. Ensures nginx is running
5. Ensures nginx starts at boot
6. Is safe to run multiple times
