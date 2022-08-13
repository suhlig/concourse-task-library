#!/usr/bin/env zsh

set -e

export ANSIBLE_CONFIG="$PLAYBOOK_PATH"/ansible.cfg
ansible-galaxy install --role-file "$PLAYBOOK_PATH"/requirements.yml

mkdir ~/.ssh
echo "$SSH_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

if [ -f "$PLAYBOOK_PATH"/"$INVENTORY" ]; then # it's a file; assume YAML
  for host in $(yq eval '.all.hosts.* | key' "$PLAYBOOK_PATH"/"$INVENTORY" ); do
    ssh-keyscan -H "$host" >> ~/.ssh/known_hosts
  done
  INVENTORY="$PLAYBOOK_PATH"/"$INVENTORY"
else # it's a string; assume single host
  ssh-keyscan -H "$INVENTORY" >> ~/.ssh/known_hosts
  INVENTORY="$INVENTORY", # if it's not a file, append a comma in order to mark it as list
fi

# jinja2-cli does not understand <(echo "$EXTRA_VARS")
echo "$EXTRA_VARS" > extra-variables.j2.yml
jinja2 -D pwd="$PWD" extra-variables.j2.yml -o extra-variables.yml

echo "$VAULT_PASSWORD" > .vault_password

ansible-playbook \
  "$PLAYBOOK_PATH"/playbook.yml \
  --inventory "$INVENTORY" \
  --extra-vars @extra-variables.yml \
  --vault-password-file .vault_password
