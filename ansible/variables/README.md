# Ansible variables - simple, human-friendly examples

I split each variable type into a separate playbook so you can run and understand one concept at a time.

## Files in this folder

1. `01-play-vars.yml`
   - Variables are defined at play level.
   - Every task in the play can use them.

2. `02-task-vars.yml`
   - Shows that task vars override play vars, but only inside that task.

3. `03-vars-files.yml` + `course-vars.yml`
   - Variables are stored in a separate file for cleaner playbooks.
   - A task-level value still overrides file values when needed.

4. `04-vars-prompt.yml`
   - Asks for username/password while running the playbook.
   - Password input is hidden (`private: true`).

5. `05-inventory-vars.yml` + `inventory-vars.ini`
   - Values are defined in inventory and consumed by the playbook.
   - Useful for host/environment-specific values.

6. `06-extra-vars.yml`
   - Values can be passed from CLI with `-e`.
   - Common in CI/CD where runtime values change often.

7. `07-precedence-demo.yml` + `precedence-vars.yml`
   - Quick precedence walkthrough in one playbook.
   - Demonstrates play vars, vars_files, task vars, and reminds that `-e` is highest.

## Run commands

```bash
ansible-playbook ansible/variables/01-play-vars.yml
ansible-playbook ansible/variables/02-task-vars.yml
ansible-playbook ansible/variables/03-vars-files.yml
ansible-playbook ansible/variables/04-vars-prompt.yml
ansible-playbook -i ansible/variables/inventory-vars.ini ansible/variables/05-inventory-vars.yml
ansible-playbook ansible/variables/06-extra-vars.yml -e "name=Ravi"
ansible-playbook -i ansible/variables/inventory-vars.ini ansible/variables/07-precedence-demo.yml -e "name=Kubernetes"
```
