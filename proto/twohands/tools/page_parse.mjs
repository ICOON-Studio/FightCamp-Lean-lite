// Does the page's script parse? (a page that does not parse shows nothing, and no test would say why)
//   node proto/twohands/tools/page_parse.mjs [switch.html] [order.html]
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
let bad = 0;
for (const page of process.argv.slice(2).length ? process.argv.slice(2) : ['order.html', 'switch.html']) {
  const html = fs.readFileSync(path.join(here, '..', page), 'utf8');
  const a = html.indexOf('<script>') + 8, b = html.lastIndexOf('</script>');
  try { new Function(html.slice(a, b)); console.log(`PAGE_PARSE ${page}: ok`); } catch (e) { bad++; console.log(`PAGE_PARSE ${page}: FAIL ${e.message}`); }
}
process.exit(bad ? 1 : 0);
