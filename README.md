# DevOps Inference Assignment

## Architecture

```text
                INTERNET
                    |
         Public API Gateway VM
            34.55.240.176
                 :9000
                    |
          -------------------
          |   Private VPC   |
          -------------------
                    |
          Inference VM
             10.0.1.2
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

Deployment

Initialize Terraform
terraform init

Deploy Infrastructure
terraform apply

API Test
Curl Request
curl -X POST http://34.55.240.176:9000/chat \
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

## Engineering Notes



During implementation, I encountered several real-world infrastructure and deployment challenges while working within free-tier cloud constraints.



Key decisions and learnings:

- Initially attempted full transformer-based inference deployment using HuggingFace models.

- Encountered memory limitations on free-tier e2-micro instances during PyTorch installation and model loading.

- Replaced the heavy inference runtime with a lightweight inference worker while preserving the distributed architecture, internal networking, API gateway, Terraform infrastructure, and deployment flow.

- Temporarily enabled outbound internet access on the inference VM during provisioning for dependency installation and debugging, then removed the public IP afterward to restore proper private subnet isolation.

- Used Terraform to iteratively provision and modify infrastructure rather than relying on manual console configuration.
Notes
The inference VM was temporarily assigned public internet access during setup for dependency installation and debugging. After deployment, the public IP was removed to maintain private subnet isolation.
The deployment endpoint is kept active for evaluation purposes and may be decommissioned after the review period to avoid unnecessary cloud charges.
```
