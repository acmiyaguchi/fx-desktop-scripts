#! /bin/bash -vex

set -x -e

# Inputs, with defaults

# mozharness builds use three repositories: gecko (source), mozharness (build
# scripts) and tools (miscellaneous) for each, specify *_REPOSITORY.  If the
# revision is not in the standard repo for the codebase, specify *_BASE_REPO as
# the canonical repo to clone and *_HEAD_REPO as the repo containing the
# desired revision.  For Mercurial clones, only *_HEAD_REV is required; for Git
# clones, specify the branch name to fetch as *_HEAD_REF and the desired sha1
# as *_HEAD_REV.  For compatibility, we also accept MOZHARNESS_{REV,REF}

: GECKO_REPOSITORY              ${GECKO_REPOSITORY:=https://hg.mozilla.org/mozilla-central}
: GECKO_BASE_REPOSITORY         ${GECKO_BASE_REPOSITORY:=${GECKO_REPOSITORY}}
: GECKO_HEAD_REPOSITORY         ${GECKO_HEAD_REPOSITORY:=${GECKO_REPOSITORY}}
: GECKO_HEAD_REV                ${GECKO_HEAD_REV:=default}

: MOZHARNESS_REPOSITORY         ${MOZHARNESS_REPOSITORY:=https://hg.mozilla.org/build/mozharness}
: MOZHARNESS_BASE_REPOSITORY    ${MOZHARNESS_BASE_REPOSITORY:=${MOZHARNESS_REPOSITORY}}
: MOZHARNESS_HEAD_REPOSITORY    ${MOZHARNESS_HEAD_REPOSITORY:=${MOZHARNESS_REPOSITORY}}
: MOZHARNESS_REV                ${MOZHARNESS_REV:=production}
: MOZHARNESS_HEAD_REV           ${MOZHARNESS_HEAD_REV:=${MOZHARNESS_REV}}
: MOZHARNESS_DISABLE            ${MOZHARNESS_DISABLE:=false}

: TOOLS_REPOSITORY              ${TOOLS_REPOSITORY:=https://hg.mozilla.org/build/tools}
: TOOLS_BASE_REPOSITORY         ${TOOLS_BASE_REPOSITORY:=${TOOLS_REPOSITORY}}
: TOOLS_HEAD_REPOSITORY         ${TOOLS_HEAD_REPOSITORY:=${TOOLS_REPOSITORY}}
: TOOLS_HEAD_REV                ${TOOLS_HEAD_REV:=default}
: TOOLS_DISABLE                 ${TOOLS_DISABLE:=false}

: MH_CUSTOM_BUILD_VARIANT_CFG   ${MH_CUSTOM_BUILD_VARIANT_CFG}
: MH_BRANCH                     ${MH_BRANCH:=mozilla-central}
: MH_BUILD_POOL                 ${MH_BUILD_POOL:=staging}

: WORKSPACE                     ${WORKSPACE:=$HOME/workspace}

set -v

# check out mozharness
if [ ! "$MOZHARNESS_DISABLE" = "true" ]
then
    tc-checkout $WORKSPACE/mozharness $MOZHARNESS_BASE_REPOSITORY $MOZHARNESS_HEAD_REPOSITORY $MOZHARNESS_HEAD_REV
fi

# check out tools where mozharness expects it to be ($PWD/build/tools and $WORKSPACE/build/tools)
if [ ! "$TOOLS_DISABLE" = true ]
then
    tc-vcs checkout $WORKSPACE/build/tools $TOOLS_BASE_REPOSITORY $TOOLS_HEAD_REPOSITORY $TOOLS_HEAD_REV
fi

# and check out mozilla-central where mozharness will use it as a cache (/builds/hg-shared)
tc-checkout $WORKSPACE/build/src $GECKO_BASE_REPOSITORY $GECKO_HEAD_REPOSITORY $GECKO_HEAD_REV
