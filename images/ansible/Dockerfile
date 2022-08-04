FROM python:alpine
ARG VERSION
RUN apk add build-base git libffi-dev openssh-client zsh
RUN pip install \
          --no-cache-dir \
        ansible==${VERSION} \
        jinja2-cli
CMD [ "ansible-playbook", "--version" ]
