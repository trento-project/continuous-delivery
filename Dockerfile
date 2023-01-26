FROM opensuse/leap:15.4

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install
RUN zypper -n ar https://download.opensuse.org/repositories/openSUSE:/Tools/15.4/openSUSE:Tools.repo && \
    zypper -n ar https://download.opensuse.org/repositories/devel:/languages:/go/15.4/devel:languages:go.repo && \
    zypper -n ar https://download.opensuse.org/repositories/devel:/languages:/erlang/15.4/devel:languages:erlang.repo && \
    zypper -n --gpg-auto-import-keys refresh --force --services && \
    zypper install -y build \
                      elixir \
                      go \
                      gzip \
                      helm \
                      obs-service-obs_scm \
                      obs-service-obs_scm-common \
                      obs-service-recompress \
                      obs-service-set_version \
                      obs-service-source_validator \
                      obs-service-verify_file \
                      obs-service-format_spec_file \
                      obs-service-tar_scm \
                      obs-service-download_files \
                      obs-service-node_modules \
                      osc \
                      sudo \
                      tar \
                      unzip \
                      vim \
                      yq \
                      wget

ARG USER_NAME=osc
ARG GROUP_NAME=$USER_NAME
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUP_NAME && \
    useradd -m -g $USER_NAME -u $UID $USER_NAME && \
    echo "%$GROUP_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER_NAME
ENV HOME /home/$USER_NAME
WORKDIR $HOME

COPY scripts /scripts
COPY --chown=$UID:$GID oscrc $HOME/.config/osc/oscrc
