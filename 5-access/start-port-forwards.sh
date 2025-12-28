#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="monitoring"
RELEASE="sina-monitoring"

PROM_SVC="${RELEASE}-kube-prome-prometheus"
GRAF_SVC="${RELEASE}-grafana"

echo "Starting port-forwards in background..."
echo "  Prometheus: http://localhost:9090"
echo "  Grafana:    http://localhost:3000"

kubectl -n "$NAMESPACE" port-forward "svc/${PROM_SVC}" 9090:9090 >/tmp/pf-prometheus.log 2>&1 &
echo $! > /tmp/pf-prometheus.pid

kubectl -n "$NAMESPACE" port-forward "svc/${GRAF_SVC}" 3000:80 >/tmp/pf-grafana.log 2>&1 &
echo $! > /tmp/pf-grafana.pid

echo "✅ Done."
echo "To stop: ./stop-port-forwards.sh"
