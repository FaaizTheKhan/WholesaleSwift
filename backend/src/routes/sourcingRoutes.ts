import { Router, Request, Response } from 'express';
import { SourcingAggregatorService } from '../services/sourcingService';

const router = Router();
const sourcingService = new SourcingAggregatorService();

router.get('/search', async (req: Request, res: Response) => {
  const query = req.query.q as string;
  const freightType = (req.query.freight as string) === 'Fast Sea DDP' ? 'Fast Sea DDP' : 'Air Express';

  if (!query) {
    res.status(400).json({ error: 'Search query (q) is required' });
    return;
  }

  const start = Date.now();

  try {
    const results = await sourcingService.search(query, freightType);
    const execution_time_ms = Date.now() - start;

    // Add execution metrics to headers
    res.setHeader('X-Execution-Time-Ms', execution_time_ms.toString());

    res.json(results);
  } catch (error) {
    console.error('Sourcing Search Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.get('/platforms', (req: Request, res: Response) => {
  // Returns list of supported platforms
  res.json({ platforms: ['cjdropshipping', 'alibaba', 'aliexpress'] });
});

export default router;
