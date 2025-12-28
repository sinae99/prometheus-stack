# Phase 03 — ServiceMonitor + Verify Scraping in Prometheus


## 1) Apply ServiceMonitor


```bash
kubectl apply -n monitoring -f 4-servicemonitors/
```

This applies:
- `nginx-exporter-servicemonitor.yaml`

---

## 2) Final check 

### A) ServiceMonitor exists
```bash
kubectl get servicemonitor -n monitoring
```

Expected: `nginx-exporter` appears in the list.

---

### B) Prometheus targets show nginx-exporter UP

Open:
- http://localhost:9090/targets

Expected:
- `nginx-exporter` target is **UP**

CLI check:

```bash
kubectl port-forward -n monitoring svc/sina-monitoring-kube-prome-prometheus 9090:9090
```

Then:
- http://localhost:9090/targets

---

### C) Query nginx metrics in Prometheus



```promql
nginx_up
```

Expected: `1`



```promql
rate(nginx_http_requests_total[1m])
```

Expected: value >= 0 (increases once traffic exists)

---

## 3) Generate traffic (optional, makes dashboards show movement)

```bash
kubectl run loadgen -n monitoring --rm -it --image=curlimages/curl --restart=Never -- \
  sh -c 'for i in $(seq 1 500); do curl -s http://nginx >/dev/null; done'
```

Then refresh Prometheus query:
- `nginx_http_requests_total` should increase

