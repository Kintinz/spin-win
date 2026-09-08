(function(){
  'use strict';

  // Bypass cho chính chủ khi cần debug: thêm ?dev=1 vào URL
  try{
    var _q = new URLSearchParams(location.search);
    if(_q.get('dev') === '1') return;
  }catch(_){}

  // Bypass cho localhost / dev environment — không kích hoạt bảo vệ khi chạy local.
  try{
    var _h = location.hostname;
    if(_h === 'localhost' || _h === '127.0.0.1' || _h === '' || _h.endsWith('.local')) return;
  }catch(_){}

  // Bypass cho search engine bots (Google, Bing, Facebook, ...) — quan trọng cho SEO
  try{
    var _ua = (navigator.userAgent || '').toLowerCase();
    var _botPattern = /googlebot|bingbot|slurp|duckduckbot|baiduspider|yandex|sogou|exabot|facebot|facebookexternalhit|twitterbot|linkedinbot|whatsapp|telegrambot|zalobot|coccocbot|applebot|petalbot|semrushbot|ahrefsbot|mj12bot|dotbot|lighthouse|chrome-lighthouse|pagespeed|gtmetrix|headlesschrome/i;
    if(_botPattern.test(_ua)) return;
  }catch(_){}

  // ---- 1) Chặn phím tắt xem source / DevTools / save ----
  function blockKey(e){
    var k = e.key || '';
    var K = k.toUpperCase();
    // F12
    if(k === 'F12'){ e.preventDefault(); e.stopPropagation(); return false; }
    // Ctrl+U (view source), Ctrl+S (save), Ctrl+P (print)
    if(e.ctrlKey && !e.shiftKey && !e.altKey && (K==='U'||K==='S'||K==='P')){
      e.preventDefault(); e.stopPropagation(); return false;
    }
    // Ctrl+Shift+I / J / C / K (DevTools)
    if(e.ctrlKey && e.shiftKey && (K==='I'||K==='J'||K==='C'||K==='K')){
      e.preventDefault(); e.stopPropagation(); return false;
    }
    // Cmd+Opt+I / J / U trên Mac
    if(e.metaKey && e.altKey && (K==='I'||K==='J'||K==='C')){
      e.preventDefault(); e.stopPropagation(); return false;
    }
    if(e.metaKey && (K==='U'||K==='S')){
      e.preventDefault(); e.stopPropagation(); return false;
    }
  }
  window.addEventListener('keydown', blockKey, true);

  // ---- 2) Chặn right-click ----
  window.addEventListener('contextmenu', function(e){
    e.preventDefault(); e.stopPropagation(); return false;
  }, true);

  // ---- 3) Chặn kéo / copy nội dung (nhẹ nhàng) ----
  ['dragstart','selectstart'].forEach(function(evt){
    document.addEventListener(evt, function(e){
      var t = e.target && e.target.tagName;
      // vẫn cho phép chọn/kéo trong input để user nhập liệu
      if(t === 'INPUT' || t === 'TEXTAREA' || (e.target && e.target.isContentEditable)) return;
      e.preventDefault();
    }, false);
  });

  // ---- 4) Anti-DevTools: chỉ giữ debugger loop ----
  // Heuristic phát hiện DevTools qua outerHeight/innerHeight đã gỡ:
  // trên mobile nó báo động giả khi bàn phím ảo bung ra, trên desktop nó
  // báo động giả khi user dock DevTools rộng hoặc dùng cửa sổ hẹp.
  function _trap(){ (function(){}).constructor('debugger')(); }
  setInterval(_trap, 1500);

  // ---- 5) Xoá console methods ----
  try{
    var _noop = function(){};
    ['log','info','warn','error','debug','table','dir','trace','group','groupEnd'].forEach(function(m){
      try{ console[m] = _noop; }catch(_){}
    });
  }catch(_){}

  // ---- 6) CSS chặn selection & drag ảnh ----
  try{
    var _st = document.createElement('style');
    _st.textContent = 'body{-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}'+
      'input,textarea,[contenteditable="true"]{-webkit-user-select:text;-moz-user-select:text;-ms-user-select:text;user-select:text}'+
      'img{-webkit-user-drag:none;-khtml-user-drag:none;-moz-user-drag:none;-o-user-drag:none;user-drag:none;pointer-events:auto}';
    document.head.appendChild(_st);
  }catch(_){}
})();
