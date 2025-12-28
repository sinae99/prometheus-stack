#!/usr/bin/env bash
set -euo pipefail

echo "Stopping port-forwards..."

if [[ -f /tmp/pf-prometheus.pid ]]; then
  kill "$(cat /tmp/pf-prometheus.pid)" 2>/dev/null || true
  rm -f /tmp/pf-prometheus.pid
fi

if [[ -f /tmp/pf-grafana.pid ]]; then
  kill "$(cat /tmp/pf-grafana.pid)" 2>/dev/null || true
  rm -f /tmp/pf-grafana.pid
fi

echo "✅ Stopped."
