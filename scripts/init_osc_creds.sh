#!/bin/bash

# SPDX-FileCopyrightText: SUSE LLC
# SPDX-License-Identifier: Apache-2.0

set -e

source $(dirname $0)/utils.sh

OSCRC_FILE=${OSCRC_FILE:=$HOME/.config/osc/oscrc}

if [ ! -f "$OSCRC_FILE" ]; then
  mkdir -p $(dirname $OSCRC_FILE)
  cp /usr/local/share/osc/oscrc.sample $OSCRC_FILE
fi

check_user
