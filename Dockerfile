FROM opensuse/tumbleweed@sha256:e1e1a652a28384a3cae36938a84371de5e1c3d3a6d811d14caa1dd758366a934
# ^ `tumbleweed` base image as of 01 Apr 2026

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN <<EOF
set -ex
# We need this repo only because of `obs-service-regex_replace`
zypper -n ar -p 101 -f https://download.opensuse.org/repositories/openSUSE:/Tools/openSUSE_Tumbleweed/openSUSE:Tools.repo
# Until obs-service-vendor_helm is included into Tools repo, we add kkanchev's home project.
# https://build.opensuse.org/requests/1350205
zypper -n ar -p 105 -f https://download.opensuse.org/repositories/home:/kkanchev/openSUSE_Tumbleweed/home:kkanchev.repo
zypper -n --gpg-auto-import-keys refresh --force --services

# osc -- needed everywhere
# obs-scm-bridge -- allows osc to clone git repos, used everywhere
# obs-service-tar_scm -- used everywhere
# obs-service-recompress -- used in every RPM repo
# obs-service-set_version -- used in every RPM repo
# obs-service-node_moduels -- used in repos having NPM deps (WEB)
# obs-service-elixir_mix_deps -- used in repos having Elixir deps (WEB, WANDA)
# obs-service-regex_replace -- Used only in WEB for GTM setup
# obs-service-replace_using_package_version -- Used in Dockerfile repos
# obs-service-cargo -- Used in Wanda for vendoring Rust deps
# obs-service-go_modules -- used in Agent for vendoring Go deps
# obs-service-vendor_helm -- used in our Helm charts
# openssh -- needed for accessing git repos
# yq -- Not known to be used, but good as debug tool
# unzip -- Not known to be used, but good as debug tool
# vim -- Not known to be used, but good as debug tool
# wget -- Not known to be used, but good as debug tool
# make -- NOT USED ANYMORE, remove in next version (was used in CHARTS)
zypper -n install --no-recommends osc \
                  obs-scm-bridge \
                  obs-service-tar_scm \
                  obs-service-recompress \
                  obs-service-set_version \
                  obs-service-node_modules \
                  obs-service-elixir_mix_deps \
                  obs-service-regex_replace \
                  obs-service-replace_using_package_version \
                  obs-service-cargo \
                  obs-service-go_modules \
                  obs-service-vendor_helm \
                  openssh \
                  yq \
                  unzip \
                  vim \
                  make \
                  wget

zypper -n clean -a
rm -rf /var/log/zypp /var/log/zypper.log
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
COPY --chown=0:0 oscrc /root/.config/osc/oscrc
COPY --chown=$UID:$GID oscrc $HOME/.config/osc/oscrc
