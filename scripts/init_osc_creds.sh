#!/bin/bash

# SPDX-FileCopyrightText: SUSE LLC
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

source $(dirname $0)/utils.sh

OSCRC_FILE=${OSCRC_FILE:=$HOME/.config/osc/oscrc}

if [ ! -f "$OSCRC_FILE" ]; then
  mkdir -p $(dirname $OSCRC_FILE)
  cp /usr/local/share/osc/oscrc.sample $OSCRC_FILE
fi

check_user
