# Prometheus + Grafana Training


- **Prometheus** 
- **Grafana** 
- **kube-prometheus-stack** Helm chart (Prometheus Operator-based installation)


---

## Repo structure

```bash
.
├── 00-namespace.yaml
├── 1-stack/                 # kube-prometheus-stack Helm values
├── 2-nginx/                  # nginx + stub_status enabled
├── 3-exporters/              # nginx exporter deployment + service
├── 4-servicemonitors/        # ServiceMonitor objects
├── 5-access/                 # helper scripts (port-forward + credentials)
└── debug/                    # quick debugging helpers
```

---


### 1) Create namespace
```bash
kubectl apply -f 00-namespace.yaml
```

### 2) Install Prometheus + Grafana stack (minimal)
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install sina-monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f 1-stack/values-minimal.yaml \
  --wait \
  --timeout 15m
```

### 3) Deploy nginx + exporter + ServiceMonitor
```bash
kubectl apply -n monitoring -f 2-nginx/
kubectl apply -n monitoring -f 3-exporters/
kubectl apply -n monitoring -f 4-servicemonitors/
```

---

## Access 

### Start port-forwards
```bash
./5-access/start-port-forwards.sh
```

### Stop port-forwards
```bash
./5-access/stop-port-forwards.sh
```

### Grafana credentials
```bash
./5-access/credentials.sh
```

### URLs
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

---

## validation 

### 1) targets

- http://localhost:9090/

You should see:
- `nginx-exporter` target **UP**
- node-exporter, kubelet, kube-state-metrics targets **UP**

### 2) NGINX metrics 
PromQL :
- `nginx_up` → should be `1`
- `nginx_http_requests_total` exists

### 3) Grafana dashboards

- Node Exporter Full: **1860**
- NGINX Exporter: **12708**

---

