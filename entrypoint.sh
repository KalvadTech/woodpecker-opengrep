#!/bin/sh

set -e

git config --global --add safe.directory /woodpecker

RULES="${PLUGIN_RULES:-auto}"
TARGET="${PLUGIN_TARGET:-.}"
CONFIG="${PLUGIN_CONFIG:-}"
SARIF_OUTPUT="${PLUGIN_SARIF_OUTPUT:-}"
ERROR="${PLUGIN_ERROR:-false}"
EXCLUDE="${PLUGIN_EXCLUDE:-}"
PROJECT_ROOT="${PLUGIN_PROJECT_ROOT:-}"

OPENGREP_CMD="opengrep scan -f ${RULES} ${TARGET}"

if [ -n "$CONFIG" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --config ${CONFIG}"
fi

if [ -n "$EXCLUDE" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --exclude ${EXCLUDE}"
fi

if [ "$ERROR" = "true" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --error"
fi

if [ -n "$PROJECT_ROOT" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --experimental --project-root=${PROJECT_ROOT}"
fi

if [ -n "$SARIF_OUTPUT" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --sarif"
    echo "Running: ${OPENGREP_CMD} > ${SARIF_OUTPUT}"
    eval "${OPENGREP_CMD}" > "${SARIF_OUTPUT}"
else
    echo "Running: ${OPENGREP_CMD}"
    eval ${OPENGREP_CMD}
fi
