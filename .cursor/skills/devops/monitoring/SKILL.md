---
name: devops-monitoring
description: 监控告警 - Prometheus/Grafana/Sentry
---

# 监控告警

## Prometheus

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'app'
    static_configs:
      - targets: ['localhost:3000']
```

```typescript
// 应用指标
import { Counter, Histogram } from 'prom-client';

const httpRequests = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'status']
});

const requestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Request duration',
  buckets: [0.1, 0.5, 1, 2, 5]
});
```

## Grafana

```yaml
# 仪表盘配置
{
  "panels": [
    {
      "title": "CPU Usage",
      "type": "graph",
      "targets": [
        { "expr": "rate(process_cpu_seconds_total[5m])" }
      ]
    },
    {
      "title": "Memory",
      "type": "graph", 
      "targets": [
        { "expr": "process_resident_memory_bytes" }
      ]
    }
  ]
}
```

## Sentry

```typescript
import * as Sentry from '@sentry/node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0
});

// 捕获错误
try {
  await riskyOperation();
} catch (e) {
  Sentry.captureException(e);
}
```

## 告警规则

```yaml
groups:
  - name: app
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: High error rate
```

## 最佳实践

1. 关键指标监控
2. 多级别告警
3. 告警聚合
4. 值班轮换

## 参考

- `.cursor/rules/dockerfile.mdc`
