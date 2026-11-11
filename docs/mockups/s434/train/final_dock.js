// S434 TRAINSCENE1 final: the preview dock (one shared MoveTip card for every session, move, combination and number).
// Rest the mouse 250 ms on anything with data-pic: the fighter's frame plays it. While it is open the next item swaps at once.
// Leave every item for 300 ms and the portrait comes back. It never follows the cursor, never covers a card, plays no sound.
(function(){
  var dock=document.querySelector('.dock'); if(!dock) return;
  var act=dock.querySelector('.act'),openT=null,closeT=null,cur=null;
  function q(s){return act.querySelector(s);}
  function fill(el){
    var p=el.dataset.pic,mv=q('.mv'),bg=q('.bg'),d=el.dataset;
    var icon=p.indexOf('icon:')===0;
    if(icon){mv.innerHTML='<svg viewBox="0 0 48 48"><use href="#'+p.slice(5)+'"/></svg>';bg.style.display='none';}
    else{mv.innerHTML='<img src="'+p+'">';bg.src=p;bg.style.display='block';}
    dock.classList.toggle('compact',icon&&!d.big);
    q('.live b').textContent=d.live||dock.dataset.live||'LIVE';
    q('.tk').textContent=d.k||'';q('.tn').textContent=d.n||'';
    var t=q('.tier');
    if(d.lad){var n=parseFloat(d.lad),h='';for(var i=0;i<5;i++){h+='<i class="'+(i<Math.floor(n)?'d':'')+'"'+(i===Math.floor(n)&&n%1?' style="background:linear-gradient(90deg,var(--blue) '+Math.round(n%1*100)+'%,rgba(255,255,255,.14) 0)"':'')+'></i>';}
      t.innerHTML='<span class="lad">'+h+'</span><b>'+(d.tier||'')+'</b>';t.style.display='flex';}
    else t.style.display='none';
    var rows='';[['b','BUILDS'],['c','COSTS'],['w','WHY'],['o',d.ol||'OTHER LOAD']].forEach(function(r){var v=d[r[0]];if(v)rows+='<div class="row '+r[0]+'"><em>'+r[1]+'</em><span>'+v+'</span></div>';});
    q('.rows').innerHTML=rows;
    if(cur)cur.classList.remove('hov');cur=el;el.classList.add('hov');
  }
  function open(){dock.classList.add('open');}
  function close(){dock.classList.remove('open');if(cur)cur.classList.remove('hov');cur=null;}
  document.querySelectorAll('[data-pic]').forEach(function(el){
    el.addEventListener('mouseenter',function(){clearTimeout(closeT);clearTimeout(openT);
      if(dock.classList.contains('open')){fill(el);} else openT=setTimeout(function(){fill(el);open();},250);});
    el.addEventListener('mouseleave',function(){clearTimeout(openT);closeT=setTimeout(close,300);});
  });
  window.dockDemo=function(el){fill(el);open();
    var c=document.querySelector('.cursor');if(c){var r=el.getBoundingClientRect();c.style.left=(r.left+r.width*0.3)+'px';c.style.top=(r.top+r.height*0.36)+'px';}
    document.body.classList.add('demo');};
})();
// the no-bout twin: elements with data-nb swap their content, .bo hides, .nb shows
if(location.hash==='#nobout'){
  document.body.classList.add('nobout');
  document.querySelectorAll('[data-nb]').forEach(function(el){el.innerHTML=el.dataset.nb;});
  document.querySelectorAll('[data-nbk]').forEach(function(el){el.dataset.k=el.dataset.nbk;});
  document.querySelectorAll('[data-nbb]').forEach(function(el){el.dataset.b=el.dataset.nbb;});
}
// count-ups: the final number is in the HTML; this only runs it up from below
document.querySelectorAll('[data-count]').forEach(function(el){
  var to=parseFloat(el.dataset.count),dec=+(el.dataset.dec||0),from=dec?to-1.5:Math.max(0,to-30),n=0,steps=24;
  el.textContent=from.toFixed(dec);
  var iv=setInterval(function(){n++;var v=from+(to-from)*(1-Math.pow(1-n/steps,3));el.textContent=v.toFixed(dec);if(n>=steps){clearInterval(iv);el.textContent=to.toFixed(dec);}},40);
});
