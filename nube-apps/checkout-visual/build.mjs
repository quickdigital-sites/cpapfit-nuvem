// Junta src/main.js + src/checkout.css + src/logo-10-anos.png num único dist/checkout-cpapfit.js
// (o portal recebe um arquivo só). Sem dependências: `node build.mjs`.
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";

const here = new URL(".", import.meta.url);
const read = (path) => readFileSync(new URL(path, here));

const css = read("src/checkout.css")
	.toString()
	.replace(/\/\*[\s\S]*?\*\//g, "")
	.replace(/\s+/g, " ")
	.replace(/\s*([{}:;,>])\s*/g, "$1")
	.replace(/;}/g, "}")
	.trim();
const logo = `data:image/png;base64,${read("src/logo-10-anos.png").toString("base64")}`;

const js = read("src/main.js")
	.toString()
	.replace('"__CSS__"', JSON.stringify(css))
	.replace('"__LOGO__"', JSON.stringify(logo));

mkdirSync(new URL("dist/", here), { recursive: true });
writeFileSync(new URL("dist/checkout-cpapfit.js", here), js);
console.log(`dist/checkout-cpapfit.js ${(js.length / 1024).toFixed(1)} KB`);
