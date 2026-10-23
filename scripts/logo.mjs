import {writeFileSync,mkdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {resolve,dirname} from 'node:path';
const root=resolve(dirname(fileURLToPath(import.meta.url)),'..');
// One serrated mint leaf with a cut-out midrib and three pairs of veins.
const axis=t=>[15+68*t,86-74*t];
const normal=[0.736,0.676];
const side=(t,sign)=>{
 const [x,y]=axis(t), serration=1-0.1*Math.abs(Math.sin(t*Math.PI*14));
 const width=27*Math.pow(Math.sin(Math.PI*t),0.82)*serration;
 return [x+normal[0]*width*sign,y+normal[1]*width*sign];
};
const leaf=[];
for(let i=0;i<=112;i++)leaf.push(side(i/112,1));
for(let i=111;i>=0;i--)leaf.push(side(i/112,-1));
const shapes=[leaf];
const vein=[];
for(let i=0;i<=40;i++){
 const t=0.05+0.83*i/40,[x,y]=axis(t),w=0.65*Math.sin(Math.PI*t);
 vein.push([x+normal[0]*w,y+normal[1]*w]);
}
for(let i=40;i>=0;i--){
 const t=0.05+0.83*i/40,[x,y]=axis(t),w=0.65*Math.sin(Math.PI*t);
 vein.push([x-normal[0]*w,y-normal[1]*w]);
}
shapes.push(vein);
for(const t of [.3,.48,.65]) for(const sign of [-1,1]){
 const [x,y]=axis(t),[bx,by]=side(t+.16,sign);
 shapes.push([[x+1,y-1],[bx*.85+x*.15,by*.85+y*.15],[x+2.2,y-.5]]);
}
const path=shapes.map(poly=>'M'+poly.map(p=>p.map(v=>+v.toFixed(3)).join(',')).join('L')+'Z').join('');
mkdirSync(resolve(root,'assets'),{recursive:true});
writeFileSync(resolve(root,'assets/mint-logo.svg'),`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path fill="#6be6b4" fill-rule="evenodd" d="${path}"/></svg>\n`);
const runs=[],height=72;
for(let y=0;y<height;y++){
 const scan=(y+.5)*100/height,intersections=[];
 for(const poly of shapes)for(let i=0,j=poly.length-1;i<poly.length;j=i++){
  const a=poly[i],b=poly[j];
  if((a[1]>scan)!==(b[1]>scan))intersections.push((a[0]+(scan-a[1])*(b[0]-a[0])/(b[1]-a[1]))/100);
 }
 intersections.sort((a,b)=>a-b);
 for(let i=0;i<intersections.length;i+=2)runs.push([intersections[i],y/height,intersections[i+1]-intersections[i],1/height]);
}
let source='-- Mint leaf, rendered locally without image downloads.\nlocal Logo = {}\nlocal spans = {\n';
source+=runs.map(r=>'    {'+r.map(n=>Number(n.toFixed(6))).join(',')+'},').join('\n');
source+=`\n}
function Logo.draw(ctx, parent, position, size)
    local root=ctx:New('Frame',{Name='MintLogo',BackgroundTransparency=1,Position=position,Size=size},parent)
    for _,s in ipairs(spans) do
        local bar=ctx:New('Frame',{Position=UDim2.fromScale(s[1],s[2]),Size=UDim2.fromScale(s[3],s[4])},root)
        ctx:Paint(bar,'Accent')
    end
    return root
end
return Logo
`;
writeFileSync(resolve(root,'src/Logo.luau'),source);
console.log('Generated mint leaf SVG and '+runs.length+' native UI spans');
