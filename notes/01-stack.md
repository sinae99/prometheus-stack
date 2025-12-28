# Phase 01 — Install Monitoring Stack
---

## 1) Create namespace

From repo root:

```bash
kubectl apply -f 00-namespace.yaml
```

---

## 2) Add Helm repo + update

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

---

## 3) Install kube-prometheus-stack (minimal)

This repo uses a minimal values file: `1-stack/values-minimal.yaml`.

```bash
helm install sina-monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f 1-stack/values-minimal.yaml \
  --wait \
  --timeout 15m
```



---

## 4) Final check

### Pods should be running:

```bash
kubectl get pods -n monitoring
```

Expected (names may vary):
- grafana pod **Running**
- prometheus operator pod **Running**
- prometheus pod **Running**
- node-exporter pod **Running**
- kube-state-metrics pod **Running**

### Services should exist:

```bash
kubectl get svc -n monitoring
```

You should see:
- `*-grafana`
- `*-kube-prome-prometheus`
- `*-kube-prome-operator`
- `*-kube-state-metrics`
- `*-prometheus-node-exporter`

---

## 5) Access Prometheus & Grafana

Run port-forward helper:

```bash
./5-access/start-port-forwards.sh
```

URLs:
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

Stop port-forwards:

```bash
./5-access/stop-port-forwards.sh
```

Grafana credentials:

```bash
./5-access/credentials.sh
```
