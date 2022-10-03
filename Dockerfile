FROM opensuse/leap:15.3

MAINTAINER trento-developers@suse.com

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install
RUN zypper -n ar https://download.opensuse.org/repositories/openSUSE:/Tools/openSUSE_15.3/openSUSE:Tools.repo && \
    zypper -n ar https://download.opensuse.org/repositories/devel:/languages:/go/15.3/devel:languages:go.repo && \
    zypper -n ar https://download.opensuse.org/repositories/OBS:/Server:/Unstable/15.3/OBS:Server:Unstable.repo && \
    zypper -n ar https://download.opensuse.org/repositories/devel:/languages:/erlang/openSUSE_Leap_15.3/devel:languages:erlang.repo && \
    zypper -n --gpg-auto-import-keys refresh --force --services && \
    zypper install -y sudo osc tar gzip build vim python3-packaging golang-packaging elixir wget unzip \
                      obs-service-obs_scm \
                      obs-service-obs_scm-common \
                      obs-service-recompress \
                      obs-service-set_version \
                      obs-service-source_validator \
                      obs-service-verify_file \
                      obs-service-go_modules \
                      obs-service-format_spec_file \
                      obs-service-tar_scm \
                      obs-service-download_files \
                      obs-service-node_modules

ARG USER_NAME=osc
ARG GROUP_NAME=$USER_NAME
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUP_NAME && useradd -m -g $USER_NAME -u $UID $USER_NAME
USER $USER_NAME
ENV HOME /home/$USER_NAME

COPY scripts /scripts
COPY --chown=$UID:$GID oscrc $HOME/.config/osc/oscrc
