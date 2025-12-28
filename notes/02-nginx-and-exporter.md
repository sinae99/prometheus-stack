# Phase 02 — Deploy NGINX + NGINX Exporter

This phase deploys a simple **NGINX** app (with `stub_status` enabled) and the **nginx-prometheus-exporter**.

---

## 1) Deploy NGINX (with stub_status)

From repo root:

```bash
kubectl apply -n monitoring -f 2-nginx/
```

This applies:
- `nginx-configmap.yaml` (enables `/stub_status`)
- `nginx-deploy.yaml`
- `nginx-svc.yaml`

---

## 2) Deploy NGINX Exporter

```bash
kubectl apply -n monitoring -f 3-exporters/
```

This applies:
- `nginx-exporter-deploy.yaml`
- `nginx-exporter-svc.yaml`

---

## 3) Final check (single checkpoint)

### A) Pods should be running
```bash
kubectl get pods -n monitoring
```

Expected:
- `nginx` pod **Running**
- `nginx-exporter` pod **Running**

### B) NGINX stub_status is reachable
Run an in-cluster curl:

```bash
kubectl run tmp-curl -n monitoring --rm -it --image=curlimages/curl --restart=Never -- \
  curl -s http://nginx/stub_status
```

Expected output contains something like:
- `Active connections: ...`
- `server accepts handled requests`

### C) Exporter metrics endpoint works
```bash
kubectl run tmp-curl2 -n monitoring --rm -it --image=curlimages/curl --restart=Never -- \
  sh -c 'curl -s http://nginx-exporter:9113/metrics | grep -E "^nginx_" | head -n 20'
```

Expected:
- `nginx_up 1`
- `nginx_http_requests_total ...`

---

✅ Phase 02 complete when:
- nginx + exporter pods are Running
- `/stub_status` responds
- exporter `/metrics` shows `nginx_*` metrics
