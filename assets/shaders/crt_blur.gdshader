shader_type canvas_item;

//
// PUBLIC DOMAIN CRT STYLED SCAN-LINE SHADER
//
//   by Timothy Lottes
//
// This is more along the style of a really good CGA arcade monitor.
// With RGB inputs instead of NTSC.
// The shadow mask example has the mask rotated 90 degrees for less chromatic aberration.
//
// Left it unoptimized to show the theory behind the algorithm.
//
// It is an example what I personally would want as a display option for pixel art games.
// Please take and use, change, or whatever.
//

// Emulated input resolution.
#if 0
  // Fix resolution to set amount.
  vec2 res=vec2(320.0/1.0,160.0/1.0);
#else
  // Optimize for resize.
  //#define res (iResolution.xy/6.0)
#endif

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Hardness of scanline.
//  -8.0 = soft
// -16.0 = medium
uniform float hardScan=-10.0;

// Hardness of pixels in scanline.
// -2.0 = soft
// -4.0 = hard
uniform float hardPix=-4.0;

// Hardness of short vertical bloom.
//  -1.0 = wide to the point of clipping (bad)
//  -1.5 = wide
//  -4.0 = not very wide at all
uniform float hardBloomScan=-2.0;

// Hardness of short horizontal bloom.
//  -0.5 = wide to the point of clipping (bad)
//  -1.0 = wide
//  -2.0 = not very wide at all
uniform float hardBloomPix=-1.5;

// Amount of small bloom effect.
//  1.0/1.0 = only bloom
//  1.0/16.0 = what I think is a good amount of small bloom
//  0.0     = no bloom
uniform float bloomAmount=0.0625;

// Display warp.
// 0.0 = none
// 1.0/8.0 = extreme
uniform vec2 warp=vec2(0.015625,0.04166666666); 

// Amount of shadow mask.
uniform float maskDark=0.5;
uniform float maskLight=1.5;

uniform float wiggleMult:hint_range(0.0, 0.1, 0.0001)=0.005;

//------------------------------------------------------------------------

// sRGB to Linear.
// Assuing using sRGB typed textures this should not be needed.
float ToLinear1(float c){return(c<=0.04045)?c/12.92:pow((c+0.055)/1.055,2.4);}
vec3 ToLinear(vec3 c){return vec3(ToLinear1(c.r),ToLinear1(c.g),ToLinear1(c.b));}

// Linear to sRGB.
// Assuing using sRGB typed textures this should not be needed.
float ToSrgb1(float c){return(c<0.0031308?c*12.92:1.055*pow(c,0.41666)-0.055);}
vec3 ToSrgb(vec3 c){return vec3(ToSrgb1(c.r),ToSrgb1(c.g),ToSrgb1(c.b));}

// Testing only, something to help generate a dark signal for bloom test.
// Set to zero, or remove Test() if using this shader.
#if 1
 vec3 Test(vec3 c){return c*(1.0/64.0)+c*c*c;}
#else
 vec3 Test(vec3 c){return c;}
#endif

// Nearest emulated sample given floating point position and texel offset.
// Also zero's off screen.
vec3 Fetch(vec2 pos,vec2 off,vec2 res, sampler2D iChannel0){
  pos=floor(pos*res+off)/res;
  if(max(abs(pos.x-0.5),abs(pos.y-0.5))>0.5)return vec3(0.0,0.0,0.0);
  return Test(ToLinear(texture(iChannel0,pos.xy,-16.0).rgb));}

// Distance in emulated pixels to nearest texel.
vec2 Dist(vec2 pos,vec2 res){pos=pos*res;return -((pos-floor(pos))-vec2(0.5));}
    
// 1D Gaussian.
float Gaus(float pos,float scale){return exp2(scale*pos*pos);}

// 3-tap Gaussian filter along horz line.
vec3 Horz3(vec2 pos,float off,vec2 res,sampler2D iChannel0){
  vec3 b=Fetch(pos,vec2(-1.0,off),res,iChannel0);
  vec3 c=Fetch(pos,vec2( 0.0,off),res,iChannel0);
  vec3 d=Fetch(pos,vec2( 1.0,off),res,iChannel0);
  float dst=Dist(pos,res).x;
  // Convert distance to weight.
  float scale=hardPix;
  float wb=Gaus(dst-1.0,scale);
  float wc=Gaus(dst+0.0,scale);
  float wd=Gaus(dst+1.0,scale);
  // Return filtered sample.
  return (b*wb+c*wc+d*wd)/(wb+wc+wd);}

// 5-tap Gaussian filter along horz line.
vec3 Horz5(vec2 pos,float off,vec2 res,sampler2D iChannel0){
  vec3 a=Fetch(pos,vec2(-2.0,off),res,iChannel0);
  vec3 b=Fetch(pos,vec2(-1.0,off),res,iChannel0);
  vec3 c=Fetch(pos,vec2( 0.0,off),res,iChannel0);
  vec3 d=Fetch(pos,vec2( 1.0,off),res,iChannel0);
  vec3 e=Fetch(pos,vec2( 2.0,off),res,iChannel0);
  float dst=Dist(pos,res).x;
  // Convert distance to weight.
  float scale=hardPix;
  float wa=Gaus(dst-2.0,scale);
  float wb=Gaus(dst-1.0,scale);
  float wc=Gaus(dst+0.0,scale);
  float wd=Gaus(dst+1.0,scale);
  float we=Gaus(dst+2.0,scale);
  // Return filtered sample.
  return (a*wa+b*wb+c*wc+d*wd+e*we)/(wa+wb+wc+wd+we);}

