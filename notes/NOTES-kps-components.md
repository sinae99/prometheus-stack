# kube-prometheus-stack ===> What Helm Installs



> Chart: `prometheus-community/kube-prometheus-stack`  
> It is based on **Prometheus Operator** (aka the `prometheus-operator` / `kube-prometheus` project).



---

## 1) Prometheus Operator

**What it is:**  
A controller that watches CRDs and reconciles Prometheus configuration.

**What it does:**
- Watches `ServiceMonitor`, `PodMonitor`, `PrometheusRule`, etc.
- Generates the real Prometheus scrape configs
- Applies and reloads Prometheus safely

**Why it matters:**  
This is why we can create a `ServiceMonitor` and Prometheus immediately starts scraping without editing Prometheus YAML.

---

## 2) Prometheus (StatefulSet)

**What it is:**  
The Prometheus server itself (time-series database + scraper + query engine).

**What it does:**
- Scrapes targets (`/metrics`)
- Stores time-series data
- Serves queries (PromQL)
- Provides the `/targets` page for health and debugging

---

## 3) Grafana (Deployment)

**What it is:**  
Visualization UI.

**What it does:**
- Reads metrics from Prometheus datasource
- Shows dashboards and panels
- Has Explore view for quick queries

**Important:**  
In this stack, the Prometheus datasource is often **provisioned** automatically, so it can't be modified via UI (by design).

---

## 4) node-exporter (DaemonSet)

**What it monitors:**  
Linux host/node metrics.

**Runs on:**  
Every node (DaemonSet)

**Provides metrics like:**
- CPU, memory, disk, network
- filesystem usage
- load average

Example metric:
- `node_cpu_seconds_total`

---

## 5) kube-state-metrics (Deployment)

**What it monitors:**  
Kubernetes object/state metrics (reads Kubernetes API objects).

**Provides metrics like:**
- desired vs available replicas
- pod phases/status
- node conditions
- resource quotas, limits
- deployments, daemonsets, statefulsets

Important difference:
- kube-state-metrics shows **Kubernetes state** (what Kubernetes wants / sees)
- cadvisor/node-exporter show **real resource usage**

Example metric:
- `kube_deployment_status_replicas_available`

---

## 6) kubelet & cAdvisor scraping

The chart creates monitors to scrape:
- kubelet `/metrics`
- kubelet `/metrics/cadvisor`
- kubelet `/metrics/probes`

**Why three endpoints?**
- `/metrics`: kubelet internal metrics
- `/metrics/cadvisor`: container CPU/mem/net usage
- `/metrics/probes`: liveness/readiness probe stats

---

## 7) ServiceMonitor (CRD)

**What it is:**  
A Kubernetes custom resource that defines *how Prometheus should scrape metrics* from a service.

**What it does:**
- Selects a Service using labels
- Defines endpoints (port/path/interval)
- Operator converts it into Prometheus scrape config

Your project uses:
- `nginx-exporter-servicemonitor.yaml`

---

## 8) PrometheusRule (CRD)

**What it is:**  
Defines alerting and recording rules.

**What it does:**
- Adds alert rules Prometheus evaluates
- Can later integrate with Alertmanager

> This project doesn’t focus on alerting yet, but the stack includes many built-in rules.

---

## 9) Alertmanager (optional)

Often installed by default in kube-prometheus-stack.

**What it does:**
- Receives alerts from Prometheus
- Groups/deduplicates alerts
- Sends notifications (Slack/Email/PagerDuty)

> In your minimal setup it may be disabled or not used.

---

## Practical takeaway (DevOps view)

- **Targets page** is your first debug tool: `/targets`
- **ServiceMonitor** is the key Kubernetes concept for scraping
- node-exporter = infra metrics
- kube-state-metrics = cluster state metrics
- kubelet/cadvisor = per-container resource usage
- Grafana reads from Prometheus and provides dashboards

---

## Useful commands

List stack pods:
```bash
kubectl get pods -n monitoring
```

List ServiceMonitors:
```bash
kubectl get servicemonitor -n monitoring
```

Check Prometheus targets:
- http://localhost:9090/targets
