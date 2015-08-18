#!/bin/bash

set -x -e

: MOZHARNESS_SCRIPT     ${MOZHARNESS_SCRIPT}
: MOZHARNESS_CONFIG     ${MOZHARNESS_CONFIG}

: MH_BRANCH             ${MH_BRANCH:=mozilla-central}
: MH_BUILD_POOL         ${MH_BUILD_POOL:=staging}

: WORKSPACE             ${WORKSPACE:=$HOME/workspace}

set -v

export MOZ_AUTOMATION_UPLOAD=0

export MOZ_CRASHREPORTER_NO_REPORT=1
export MOZ_OBJDIR=obj-firefox
export MOZ_SYMBOLS_EXTRA_BUILDID=win32

if [[ -z ${MOZHARNESS_SCRIPT} ]]; then exit 1; fi
if [[ -z ${MOZHARNESS_CONFIG} ]]; then exit 1; fi

# support multipl, space delimited, config files
config_cmds=""
for cfg in ${MOZHARNESS_CONFIG}; do
    config_cmds="${config_cmds} --config ${cfg}"
done

# make sure to disable checkouts, since they are done outside of mozharness

./${MOZHARNESS_SCRIPT} ${config_cmds} \
  --disable-mock \
  --no-setup-mock \
  --no-checkout-tools \
  --no-clone-tools \
  --no-clobber \
  --no-update \
  --no-upload-files \
  --no-sendchange \
  --log-level=debug \
  --work-dir=$WORKSPACE/build \
  --no-action=generate-build-stats \
  --branch=${MH_BRANCH} \
  --build-pool=${MH_BUILD_POOL}

