# REF: https://hub.docker.com/_/python
# Python 3.14.7-slim-trixie
FROM python:3.15.0-slim-trixie@sha256:2da676046630d7bf14c6764ae1143dc7fa0377a53f94bf5a642f0b214aca5bce

LABEL "com.github.actions.name"="Spellcheck Action"
LABEL "com.github.actions.description"="Check spelling of files in repository"
LABEL "com.github.actions.icon"="clipboard"
LABEL "com.github.actions.color"="green"
LABEL "repository"="http://github.com/step-security/spellcheck-github-actions"
LABEL "homepage"="https://github.com/step-security/spellcheck-github-actions"
LABEL "maintainer"="step-security"
LABEL "maintainer"="step-security <security@stepsecurity.io>"

COPY entrypoint.sh /entrypoint.sh
COPY requirements.txt /requirements.txt
COPY constraint.txt /constraint.txt
COPY spellcheck.yaml /spellcheck.yaml
COPY pwc.py /pwc.py

# REF: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#apt-get
ENV PIP_CONSTRAINT=/constraint.txt
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential pkg-config curl jq \
    libxml2-dev libxslt1-dev \
    zlib1g-dev \
    aspell hunspell \
    aspell-en hunspell-en-au hunspell-en-ca hunspell-en-gb hunspell-en-us \
    aspell-de hunspell-de-at hunspell-de-ch hunspell-de-de \
    aspell-es hunspell-es \
    aspell-fr hunspell-fr \
    aspell-ru hunspell-ru \
    aspell-uk hunspell-uk \
    aspell-it hunspell-it \
    aspell-pt-pt aspell-pt-br hunspell-pt-pt hunspell-pt-br \
    && pip3 install -r /requirements.txt \
    && pip3 install "setuptools>=83.0.0" "msgpack>=1.2.1" \
    && apt-get purge -y --auto-remove build-essential pkg-config libxml2-dev libxslt1-dev zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
