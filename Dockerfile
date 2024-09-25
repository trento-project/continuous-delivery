FROM opensuse/leap:15.6

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# install
RUN <<EOF
set -ex
zypper -n ar https://download.opensuse.org/repositories/openSUSE:/Tools/15.6/openSUSE:Tools.repo
zypper -n ar https://download.opensuse.org/repositories/devel:/sap:/trento:/builddeps/15.6/devel:sap:trento:builddeps.repo
zypper -n --gpg-auto-import-keys refresh --force --services
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
                  wget \
                  make \
                  openssh
EOF

ARG USER_NAME=osc
ARG GROUP_NAME=$USER_NAME
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUP_NAME && useradd -m -g $USER_NAME -u $UID $USER_NAME
USER $USER_NAME
ENV HOME=/home/$USER_NAME
WORKDIR $HOME

COPY scripts /scripts
COPY --chown=$UID:$GID oscrc $HOME/.config/osc/oscrc