// 7-tap Gaussian filter along horz line.
vec3 Horz7(vec2 pos,float off,vec2 res,sampler2D iChannel0){
  vec3 a=Fetch(pos,vec2(-3.0,off),res,iChannel0);
  vec3 b=Fetch(pos,vec2(-2.0,off),res,iChannel0);
  vec3 c=Fetch(pos,vec2(-1.0,off),res,iChannel0);
  vec3 d=Fetch(pos,vec2( 0.0,off),res,iChannel0);
  vec3 e=Fetch(pos,vec2( 1.0,off),res,iChannel0);
  vec3 f=Fetch(pos,vec2( 2.0,off),res,iChannel0);
  vec3 g=Fetch(pos,vec2( 3.0,off),res,iChannel0);
  float dst=Dist(pos,res).x;
  // Convert distance to weight.
  float scale=hardBloomPix;
  float wa=Gaus(dst-3.0,scale);
  float wb=Gaus(dst-2.0,scale);
  float wc=Gaus(dst-1.0,scale);
  float wd=Gaus(dst+0.0,scale);
  float we=Gaus(dst+1.0,scale);
  float wf=Gaus(dst+2.0,scale);
  float wg=Gaus(dst+3.0,scale);
  // Return filtered sample.
  return (a*wa+b*wb+c*wc+d*wd+e*we+f*wf+g*wg)/(wa+wb+wc+wd+we+wf+wg);}

// Return scanline weight.
float Scan(vec2 pos,float off,vec2 res){
  float dst=Dist(pos,res).y;
  return Gaus(dst+off,hardScan);}

// Return scanline weight for bloom.
float BloomScan(vec2 pos,float off,vec2 res){
  float dst=Dist(pos,res).y;
  return Gaus(dst+off,hardBloomScan);}

// Allow nearest three lines to effect pixel.
vec3 Tri(vec2 pos,vec2 res,sampler2D iChannel0){
  vec3 a=Horz3(pos,-1.0,res,iChannel0);
  vec3 b=Horz5(pos, 0.0,res,iChannel0);
  vec3 c=Horz3(pos, 1.0,res,iChannel0);
  float wa=Scan(pos,-1.0,res);
  float wb=Scan(pos, 0.0,res);
  float wc=Scan(pos, 1.0,res);
  return a*wa+b*wb+c*wc;}

// Small bloom.
vec3 Bloom(vec2 pos,vec2 res,sampler2D iChannel0){
  vec3 a=Horz5(pos,-2.0,res,iChannel0);
  vec3 b=Horz7(pos,-1.0,res,iChannel0);
  vec3 c=Horz7(pos, 0.0,res,iChannel0);
  vec3 d=Horz7(pos, 1.0,res,iChannel0);
  vec3 e=Horz5(pos, 2.0,res,iChannel0);
  float wa=BloomScan(pos,-2.0,res);
  float wb=BloomScan(pos,-1.0,res);
  float wc=BloomScan(pos, 0.0,res);
  float wd=BloomScan(pos, 1.0,res);
  float we=BloomScan(pos, 2.0,res);
  return a*wa+b*wb+c*wc+d*wd+e*we;}

// Distortion of scanlines, and end of screen alpha.
vec2 Warp(vec2 pos){
  pos=pos*2.0-1.0;    
  pos*=vec2(1.0+(pos.y*pos.y)*warp.x,1.0+(pos.x*pos.x)*warp.y);
  return pos*0.5+0.5;}

#if 0
// Very compressed TV style shadow mask.
vec3 Mask(vec2 pos){
  float line=maskLight;
  float odd=0.0;
  if(fract(pos.x/6.0)<0.5)odd=1.0;
  if(fract((pos.y+odd)/2.0)<0.5)line=maskDark;  
  pos.x=fract(pos.x/3.0);
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  mask*=line;
  return mask;}        
#endif

#if 1
// Aperture-grille.
vec3 Mask(vec2 pos){
  pos.x=fract(pos.x/3.0);
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  return mask;}        
#endif

#if 0
// Stretched VGA style shadow mask (same as prior shaders).
vec3 Mask(vec2 pos){
  pos.x+=pos.y*3.0;
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  pos.x=fract(pos.x/6.0);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  return mask;}    
#endif

#if 0
// VGA style shadow mask.
vec3 Mask(vec2 pos){
  pos.xy=floor(pos.xy*vec2(1.0,0.5));
  pos.x+=pos.y*3.0;
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  pos.x=fract(pos.x/6.0);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  return mask;}    
#endif


// Draw dividing bars.
float Bar(float pos,float bar){pos-=bar;return pos*pos<4.0?0.0:1.0;}

// Entry.
void fragment(){
	vec2 iResolution = 1.0/SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
  vec2 pos=Warp(FRAGCOORD.xy/iResolution.xy);
  pos.x = sin(0.3*TIME+uv.y*21.0)*sin(0.7*TIME+uv.y*29.0)*sin(0.3+0.33*TIME+uv.y*31.0)*wiggleMult + uv.x;
  COLOR.rgb=Tri(pos, iResolution, SCREEN_TEXTURE)*Mask(FRAGCOORD.xy);
  #if 0
    // Normalized exposure.
  	fragColor.rgb=mix(fragColor.rgb,Bloom(pos),bloomAmount);    
  #else
    // Additive bloom.
  	COLOR.rgb+=Bloom(pos, iResolution, SCREEN_TEXTURE)*bloomAmount;    
  #endif    
  COLOR.a=1.0;  
  COLOR.rgb=ToSrgb(COLOR.rgb);
}

