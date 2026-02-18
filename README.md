# WAF + CloudFront + ALB + EC2 Auto Scaling Architecture

AWS Edge 보안과 트래픽 기반 자동 확장을 포함한 고가용성 웹 아키텍처 설계 프로젝트

---

## Project Objective

이 프로젝트의 목적은 다음을 구현하는 것이다:

- L7 보안 계층을 포함한 웹 아키텍처 구성
- CDN을 활용한 글로벌 트래픽 최적화
- HTTPS 기반의 안전한 외부 노출
- 트래픽 기반 자동 확장 구조 설계
- 무중단 확장 가능한 인프라 구성

---

## Core Architecture Design

Client  
│  
▼  
AWS WAF  
│  
▼  
CloudFront (ACM / HTTPS)  
│  
▼  
Application Load Balancer  
│  
▼  
EC2 (Auto Scaling Group)

---

## 1. WAF 기반 보안 설계

CloudFront 앞단에 AWS WAF를 배치하였다.

### 적용 내용

- SQL Injection 방어
- XSS 방어
- 악성 IP 차단
- HTTP/HTTPS 요청 필터링

### 설계 의도

애플리케이션에 도달하기 전 L7 공격을 차단하여  
보안 레이어를 인프라 레벨에서 분리하였다.

---

## 2. CloudFront + ACM 기반 HTTPS 설계

CloudFront를 CDN으로 구성하고 ACM 인증서를 적용하였다.

### 구성 요소

- Viewer Protocol Policy: HTTP → HTTPS Redirect
- ACM 인증서 (us-east-1)
- ALB를 Origin으로 설정

### 설계 의도

- TLS 암호화를 통한 보안 강화
- 글로벌 엣지 캐싱을 통한 응답 속도 개선
- Origin 보호

---

## 3. ALB 기반 트래픽 분산

Application Load Balancer를 통해 다수의 EC2 인스턴스로 트래픽을 분산하였다.

### 구성

- Target Group 연결
- Health Check 설정
- 다중 AZ 구성

---

## 4. EC2 + Auto Scaling Group 설계

Launch Template 기반으로 EC2를 생성하고 Auto Scaling Group과 연결하였다.

### 구성

- 최소 / 최대 인스턴스 수 설정
- Multi-AZ 배포
- Target Group 연동

---

## 5. Auto Scaling 정책

### 1) CPU Target Tracking

- 지표: Average CPU Utilization
- 목표치 초과 시 Scale Out
- 목표치 이하 시 Scale In

### 2) RequestCountPerTarget Target Tracking

- 지표: ALB Target Group의 RequestCountPerTarget
- 요청 증가 시 Scale Out
- 요청 감소 시 Scale In

---

## Design Philosophy

이 프로젝트는 단순히 EC2를 확장하는 구조가 아니라,

- 보안 계층을 포함하고
- CDN을 통해 트래픽을 최적화하며
- HTTPS를 기본으로 적용하고
- 트래픽 기반 자동 확장을 구현한

운영 환경을 고려한 고가용성 아키텍처를 설계하는 것을 목표로 한다.

블로그 작업 : https://a-gentle-breeze.tistory.com/category/WAF-CloudFront-ALB-EC2