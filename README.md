# Part 1: CI/CD & Deployment Design

## Overview

This project implements a CI/CD pipeline for a Spring Boot service (`sync-service`) using Jenkins and Docker.

The service is designed to run in multiple environments (**qa, staging, prod**) and deployment is controlled using a branch-based strategy.

---

## Branching Strategy

I followed a simple and practical branching model:


feature/* → dev → staging → main


### Flow

- Developers create feature branches from `dev`
- Feature branches are merged into `dev`
- `dev` branch is used for QA testing
- After validation, code is promoted to `staging`
- Finally, `main` is used for production deployment

---

## Branch to Environment Mapping

| Branch   | Environment |
|----------|------------|
| dev      | QA         |
| staging  | Staging    |
| main     | Production |

This mapping is implemented in the Jenkins pipeline using dynamic branch detection.

---

## Preventing Accidental Production Deployment

To avoid accidental deployments to production:

- A **manual approval step** is added in the pipeline  
- Production deployment only happens after approval  

main → approval → deploy

---

## Jenkins Pipeline Design

### Pipeline Stages

The pipeline includes the following stages:

1. **Checkout (SCM)**  
   - Jenkins automatically pulls the latest code  

2. **Init**  
   - Detects branch and maps it to environment  

3. **Build**  
   - Builds the application using Maven (inside Docker)  

4. **Docker Build**  
   - Creates a Docker image of the application  

5. **Approval (Prod only)**  
   - Manual approval required for production  

6. **Deploy**  
   - Runs the container and performs a health check  

---

## PR vs Merge Behavior

- **Pull Request (PR):**
  - Only build and validation stages should run  
  - No deployment happens  

- **Merge:**
  - Full pipeline runs  
  - Deployment happens based on branch  

> Current implementation focuses on merge flow. PR-based behavior can be extended using Jenkins triggers.

---

## Rollback Strategy

If deployment fails:

- The pipeline marks the build as failed  
- The previous Docker image can be redeployed  
- The container can be restarted using the last stable version  

This provides a simple and fast rollback mechanism.

---

## Configuration Management

Environment-specific configuration is handled using:

SPRING_PROFILES_ACTIVE

Each environment (qa, staging, prod) uses a different profile.

---

## Secrets Handling

Secrets are not hardcoded in the pipeline.

In a real setup:

- Jenkins Credentials can be used to store secrets  
- GCP Secret Manager can store:
  - MongoDB credentials  
  - API keys  

---

## Deployment Strategy

### Selected: Rolling Deployment

### Why Rolling?

- Updates application gradually  
- Reduces downtime  
- Simple to implement  

In a real setup, rolling updates across multiple instances would provide zero downtime.

---

## Zero / Minimal Downtime Approach

- Containers restart quickly  
- Health checks ensure application availability  
- In real environments, rolling updates across multiple instances ensure minimal or zero downtime  

---

## Summary

This CI/CD pipeline:

- Automates build, Docker image creation, and deployment  
- Uses branch-based logic for environment mapping  
- Prevents accidental production deployment using approval  
- Supports rollback using Docker images  
- Provides a simple and scalable CI/CD design  

---

## Project Structure


Assignment-DevOps/
│
├── README.md
├── sync-service-cicd/
│ ├── src/
│ ├── pom.xml
│ ├── Dockerfile
│ ├── deploy.sh
│ └── Jenkinsfile


---

## 🔹 Final Note

This pipeline was first tested locally using Docker and Jenkins, and can be extended to GCP VMs for prod
