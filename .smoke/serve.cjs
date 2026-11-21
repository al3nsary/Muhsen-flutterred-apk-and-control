// خادمٌ ساكنٌ صغيرٌ لمجلّد docs — للفحصِ وحدَه، على المضيفِ المحلّيّ.
// يطبع رقمَ منفذِه في أوّلِ سطرٍ ثمّ يبقى حتّى يُقتل.
const http = require('http');
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..', 'docs');
const types = {
  '.html': 'text/html; charset=utf-8',
  '.apk': 'application/vnd.android.package-archive',
  '.png': 'image/png',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
};

const server = http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0]);
  if (p.endsWith('/')) p += 'index.html';
  const file = path.join(root, p);
  // لا يُخدَم شيءٌ خارجَ المجلّد.
  if (!file.startsWith(root)) {
    res.writeHead(403).end('no');
    return;
  }
  fs.readFile(file, (err, buf) => {
    if (err) {
      res.writeHead(404).end('not found');
      return;
    }
    res.writeHead(200, {
      'content-type': types[path.extname(file)] || 'application/octet-stream',
      'content-length': buf.length,
    });
    res.end(buf);
  });
});

server.listen(0, '127.0.0.1', () => {
  console.log(server.address().port);
});
