FROM python:alpine
ARG VERSION
RUN apk add git openssh-client
RUN pip install ansible==${VERSION} --no-cache-dir
CMD [ "ansible-playbook", "--version" ]
