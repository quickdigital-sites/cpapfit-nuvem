/**
 * Leva o build para o tema SEM fork.
 *
 * A plataforma ainda não libera fork ("Forking not yet allowed"), e sem fork o
 * `theme push/watch` só envia templates/ e config/settings_data.json — static/,
 * layouts/ e sections/ são ignorados. Então o build entra por esses dois arquivos:
 *
 *   theme/static/css/tailwind.css -> config/settings_data.json  settings.css_code
 *     (o layout do Ipanema imprime {{ settings.css_code | raw }} em todas as páginas;
 *      o CSS gerado fica entre marcadores e o resto do campo é preservado)
 *
 *   theme/static/js/app.js -> templates/layout/footer.json
 *     (section "custom" + block "code" com o JS inline e o Alpine via CDN,
 *      na versão travada no package-lock)
 *
 * Só grava quando o conteúdo muda, para não entrar em loop com os watchers.
 *
 * Uso: node inject.mjs [--watch]
 */
import { existsSync, readFileSync, watch, writeFileSync } from "node:fs";
import { basename, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const CSS_OUT = resolve(root, "theme/static/css/tailwind.css");
const JS_OUT = resolve(root, "theme/static/js/app.js");
const SETTINGS = resolve(root, "theme/config/settings_data.json");
const FOOTER = resolve(root, "theme/templates/layout/footer.json");

const CSS_START = "/* nuvemshop-dev:start — gerado por frontend/inject.mjs, não edite este trecho */";
const CSS_END = "/* nuvemshop-dev:end */";
const SECTION_ID = "nuvemshop_dev_js";

const lock = JSON.parse(readFileSync(resolve(root, "frontend/package-lock.json"), "utf8"));
const version = (name) => lock.packages[`node_modules/${name}`].version;

const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const kb = (s) => `${(Buffer.byteLength(s) / 1024).toFixed(1)}kb`;

// Mesmo formato dos JSON que vêm do `theme pull`: 2 espaços, UTF-8 cru, \n no fim.
function writeJson(file, data) {
  const out = JSON.stringify(data, null, 2) + "\n";
  if (readFileSync(file, "utf8") === out) return false;
  writeFileSync(file, out);
  return true;
}

function injectCss() {
  // O CSS agora vai no bloco <style> do footer (injectJs): o setting css_code é
  // do tipo custom_css e tem limite de 15000 caracteres, apertado demais para um
  // tema custom. Aqui só limpamos qualquer bloco nosso que tenha ficado no
  // css_code de pushes antigos, preservando o resto (Brand Editor).
  const data = JSON.parse(readFileSync(SETTINGS, "utf8"));
  const current = data.settings.css_code ?? "";
  const re = new RegExp(`\\n*${escapeRe(CSS_START)}[\\s\\S]*?${escapeRe(CSS_END)}`);
  if (!re.test(current)) return;
  data.settings.css_code = current.replace(re, "").trim();
  if (writeJson(SETTINGS, data)) console.log("inject: css_code limpo (CSS movido para o <style> do footer)");
}

// Limite da plataforma para o setting "code" (custom_code): 50.000 caracteres. Margem de segurança.
const BLOCK_LIMIT = 45000;

// Quebra CSS minificado em pedaços <= max, cortando só depois de um "}" de nível 0
// (fim de regra ou de @media inteiro), para cada pedaço ser CSS válido sozinho.
function splitCss(css, max) {
  if (!css) return [];
  if (css.length <= max) return [css];
  const out = [];
  let depth = 0, start = 0, lastCut = -1, quote = null;
  for (let i = 0; i < css.length; i++) {
    const ch = css[i];
    if (quote) { if (ch === "\\") i++; else if (ch === quote) quote = null; continue; }
    if (ch === '"' || ch === "'") quote = ch;
    else if (ch === "{") depth++;
    else if (ch === "}") { depth--; if (depth === 0) lastCut = i + 1; }
    if (i - start + 1 > max && lastCut > start) {
      out.push(css.slice(start, lastCut));
      start = lastCut;
    }
  }
  out.push(css.slice(start));
  return out.filter((c) => c.trim());
}

function injectJs() {
  const css = existsSync(CSS_OUT)
    ? readFileSync(CSS_OUT, "utf8")
        .replace(/\/\*![\s\S]*?\*\/\s*/, "") // banner de licença do Tailwind
        .replace(/<\/style/gi, "<\\/style")
        .trim()
    : "";
  const js = existsSync(JS_OUT)
    ? readFileSync(JS_OUT, "utf8")
        .replace(/\/\/# sourceMappingURL=.*$/m, "") // sourcemap inline do modo watch
        .replace(/<\/script/gi, "<\\/script")
        .trim()
    : "";

  // Ordem importa: <style> primeiro; depois o inline registra o listener de
  // alpine:init antes dos scripts defer (plugin, depois core) executarem.
  const scripts = [
    `<script>${js}</script>`,
    `<script defer src="https://cdn.jsdelivr.net/npm/@alpinejs/collapse@${version("@alpinejs/collapse")}/dist/cdn.min.js"></script>`,
    `<script defer src="https://cdn.jsdelivr.net/npm/alpinejs@${version("alpinejs")}/dist/cdn.min.js"></script>`,
  ].join("\n");

  // O setting "code" (custom_code) aceita no máximo 50.000 caracteres por block. O CSS é
  // quebrado em vários <style> (cortes só entre regras de nível 0) e cada pedaço vai num
  // block "code" próprio; o JS vai no último.
  const pieces = [...splitCss(css, BLOCK_LIMIT - 20).map((c) => `<style>${c}</style>`), scripts];
  for (const p of pieces) {
    if (p.length > BLOCK_LIMIT) throw new Error(`block de código com ${p.length} caracteres (limite ${BLOCK_LIMIT})`);
  }
  const blocks = {};
  const order = [];
  pieces.forEach((code, i) => {
    const id = i === 0 ? "code" : `code_${i + 1}`;
    blocks[id] = { type: "code", settings: { code } };
    order.push(id);
  });

  const data = JSON.parse(readFileSync(FOOTER, "utf8"));
  data.sections[SECTION_ID] = {
    type: "custom",
    settings: { section_width: "full", vertical_padding: 0, horizontal_padding: 0 },
    blocks,
    block_order: order,
  };
  if (!data.order.includes(SECTION_ID)) data.order.push(SECTION_ID);

  if (writeJson(FOOTER, data)) console.log(`inject: footer (código) atualizado — css ${kb(css)} + js ${kb(js)} em ${order.length} blocks`);
}

function run(fn) {
  try {
    fn();
  } catch (err) {
    // arquivo no meio da escrita pelo tailwind/esbuild — o próximo evento resolve
    console.error(`inject: ${err.message}`);
  }
}

run(injectCss);
run(injectJs);

if (process.argv.includes("--watch")) {
  const timers = {};
  const onChange = (file, fn) => (_event, name) => {
    if (name && name !== basename(file)) return;
    clearTimeout(timers[file]);
    timers[file] = setTimeout(() => run(fn), 150);
  };
  // observa a pasta, não o arquivo: tailwind/esbuild podem recriar o arquivo
  watch(dirname(CSS_OUT), onChange(CSS_OUT, () => { injectCss(); injectJs(); }));
  watch(dirname(JS_OUT), onChange(JS_OUT, injectJs));
  console.log("inject em watch — tailwind.css + app.js -> bloco <style>/<script> do footer.json");
}
