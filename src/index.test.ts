import * as functions from './index';

// Mock firebase-functions
jest.mock('firebase-functions', () => ({
  logger: {
    info: jest.fn(),
    error: jest.fn(),
    warn: jest.fn()
  }
}));

jest.mock('firebase-functions/v2/https', () => ({
  onRequest: jest.fn((options, handler) => handler)
}));

describe('Core Orchestrator Functions', () => {
  describe('healthCheck', () => {
    it('should return healthy status', async () => {
      const req = {} as any;
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      } as any;

      await functions.healthCheck(req, res);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          status: 'healthy',
          services: expect.objectContaining({
            core: 'active',
            version: '1.0.0'
          })
        })
      );
    });
  });

  describe('getAvailableServices', () => {
    it('should return available microservices', async () => {
      const req = {} as any;
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn()
      } as any;

      await functions.getAvailableServices(req, res);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(
        expect.objectContaining({
          services: expect.objectContaining({
            payment: expect.objectContaining({
              repository: 'linku-payment-functions',
              status: 'available'
            }),
            meet: expect.objectContaining({
              repository: 'linku-meet-functions', 
              status: 'available'
            })
          }),
          totalServices: 2
        })
      );
    });
  });
});