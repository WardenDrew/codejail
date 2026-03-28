FROM alpine:latest

ARG USER_ID
ARG GROUP_ID

RUN addgroup -g ${GROUP_ID} codejail \
  && adduser -u ${USER_ID} -D -h /home/codejail codejail -G codejail;

RUN apk add --no-cache \
  bash \
  font-source-code-pro-nerd \
  curl \
  neovim \
  jq \
  nodejs \
  npm \
  bubblewrap;

WORKDIR /root
COPY --chown=codejail:codejail --chmod=+x starship.sh starship.sh
RUN ./starship.sh --yes;
RUN rm starship.sh;

USER codejail
WORKDIR /home/codejail
COPY --chown=codejail:codejail .bashrc .bashrc

RUN mkdir .npm-global;
RUN npm config set prefix '~/.npm-global';
RUN npm install -g @openai/codex \
  && npm cache clean --force;

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
WORKDIR /home/codejail/cell
