#!/bin/bash
set -e

source $(dirname $0)/utils.sh

OSCRC_FILE=${OSCRC_FILE:=$HOME/.config/osc/oscrc}

check_user
