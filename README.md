# Terraform deployment of Cloud Run with Internal L7 ILB

This repository contains Terraform templates to deploy a sample application to
Cloud Run and places the service as a Serverless Network Endpoint Group behind
an Internal L7 Load Balancer.

The configuration only allows HTTP (non-SSL) traffic as of now.

The documentation of setting up an internal HTTP(s) Load Balancer with Cloud
Run can be found [here](https://cloud.google.com/load-balancing/docs/l7-internal/setting-up-l7-internal-serverless)