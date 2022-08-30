ARG base_image=python:alpine
FROM ${base_image}
RUN apk add \
        build-base \
        git \
        libffi-dev \
        openssh-client \
        rsync \
        yq \
        zsh
ARG VERSION
RUN pip install \
          --no-cache-dir \
        ansible==${VERSION} \
        jinja2-cli
CMD [ "ansible-playbook", "--version" ]
