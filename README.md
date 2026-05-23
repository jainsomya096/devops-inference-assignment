# DevOps Inference Assignment

## Architecture

```text
                INTERNET
                    |
         Public API Gateway VM
            34.28.153.155
                 :9000
                    |
          -------------------
          |   Private VPC   |
          -------------------
                    |
          Inference VM
             10.0.1.3
               :8000
          (NO PUBLIC IP)


Overview

This project demonstrates a distributed inference architecture deployed on Google Cloud Platform using Terraform.

The system consists of:

A public API Gateway VM
A private Inference VM
Internal communication over a private VPC subnet
FastAPI-based JSON APIs
Infrastructure provisioned entirely through Terraform


Components

API Gateway VM

Publicly accessible
Exposes /chat endpoint
Forwards requests internally to inference VM

Inference VM
Private VM inside subnet
Not accessible from public internet
Processes inference requests

Infrastructure

Provisioned using Terraform:

Custom VPC
Private subnet
Firewall rules
Compute Engine VMs
```
Deployment

Initialize Terraform
terraform init

Deploy Infrastructure
terraform apply

API Test
Curl Request
curl -X POST http://34.28.153.155:9000/chat \
-H "Content-Type: application/json" \
-d '{"message":"What is cloud computing?"}'

Sample Response
{
  "response": "Inference processed successfully: What is cloud computing?"
}

Production Improvements

If deploying to production, I would improve:

HTTPS with Load Balancer
Cloud NAT instead of temporary public access
Docker containerization
Kubernetes orchestration
Monitoring and logging
Authentication and rate limiting
GPU-based inference workers for large models

Notes
The inference VM was temporarily assigned public internet access during setup for dependency installation and debugging. After deployment, the public IP was removed to maintain private subnet isolation.
