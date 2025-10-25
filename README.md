# Linku Core Gateway - API Router

Firebase Hosting gateway that routes API requests to microservices.

## Architecture
- **Gateway**: Firebase Hosting with URL rewrite rules
- **Meet Service**: https://github.com/aldemi-tech/linku-meet-functions
- **Payment Service**: https://github.com/aldemi-tech/linku-payment-functions

## API Endpoints
All endpoints are available under `/api/v1/` namespace:
- `/api/v1/meet/*` → Meet microservice functions
- `/api/v1/payment/*` → Payment microservice functions

## Deployment
Automatic deployment via GitHub Actions on push to main branch.
