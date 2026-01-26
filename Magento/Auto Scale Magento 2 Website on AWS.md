# 🚀 Auto Scale Magento 2 Website on AWS

## 1. Nguyên tắc cốt lõi khi auto-scale Magento

👉 Magento KHÔNG scale bằng cách “copy nguyên server”
👉 Phải tách stateful & stateless

| Thành phần	| Cách xử lý |
|---|---|
| Code	| Stateless |
| Media	| Shared (S3) |
| Session	| Redis |
| Cache	| Redis |
| DB	| RDS / Aurora |
| Search	| OpenSearch |
FPC	Varnish / CloudFront

---

## 2. Reference Architecture

User
↓
Route 53
↓
Application Load Balancer (ALB)
↓
Auto Scaling Group (EC2)
(Nginx + PHP-FPM + Magento)
↓
┌───────────────┬───────────────┐
| Redis (Cache) | Redis (Session)|
└───────────────┴───────────────┘
↓
RDS / Aurora (MySQL)
↓
OpenSearch
↓
S3 (Media)
↓
CloudFront (CDN)
---

Amazon Route 53 là dịch vụ DNS (Domain Name System) được quản lý của AWS, dùng để định tuyến người dùng đến đúng tài nguyên (server, load balancer, CDN…) nhanh, ổn định và có khả năng scale toàn cầu.

Application Load Balancer (ALB) là dịch vụ cân bằng tải được quản lý của AWS, dùng để phân phối lưu lượng truy cập đến các EC2 instances trong Auto Scaling Group (ASG).

Auto Scaling Group (ASG) là nhóm các EC2 instances được quản lý tự động, có thể mở rộng hoặc thu hẹp số lượng instances theo nhu cầu của hệ thống.

Aurora = MySQL/PostgreSQL “phiên bản AWS tối ưu”
Chạy trên RDS nhưng có engine riêng của AWS.



## 3. Auto Scaling Group (ASG)

- EC2 instances are **immutable**
- No local session or media storage
- Scale policies based on:
  - CPU usage
  - ALB request count
  - Target response time

```text
Scale out → traffic spike
Scale in  → traffic drops
```

## 4. Redis – Key to Auto Scaling

Use Amazon ElastiCache (Redis) for:

Session storage

Default Magento cache

Page cache (if no Varnish)

'session' => [
    'save' => 'redis'
];


❗ Without Redis → auto scaling will break

## 5. Media & Static Content
Media

Upload to S3

Serve via CloudFront

Static Content

Build at deploy time

Never generate on runtime

bin/magento setup:static-content:deploy

## 6. Full Page Cache (FPC)
Option A: Varnish

Installed on EC2 or separate layer

Option B (Recommended): CloudFront

Cache HTML at edge

Bypass PHP for most traffic

CloudFront HIT → Magento not executed

## 7. Database Scaling
Options

RDS MySQL (Multi-AZ + Read Replica)

Aurora MySQL (Auto scale reads)

Strategy

Scale READ first

Optimize indexes & slow queries

## 8. Search Layer

Magento 2 requires:

OpenSearch / Elasticsearch

❌ Do not run search on app servers

## 9. Zero-Downtime Deployment

Build AMI
 → Create new ASG
 → Deploy code
 → Warm up cache
 → Switch ALB target
 → Terminate old ASG


✔ Blue–Green or Rolling deployment

## 10. Cron & Queue Handling

Run cron on one dedicated node

Use:

Magento Message Queue

AWS SQS (optional)

❌ Never run cron on all auto-scaled nodes

## 11. Monitoring & Auto Healing

Use:

AWS CloudWatch

Prometheus + Grafana

New Relic

Monitor:

PHP-FPM latency

Redis memory

DB connections

Cache hit ratio

## 12. Common Mistakes (Interview Traps)

❌ Store sessions on filesystem
❌ Media stored on EC2
❌ No cache warm-up
❌ Cron running on all nodes