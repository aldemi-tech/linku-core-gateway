/**
 * Aldemi Functions Core - Orquestador Principal
 * Unifica todas las funciones de diferentes dominios
 */

// Import functions from payment domain
export * from '../packages/payment/src';

// Import functions from meet domain 
export * from '../packages/meet/src';

// Core shared utilities
import * as functions from 'firebase-functions';

/**
 * Health check endpoint for the entire system
 */
export const healthCheck = functions.https.onRequest(async (req, res) => {
  try {
    const domains = {
      payment: {
        status: 'active',
        functions: [
          'paymentTokenizeCardDirect',
          'paymentCreateTokenizationSession', 
          'paymentCompleteTokenization',
          'paymentProcessPayment',
          'paymentRefundPayment',
          'paymentWebhook',
          'paymentGetAvailableProviders',
          'paymentGetExecutionLocation'
        ]
      },
      meet: {
        status: 'active',
        functions: [
          'meetCreateMeeting',
          'meetListMeetings',
          'meetUpdateMeeting',
          'meetDeleteMeeting',
          'meetGenerateJoinLink'
        ]
      }
    };

    res.json({
      success: true,
      timestamp: new Date().toISOString(),
      version: '1.0.0',
      architecture: 'monorepo-microservices',
      domains
    });
  } catch (error: any) {
    console.error('Health check error:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});