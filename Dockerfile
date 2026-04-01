FROM opensuse/tumbleweed@sha256:e1e1a652a28384a3cae36938a84371de5e1c3d3a6d811d14caa1dd758366a934
# -----------------------^^^^^^^ 01 Apr 2026

# XXX: A key dependency (obs-service-elixir_mix_deps) is missing from the standard Tools repo. Until it's included, we switch to Tumbleweed. After inclusion, we have to revert to Leap base image.
# FROM opensuse/leap:15.6

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# install
# RUN <<EOF
# set -ex
# zypper -n ar https://download.opensuse.org/repositories/openSUSE:/Tools/15.6/openSUSE:Tools.repo
# zypper -n ar https://download.opensuse.org/repositories/devel:/sap:/trento:/builddeps/15.6/devel:sap:trento:builddeps.repo
# zypper -n --gpg-auto-import-keys refresh --force --services
# zypper install -y build \
#                   elixir \
#                   go \
#                   gzip \
#                   helm \
#                   obs-service-obs_scm \
#                   obs-service-obs_scm-common \
#                   obs-service-recompress \
#                   obs-service-set_version \
#                   obs-service-source_validator \
#                   obs-service-verify_file \
#                   obs-service-format_spec_file \
#                   obs-service-tar_scm \
#                   obs-service-download_files \
#                   obs-service-node_modules \
#                   obs-service-elixir_mix_deps \
#                   obs-scm-bridge \
#                   osc \
#                   sudo \
#                   tar \
#                   unzip \
#                   vim \
#                   yq \
#                   wget \
#                   make \
#                   openssh
# EOF
RUN <<EOF
set -ex
zypper install -y osc \
                  obs-scm-bridge \
                  obs-service-tar_scm \
                  obs-service-recompress \
                  obs-service-set_version \
                  obs-service-node_modules \
                  obs-service-elixir_mix_deps \
                  openssh \
                  tar \
                  unzip \
                  sudo \
                  vim \
                  yq \
                  wget
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
COPY --chown=0:0 oscrc /usr/local/share/osc/oscrc.sample
COPY --chown=0:0 oscrc /root/.config/osc/oscr
COPY --chown=$UID:$GID oscrc $HOME/.config/osc/oscrc
