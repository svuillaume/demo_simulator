import http from 'k6/http';
import { sleep } from 'k6';

// ✅ Correct declaration: ipPools with regions
const ipPools = {
  us: ['205.185.127.1', '45.83.64.1'],                       // United States
  ca: ['142.112.12.34', '64.254.100.10'],                   // Canada
  fr: ['195.154.200.1', '51.91.120.89'],                    // France
  ru: ['92.63.194.1', '185.220.101.30'],                    // Russia
  cn: ['101.89.0.1', '123.125.71.38'],                      // China
  pk: ['39.32.160.1', '203.99.192.1'],                      // Pakistan
  ae: ['5.194.192.1', '94.200.200.200'],                    // UAE (Middle East)
  sa: ['212.26.64.1', '94.96.200.1'],                       // Saudi Arabia (Middle East)
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

  http.get('http://3.96.209.91:8080', { headers });
  sleep(1);
}
