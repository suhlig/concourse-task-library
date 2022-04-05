FROM alpine
RUN apk add ansible git openssh-client
ADD requirements.yml .
RUN ansible-galaxy install --role-file requirements.yml
CMD [ "ansible-playbook", "--version" ]
