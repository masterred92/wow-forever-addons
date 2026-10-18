#!/usr/bin/env node
// Release helper (Node 20+, no dependencies). Written for this repo (MIT).
//   node tools/release.js check                    TOC versions match versions.json, Interface 16001, shared files in sync
//   node tools/release.js version <Addon> <x.y.z>  set one addon's version everywhere
//   node tools/release.js pack                     reproducible zips + SHA256SUMS in dist/
'use strict';
const fs = require('fs'), path = require('path'), crypto = require('crypto');
const ROOT = path.resolve(__dirname, '..');
const INTERFACE = '16001';
const versionsFile = path.join(ROOT, 'versions.json');
const versions = JSON.parse(fs.readFileSync(versionsFile, 'utf8'));
const SHARED = ['Compat.lua', 'Core.lua'];
const EXTRA = ['LICENSE', 'THIRD_PARTY.md'];
const FIXED_DATE = { y: 2026, m: 1, d: 1 }; // every zip entry gets this timestamp

const tocPath = (a) => path.join(ROOT, a, `${a}.toc`);
const tocField = (text, f) => (text.match(new RegExp(`^## ${f}: *(.*)$`, 'm')) || [])[1];

function check() {
  const errs = [];
  for (const [addon, ver] of Object.entries(versions)) {
    const toc = fs.readFileSync(tocPath(addon), 'utf8');
    if (tocField(toc, 'Version') !== ver) errs.push(`${addon}: TOC Version ${tocField(toc, 'Version')} != versions.json ${ver}`);
    if (tocField(toc, 'Interface') !== INTERFACE) errs.push(`${addon}: Interface ${tocField(toc, 'Interface')} != ${INTERFACE}`);
    if (!/UNTESTED IN-GAME/.test(tocField(toc, 'Notes') || '')) errs.push(`${addon}: Notes lack the untested disclaimer`);
    for (const f of SHARED) {
      if (!fs.readFileSync(path.join(ROOT, 'shared', f)).equals(fs.readFileSync(path.join(ROOT, addon, f))))
        errs.push(`${addon}/${f} differs from shared/${f} (run tools/sync_shared.sh)`);
    }
    for (const line of toc.split('\n').filter((l) => l.trim() && !l.startsWith('#')))
      if (!fs.existsSync(path.join(ROOT, addon, line.trim()))) errs.push(`${addon}: TOC lists missing file ${line.trim()}`);
  }
  if (errs.length) { console.error(errs.join('\n')); process.exit(1); }
  console.log('release check OK:', Object.entries(versions).map(([a, v]) => `${a} ${v}`).join(', '));
}

function setVersion(addon, ver) {
  if (!versions[addon] || !/^\d+\.\d+\.\d+$/.test(ver || '')) { console.error('usage: version <Addon> <x.y.z>'); process.exit(1); }
  versions[addon] = ver;
  fs.writeFileSync(versionsFile, JSON.stringify(versions, null, 2) + '\n');
  const p = tocPath(addon);
  fs.writeFileSync(p, fs.readFileSync(p, 'utf8').replace(/^## Version: .*$/m, `## Version: ${ver}`));
  check();
}

// --- minimal reproducible ZIP writer (stored entries, fixed timestamps, sorted names) ---
const CRC_TABLE = (() => { const t = new Uint32Array(256); for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1; t[n] = c >>> 0; } return t; })();
function crc32(buf) { let c = 0xffffffff; for (const b of buf) c = CRC_TABLE[(c ^ b) & 0xff] ^ (c >>> 8); return (c ^ 0xffffffff) >>> 0; }
function zip(entries) { // entries: [{name, data}]
  const dosTime = 0, dosDate = ((FIXED_DATE.y - 1980) << 9) | (FIXED_DATE.m << 5) | FIXED_DATE.d;
  const locals = [], centrals = []; let offset = 0;
  for (const { name, data } of entries.sort((a, b) => (a.name < b.name ? -1 : 1))) {
    const n = Buffer.from(name, 'utf8'), crc = crc32(data);
    const lh = Buffer.alloc(30); lh.writeUInt32LE(0x04034b50, 0); lh.writeUInt16LE(10, 4); lh.writeUInt16LE(0x0800, 6);
    lh.writeUInt16LE(0, 8); lh.writeUInt16LE(dosTime, 10); lh.writeUInt16LE(dosDate, 12); lh.writeUInt32LE(crc, 14);
    lh.writeUInt32LE(data.length, 18); lh.writeUInt32LE(data.length, 22); lh.writeUInt16LE(n.length, 26); lh.writeUInt16LE(0, 28);
    const ch = Buffer.alloc(46); ch.writeUInt32LE(0x02014b50, 0); ch.writeUInt16LE(0x031e, 4); ch.writeUInt16LE(10, 6);
    ch.writeUInt16LE(0x0800, 8); ch.writeUInt16LE(0, 10); ch.writeUInt16LE(dosTime, 12); ch.writeUInt16LE(dosDate, 14);
    ch.writeUInt32LE(crc, 16); ch.writeUInt32LE(data.length, 20); ch.writeUInt32LE(data.length, 24); ch.writeUInt16LE(n.length, 28);
    ch.writeUInt32LE((0o100644 << 16) >>> 0, 38); ch.writeUInt32LE(offset, 42);
    locals.push(lh, n, data); centrals.push(ch, n); offset += 30 + n.length + data.length;
  }
  const cd = Buffer.concat(centrals), end = Buffer.alloc(22);
  end.writeUInt32LE(0x06054b50, 0); end.writeUInt16LE(entries.length, 8); end.writeUInt16LE(entries.length, 10);
  end.writeUInt32LE(cd.length, 12); end.writeUInt32LE(offset, 16);
  return Buffer.concat([...locals, cd, end]);
}

function pack() {
  check();
  const dist = path.join(ROOT, 'dist'); fs.mkdirSync(dist, { recursive: true });
  const sums = [];
  for (const [addon, ver] of Object.entries(versions)) {
    const dir = path.join(ROOT, addon), entries = [];
    for (const f of fs.readdirSync(dir)) {
      const p = path.join(dir, f);
      if (!fs.statSync(p).isFile()) continue; // dev folders (tools/) are not shipped
      if (f === 'README.md') entries.push({ name: `${addon}/README.txt`, data: fs.readFileSync(p) });
      else entries.push({ name: `${addon}/${f}`, data: fs.readFileSync(p) });
    }
    for (const f of EXTRA) entries.push({ name: `${addon}/${f}`, data: fs.readFileSync(path.join(ROOT, f)) });
    const file = `${addon}-${ver}.zip`, buf = zip(entries);
    fs.writeFileSync(path.join(dist, file), buf);
    sums.push(`${crypto.createHash('sha256').update(buf).digest('hex')}  ${file}`);
  }
  fs.writeFileSync(path.join(dist, 'SHA256SUMS'), sums.join('\n') + '\n');
  console.log(sums.join('\n'));
}

const [cmd, a, b] = process.argv.slice(2);
if (cmd === 'check') check(); else if (cmd === 'version') setVersion(a, b); else if (cmd === 'pack') pack();
else { console.error('usage: release.js check | version <Addon> <x.y.z> | pack'); process.exit(1); }
