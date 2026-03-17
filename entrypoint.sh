#!/bin/sh

set -e

RULES="${PLUGIN_RULES:-auto}"
TARGET="${PLUGIN_TARGET:-.}"
CONFIG="${PLUGIN_CONFIG:-}"
SARIF_OUTPUT="${PLUGIN_SARIF_OUTPUT:-}"
ERROR="${PLUGIN_ERROR:-false}"
EXCLUDE="${PLUGIN_EXCLUDE:-}"

OPENGREP_CMD="opengrep scan -f ${RULES} ${TARGET}"

if [ -n "$CONFIG" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --config ${CONFIG}"
fi

if [ -n "$SARIF_OUTPUT" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --sarif-output ${SARIF_OUTPUT}"
fi

if [ -n "$EXCLUDE" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --exclude ${EXCLUDE}"
fi

if [ "$ERROR" = "true" ]; then
    OPENGREP_CMD="${OPENGREP_CMD} --error"
fi

echo "Running: ${OPENGREP_CMD}"
eval ${OPENGREP_CMD}
