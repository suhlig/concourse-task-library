#!/usr/bin/env zsh

set -e

main() {
  configure-ansible
  configure-vault-password
  configure-inventory
  configure-extra-vars
  install-roles
  configure-ssh
  run-play
}

configure-ansible() {
  export ANSIBLE_CONFIG="$PLAYBOOK_PATH"/ansible.cfg
}

configure-vault-password() {
  echo "$VAULT_PASSWORD" > .vault_password
}

configure-inventory() {
  if [ -f "$PLAYBOOK_PATH"/"$INVENTORY" ]; then
    # It's a file
    export ANSIBLE_INVENTORY="$PLAYBOOK_PATH"/"$INVENTORY"
  else
    # It's a string; assume list of hosts. We append a comma in order to make it a list, even if there is only one host.
    export ANSIBLE_INVENTORY="$INVENTORY",
  fi
}

configure-extra-vars() {
  # jinja2-cli does not accept the template from STDIN, otherwise this could become a single
  # jinja2 -D pwd="$PWD" - <<<"$EXTRA_VARS" | tee extra-variables.yml
  echo "$EXTRA_VARS" > extra-variables.j2.yml
  jinja2 -D pwd="$PWD" extra-variables.j2.yml -o extra-variables.yml
}

install-roles() {
  ansible-galaxy install --role-file "$PLAYBOOK_PATH"/requirements.yml
}

configure-ssh() {
  mkdir -p ~/.ssh
  echo "$SSH_KEY" > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa

  # Trust all servers' public keys.
  # Defaults to the empty string if not present.
  ansible-inventory \
    --list \
    --playbook-dir "$PLAYBOOK_PATH" \
    --extra-vars @extra-variables.yml \
    --vault-password-file .vault_password \
  | yq eval '._meta.hostvars.*.public_key // ""' - \
  >> ~/.ssh/known_hosts
}

run-play() {
  ansible-playbook \
    --extra-vars @extra-variables.yml \
    --vault-password-file .vault_password \
    "$PLAYBOOK_PATH"/"$PLAYBOOK_NAME"
}

main "$@"
