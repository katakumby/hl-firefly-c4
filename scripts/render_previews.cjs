// Rasterize generated vector diagrams for visual QA; requires the sharp package.
const fs=require('fs'),path=require('path');
const sharp=require(process.env.SHARP_MODULE||'sharp');
const root=path.resolve(__dirname,'..');
const dir=path.join(root,'exports','svg'),out=path.join(root,'.cache','previews');
fs.mkdirSync(out,{recursive:true});
(async()=>{
  for(const name of fs.readdirSync(dir).filter(x=>x.endsWith('.svg')&&!x.endsWith('-key.svg'))){
    let svg=fs.readFileSync(path.join(dir,name),'utf8');
    const vb=svg.match(/viewBox="([\d.\s-]+)"/)[1].split(/\s+/).map(Number);
    const width=2400,height=Math.max(1,Math.round(width*vb[3]/vb[2]));
    svg=svg.replace(/width="[^"]+"/,'width="'+width+'"').replace(/height="[^"]+"/,'height="'+height+'"')
      .replace(/style="width: [^"]+"/,'style="background:#ffffff"');
    await sharp(Buffer.from(svg),{limitInputPixels:false}).flatten({background:'#fff'}).png().toFile(path.join(out,name.replace('.svg','.png')));
  }
  console.log('Rendered',fs.readdirSync(out).length,'preview PNGs.');
})().catch(e=>{console.error(e);process.exit(1)});

