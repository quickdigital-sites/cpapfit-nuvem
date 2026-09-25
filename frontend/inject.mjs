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
  const code = [
    css ? `<style>${css}</style>` : "",
    `<script>${js}</script>`,
    `<script defer src="https://cdn.jsdelivr.net/npm/@alpinejs/collapse@${version("@alpinejs/collapse")}/dist/cdn.min.js"></script>`,
    `<script defer src="https://cdn.jsdelivr.net/npm/alpinejs@${version("alpinejs")}/dist/cdn.min.js"></script>`,
  ].filter(Boolean).join("\n");

  const data = JSON.parse(readFileSync(FOOTER, "utf8"));
  data.sections[SECTION_ID] = {
    type: "custom",
    settings: { section_width: "full", vertical_padding: 0, horizontal_padding: 0 },
    blocks: { code: { type: "code", settings: { code } } },
    block_order: ["code"],
  };
  if (!data.order.includes(SECTION_ID)) data.order.push(SECTION_ID);

  if (writeJson(FOOTER, data)) console.log(`inject: footer (código) atualizado — css ${kb(css)} + js ${kb(js)}`);
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
