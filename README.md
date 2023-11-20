# Simple Echo service to run on EKS cluster

This repo is an excersise to a EKS cluster and deploy a service to it.

- Service itself is a simple FastAPI app
- Terraform sets up EKS cluster and a load balancer that terminates the SSL so it could be used via https (this is the hardest part actually)