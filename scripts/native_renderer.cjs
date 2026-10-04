// Uses the exact renderer and GIF encoder bundled with the pinned Structurizr WAR.
// Run only inside the tools image; all HTTP traffic stays on its internal loopback.
'use strict';
const fs = require('node:fs');
const path = require('node:path');
const puppeteer = require('/opt/renderers/node_modules/puppeteer');

async function main() {
  const request = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
  const config = JSON.parse(fs.readFileSync('/opt/renderers/puppeteer.json', 'utf8'));
  const browser = await puppeteer.launch({...config, headless: true, protocolTimeout: 180000});
  try {
    const page = await browser.newPage();
    await page.emulateMediaFeatures([{name: 'prefers-color-scheme', value: 'light'}]);
    const errors = [], blocked = [];
    page.on('pageerror', error => errors.push(error.message));
    await page.setRequestInterception(true);
    page.on('request', resource => {
      const url = resource.url();
      if (url.startsWith(request.url + '/') || url.startsWith('data:') || url.startsWith('blob:')) {
        resource.continue();
      } else {
        blocked.push(url);
        resource.abort();
      }
    });
    await page.goto(request.url + '/index.html?introduction=false&diagram=' + encodeURIComponent(request.keys[0]));
    await page.waitForFunction(() => window.structurizr && structurizr.scripting &&
      structurizr.scripting.isDiagramRendered(), {timeout: 60000});
    await page.evaluate(() => document.fonts.ready);
    if (request.format === 'gif') {
      await page.addScriptTag({url: request.url + '/js/gifshot-0.4.4.js'});
    }
    const manifest = [];
    for (const key of request.keys) {
      const exported = await page.evaluate(async ({key, format, duration}) => {
        const options = {format: format === 'gif' ? 'png' : format,
          metadata: true, crop: false, animation: format === 'gif', prefix: ''};
        if (format !== 'gif') {
          return await new Promise(resolve => {
            let result;
            structurizr.scripting.exportViews([key], options, (view, diagram, legend) => {
              result = {diagram: diagram.content, legend: legend && legend.content};
            }, () => resolve(result));
          });
        }
        const images = [];
        await new Promise(resolve => structurizr.diagram.changeView(key, resolve));
        if (structurizr.diagram.currentViewIsDynamic()) {
          // v2026.06.28 exportViews(animation=true) misses dynamic views. Use the
          // same playback API as the viewer, including parallel interaction groups.
          const view = structurizr.workspace.findViewByKey(key);
          const maximum = view.relationships.length + 1;
          const capture = () => new Promise(resolve =>
            structurizr.diagram.exportCurrentDiagramToPNG(options, image => { images.push(image); resolve(); }));
          structurizr.diagram.startAnimation(false);
          while (structurizr.diagram.animationStarted()) {
            if (images.length >= maximum) throw new Error('Dynamic animation did not terminate: ' + key);
            await capture();
            structurizr.diagram.stepForwardInAnimation();
          }
          await capture(); // Final overview, matching the viewer's end-of-animation state.
        } else {
          await new Promise(resolve => structurizr.scripting.exportViews([key], options,
            (view, diagram) => images.push(diagram.content), resolve));
        }
        if (images.length < 2) throw new Error('No animated frames were produced: ' + key);
        const first = new Image(); first.src = images[0]; await first.decode();
        const gif = await new Promise((resolve, reject) => gifshot.createGIF({
          gifWidth: first.naturalWidth, gifHeight: first.naturalHeight,
          images, interval: duration, frameDuration: 1
        }, result => result.error ? reject(new Error(JSON.stringify(result))) : resolve(result.image)));
        return {diagram: gif, frames: images.length};
      }, {key, format: request.format, duration: request.frame_duration});
      if (!exported || !exported.diagram) throw new Error('Missing diagram: ' + key);
      for (const [role, data] of [['diagram', exported.diagram], ['key', exported.legend]]) {
        if (!data) continue;
        const match = /^data:image\/(?:png|svg\+xml|gif);base64,([\s\S]+)$/.exec(data);
        if (!match) throw new Error('Unexpected export encoding: ' + key);
        // Numeric scratch names prevent keys from interpreting paths. The Python
        // publisher applies canonical, validated source-mirrored destinations.
        const file = `${manifest.length}.${request.format}`;
        fs.writeFileSync(path.join(request.output, file), Buffer.from(match[1], 'base64'));
        manifest.push({view: key, role, file, frames: exported.frames});
      }
      console.log(`Rendered ${key}: ${request.format}`);
    }
    if (blocked.length) throw new Error('Offline native export blocked external resources: ' + [...new Set(blocked)].join(', '));
    if (errors.length) throw new Error('Structurizr browser errors: ' + [...new Set(errors)].join('; '));
    fs.writeFileSync(path.join(request.output, 'rendered.json'), JSON.stringify(manifest));
  } finally {
    await browser.close();
  }
}

main().catch(error => { console.error(error.stack || error); process.exitCode = 1; });
