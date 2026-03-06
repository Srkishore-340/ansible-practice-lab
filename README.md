# Ansible Learning & Production-Style Starter Repository

This repository converts classroom-style Ansible notes into a **beginner-friendly but industry-structured project**.
It is designed for learning, interview preparation, and practicing real-world automation patterns.

## Learning Objectives
- Understand why Ansible is used in DevOps.
- Learn inventory, playbooks, modules, roles, handlers, and variables.
- Practice multi-environment structure (`dev`, `qa`, `uat`, `staging`, `prod`).
- Deploy Nginx in a production-like pattern.
- Validate automation using syntax checks and dry runs.

## Why Ansible is Needed
When infrastructure grows (microservices, multi-env deployments), manual server setup becomes slow and error-prone.
Ansible solves:
- Repeated manual work
- Configuration drift
- Inconsistent deployments
- Difficult scaling across many servers

## Architecture (Text Diagram)
```text
                +-----------------------+
                |   Control Node        |
                | (Ansible installed)   |
                +----------+------------+
                           |
                           | SSH (22)
                           v
      +--------------------+---------------------+
      |            Managed Nodes                 |
      | web-01 web-02 ... web-10 app-01 ...     |
      +------------------------------------------+

Flow:
Inventory -> Playbook -> Modules -> Desired State
```

## Repository Structure
```text
.
├── ansible.cfg
├── inventories/
│   ├── dev/
│   │   ├── group_vars/all.yml
│   │   └── hosts.ini
│   ├── prod/
│   │   ├── group_vars/all.yml
│   │   └── hosts.ini
│   ├── qa/
│   │   ├── group_vars/all.yml
│   │   └── hosts.ini
│   ├── staging/
│   │   ├── group_vars/all.yml
│   │   └── hosts.ini
│   └── uat/
│       ├── group_vars/all.yml
│       └── hosts.ini
├── notes/
│   └── structured-learning-notes.md
├── playbooks/
│   ├── deploy_nginx.yml
│   ├── ping.yml
│   └── site.yml
├── roles/
│   ├── common/
│   │   ├── defaults/main.yml
│   │   └── tasks/main.yml
│   └── nginx/
│       ├── defaults/main.yml
│       ├── handlers/main.yml
│       ├── tasks/main.yml
│       └── templates/
│           ├── index.html.j2
│           └── nginx.conf.j2
├── scripts/
│   └── bootstrap-control-node.sh
├── tests/
│   └── test-playbooks.sh
├── .gitignore
└── requirements.txt
```

## Prerequisites
- Linux/macOS terminal (or WSL on Windows)
- Python 3.9+
- SSH access to target hosts
- Sudo permissions on target hosts

## Installation Steps
```bash
git clone <your-repo-url>
cd <repo-name>
./scripts/bootstrap-control-node.sh
source .venv/bin/activate
```

## How to Run Playbooks
```bash
# 1) Connectivity
ansible-playbook -i inventories/dev/hosts.ini playbooks/ping.yml

# 2) Full baseline + nginx role
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml

# 3) Nginx-only rollout (serial)
ansible-playbook -i inventories/prod/hosts.ini playbooks/deploy_nginx.yml

# 4) Safe preview
ansible-playbook -i inventories/dev/hosts.ini playbooks/site.yml --check --diff
```

## Example Output (Typical)
```text
TASK [Install Nginx package] ************************************************
changed: [prod-web-01]
ok: [prod-web-02]

PLAY RECAP ******************************************************************
prod-web-01 : ok=6 changed=2 failed=0
prod-web-02 : ok=6 changed=0 failed=0
```

## Real-Time Use Case
**Scenario:** deploy Nginx on 10 production web servers.
- Add hosts in `inventories/prod/hosts.ini` under `[webservers]`.
- Run `playbooks/deploy_nginx.yml`.
- Use `serial: 3` for controlled rollout and reduced outage risk.

## Validation / Test Cases
```bash
# syntax validation
./tests/test-playbooks.sh

# optional lint if installed
ansible-lint playbooks/site.yml
```

## Best Practices
- Keep environment-specific data in `group_vars`.
- Use roles for reusable logic.
- Prefer modules over raw shell commands.
- Use `--check --diff` before production runs.
- Store secrets in Ansible Vault (not plain text files).
- Use serial/rolling deployments for production.

## Troubleshooting
- **UNREACHABLE**: check SSH key, user, security group/firewall, host IP.
- **Permission denied**: verify `become: true` and sudo permissions.
- **Package install fails**: confirm internet/repo mirror access on target hosts.
- **Template errors**: run syntax check and inspect missing variables.

## Future Improvements
- Add Ansible Vault demo for secret management.
- Add CI pipeline (GitHub Actions) for lint + syntax checks.
- Add Molecule tests for roles.
- Add blue/green deployment sample for zero-downtime updates.

## GitHub Setup & Push Commands

### 1) Initialize and first push
```bash
git init
git add .
git commit -m "feat: scaffold ansible learning and production-style starter repo"
git branch -M main
git remote add origin https://github.com/<username>/<repo>.git
git push -u origin main
```

### 2) Create repository in GitHub
1. Go to GitHub -> **New repository**.
2. Enter repository name (example: `ansible-learning-starter`).
3. Choose public/private.
4. Do **not** initialize with README (already exists locally).
5. Click **Create repository**.
6. Copy remote URL and run push commands above.

### 3) Suggested Branch Strategy
- `main`: stable production-ready branch
- `develop`: integration branch
- `feature/<topic>`: new enhancements
- `hotfix/<issue>`: urgent production fixes

Example:
```bash
git checkout -b feature/add-vault-demo
```

### 4) Commit Message Examples
- `feat: add nginx role with templates and handlers`
- `feat: add multi-environment inventory structure`
- `docs: add beginner-to-intermediate ansible learning notes`
- `test: add playbook syntax validation script`
- `chore: add ansible lint and local bootstrap script`

