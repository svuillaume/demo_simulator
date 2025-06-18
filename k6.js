import http from 'k6/http';
import { sleep } from 'k6';

// ✅ Correct declaration: ipPools with regions
const ipPools = {
  us: ['45.83.64.1', '205.185.127.1'],
  eu: ['185.234.217.1', '194.147.32.1'],
  apac: ['103.21.244.1', '203.0.113.5'],
};

function getRandomIP(region) {
  const list = ipPools[region];
  return list[Math.floor(Math.random() * list.length)];
}

export const options = {
  scenarios: {
    ramp_users: {
      executor: 'ramping-vus',
      startVUs: 4,
      stages: [
        { duration: '3m', target: 2 },
        { duration: '3m', target: 6 },
        { duration: '4m', target: 4 },
        { duration: '3m', target: 6 },
        { duration: '3m', target: 2 },
        { duration: '4m', target: 8 },
        { duration: '3m', target: 2 },
        { duration: '3m', target: 16 },
        { duration: '4m', target: 12 },
      ],
    },
  },
};

export default function () {
  const regions = Object.keys(ipPools);
  const randomRegion = regions[Math.floor(Math.random() * regions.length)];
  const fakeIP = getRandomIP(randomRegion);

  const headers = {
    'X-Forwarded-For': fakeIP,
  };

  http.get('http://172.31.28.30:5000', { headers });
  sleep(1);
}
