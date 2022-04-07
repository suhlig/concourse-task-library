FROM python:alpine
ARG VERSION
RUN apk add build-base git libffi-dev openssh-client
RUN pip install ansible==${VERSION} --no-cache-dir
CMD [ "ansible-playbook", "--version" ]
