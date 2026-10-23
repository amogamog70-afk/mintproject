import {writeFileSync,mkdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {resolve,dirname} from 'node:path';
const root=resolve(dirname(fileURLToPath(import.meta.url)),'..');
// Vector trace of the first (upper-left) mark selected in the supplied reference.
const shapes=[
 [[0,360],[126,126],[285,360],[237,331],[152,231],[94,274]],
 [[54,383],[105,272],[144,249],[196,286]],
 [[226,199],[304,126],[430,398],[287,295],[348,318],[281,238],[264,265]],
];
const leaf=[];
const curve=(a,b,c,d)=>{for(let i=0;i<20;i++){let t=i/20,u=1-t;leaf.push([u*u*u*a[0]+3*u*u*t*b[0]+3*u*t*t*c[0]+t*t*t*d[0],u*u*u*a[1]+3*u*u*t*b[1]+3*u*t*t*c[1]+t*t*t*d[1]]);}};
curve([177,178],[147,109],[205,60],[252,32]);curve([252,32],[276,17],[289,6],[298,0]);curve([298,0],[299,82],[275,139],[214,163]);curve([214,163],[199,170],[188,176],[177,178]);
shapes.push(leaf);
shapes.push([[178,178],[181,143],[194,120],[214,100],[246,77],[224,102],[208,129],[197,155],[190,174]]);
const path=shapes.map(poly=>'M'+poly.map(p=>p.join(',')).join('L')+'Z').join('');
mkdirSync(resolve(root,'assets'),{recursive:true});
writeFileSync(resolve(root,'assets/mint-logo.svg'),`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 430 398"><path fill="white" fill-rule="evenodd" d="${path}"/></svg>\n`);
const runs=[],height=80,width=86;
for(let y=0;y<height;y++){
 const scan=(y+.5)*398/height, intersections=[];
 for(const poly of shapes) for(let i=0,j=poly.length-1;i<poly.length;j=i++){
  const a=poly[i],b=poly[j];if((a[1]>scan)!==(b[1]>scan))intersections.push((a[0]+(scan-a[1])*(b[0]-a[0])/(b[1]-a[1]))/430);
 }
 intersections.sort((a,b)=>a-b);
 for(let i=0;i<intersections.length;i+=2)runs.push([intersections[i],y/height,intersections[i+1]-intersections[i],1/height]);
}
let source='-- Native vector spans: no image upload, HTTP request or custom asset API required.\nlocal Logo = {}\nlocal spans = {\n';
source+=runs.map(r=>'    {'+r.map(n=>Number(n.toFixed(6))).join(',')+'},').join('\n');
source+='\n}\nfunction Logo.draw(ctx, parent, position, size)\n    local root=ctx:New("Frame",{Name="MintLogo",BackgroundTransparency=1,Position=position,Size=size},parent)\n    for _,s in ipairs(spans) do\n        local bar=ctx:New("Frame",{Position=UDim2.fromScale(s[1],s[2]),Size=UDim2.fromScale(s[3],s[4])},root)\n        ctx:Paint(bar,"Text")\n    end\n    return root\nend\nreturn Logo\n';
writeFileSync(resolve(root,'src/Logo.luau'),source);
console.log('Created selected logo SVG and native UI spans: '+runs.length);
