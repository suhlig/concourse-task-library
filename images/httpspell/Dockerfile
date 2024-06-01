ARG base_image=ruby:alpine
ARG PANDOC_VERSION=latest-static
FROM $base_image as base
ARG base_image
RUN apk add \
    gcompat \
    hunspell \
    hunspell-de-de \
    hunspell-en-us \
    zsh

# Enable default language variants
RUN ln -s /usr/share/hunspell/en_US.aff /usr/share/hunspell/en.aff && \
  ln -s /usr/share/hunspell/en_US.dic /usr/share/hunspell/en.dic && \
  ln -s /usr/share/hunspell/de_DE.aff /usr/share/hunspell/de.aff && \
  ln -s /usr/share/hunspell/de_DE.dic /usr/share/hunspell/de.dic

FROM pandoc/minimal:$PANDOC_VERSION as pandoc

FROM caddy:alpine as caddy

FROM base

COPY --from=pandoc /pandoc /usr/local/bin/pandoc
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy

ARG HTTPSPELL_VERSION=>=0
RUN gem install httpspell --version "${HTTPSPELL_VERSION}"

CMD [ "zsh", "-c", "pandoc --version; echo; hunspell -vv; echo Caddy $(caddy version); httpspell --version" ]
