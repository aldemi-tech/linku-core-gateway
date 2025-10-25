import { onRequest } from 'firebase-functions/v2/https';
import { logger } from 'firebase-functions';

// Core orchestrator for Linku microservices

/**
 * Health check endpoint for the core orchestrator
 */
export const healthCheck = onRequest({ cors: true }, async (req, res) => {
  logger.info('Core health check requested');
  
  const healthStatus = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    services: {
      core: 'active',
      version: '1.0.0'
    }
  };
  
  res.status(200).json(healthStatus);
});

/**
 * Function registry for all microservices
 * This will be populated dynamically based on available services
 */
export const getAvailableServices = onRequest({ cors: true }, async (req, res) => {
  logger.info('Available services requested');
  
  const services = {
    payment: {
      repository: 'linku-payment-functions',
      functions: [
        'paymentTokenizeCardDirect',
        'paymentProcessPayment',
        'paymentGetPaymentStatus',
        'paymentCancelPayment',
        'paymentGetProviders'
      ],
      status: 'available'
    },
    meet: {
      repository: 'linku-meet-functions', 
      functions: [
        'meetCreateMeeting',
        'meetListMeetings',
        'meetUpdateMeeting',
        'meetDeleteMeeting'
      ],
      status: 'available'
    }
  };
  
  res.status(200).json({
    services,
    totalServices: Object.keys(services).length,
    timestamp: new Date().toISOString()
  });
});