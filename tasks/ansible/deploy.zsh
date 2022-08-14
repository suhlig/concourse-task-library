#!/usr/bin/env zsh

set -e

main() {
  install-roles
  configure-ssh
  write-extra-vars
  write-vault-password
  configure-inventory
  run-play
}

install-roles() {
  export ANSIBLE_CONFIG="$PLAYBOOK_PATH"/ansible.cfg
  ansible-galaxy install --role-file "$PLAYBOOK_PATH"/requirements.yml
}

configure-ssh() {
  mkdir ~/.ssh
  echo "$SSH_KEY" > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa

  # Trust all servers public keys
  yq eval '.all.hosts.*.public_key' deployment/inventory.yml >> ~/.ssh/known_hosts
}

write-extra-vars() {
  # jinja2-cli does not accept the template from STDIN, otherwise this could become a single
  # jinja2 -D pwd="$PWD" - <<<"$EXTRA_VARS" | tee extra-variables.yml
  echo "$EXTRA_VARS" > extra-variables.j2.yml
  jinja2 -D pwd="$PWD" extra-variables.j2.yml -o extra-variables.yml
}

write-vault-password() {
  echo "$VAULT_PASSWORD" > .vault_password
}

configure-inventory() {
  if [ -f "$PLAYBOOK_PATH"/"$INVENTORY" ]; then
    # It's a file; assume YAML.
    INVENTORY="$PLAYBOOK_PATH"/"$INVENTORY"
  else
    # It's a string; assume single host. We append a comma in order to make it a list.
    INVENTORY="$INVENTORY",
  fi
}

run-play() {
  ansible-playbook \
    "$PLAYBOOK_PATH"/playbook.yml \
    --inventory "$INVENTORY" \
    --extra-vars @extra-variables.yml \
    --vault-password-file .vault_password
}

main "$@"
