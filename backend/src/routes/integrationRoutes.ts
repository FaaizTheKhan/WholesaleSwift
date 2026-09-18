import { Router, Request, Response } from 'express';
import { DispatchRequest, US_PHONE_REGEX } from '../types/integration';

const router = Router();

router.post('/dispatch', (req: Request, res: Response) => {
  const payload: DispatchRequest = req.body;

  // Validate required fields
  if (!payload || !payload.target_url || !payload.payload) {
    res.status(400).json({ error: 'Invalid dispatch request. target_url and payload are required.' });
    return;
  }

  // Validate E.164 phone number if metadata is provided
  if (payload.metadata && payload.metadata.recipient_phone) {
    if (!US_PHONE_REGEX.test(payload.metadata.recipient_phone)) {
      res.status(400).json({ error: 'Invalid phone format. Must be strict US E.164 (e.g., +12345678900).' });
      return;
    }

    // Validate TCPA Compliance Opt-in
    if (!payload.metadata.opt_in_status) {
      res.status(403).json({ error: 'TCPA Compliance Violation: explicit opt_in_status must be true.' });
      return;
    }
  }

  // Simulate webhook dispatch (In real world, you'd use fetch or axios to post to target_url)
  console.log(`[Webhook Dispatch] Triggered to ${payload.target_url} with event ${payload.payload.event_type}`);

  res.status(202).json({
    status: 'accepted',
    message: 'Dispatch request accepted and queued for processing.',
    dispatch_id: 'disp_' + Date.now().toString()
  });
});

export default router;
