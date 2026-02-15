#!/usr/bin/env bash

set -euo pipefail
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# # --- 1. Getting GitLab token interactively if not set --------------------------------
# if [[ -z "${GITLAB_TOKEN:-}" ]]; then
#   read -r -s -p "Enter GitLab token: " GITLAB_TOKEN
#   echo
# fi
# export GITLAB_TOKEN        # will be used in the Docker container

# --- 2. Adjust SSH key permissions ---------------------------------------------
chmod 600 "/root/arc_ssh/id_rsa.private"

# --- 3. Start Ansible playbook run in Docker container --------------------------------
docker run --rm -it \
  -v "$PROJECT_DIR/init_new_vm/ansible":/ansible \
  -v "/tmp":/tmp \
  -v "/root/arc_ssh":/ssh:ro \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  -e GITLAB_TOKEN \
  --workdir /ansible \
  quay.io/ansible/ansible-runner:latest \
  ansible-playbook playbooks/main.yml "$@"
