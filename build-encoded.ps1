# Build script: encode index.html thành index-encoded.html
# Sau khi build, thay index.html bằng index-encoded.html để deploy
# View-source sẽ chỉ thấy loader + base64 blob thay vì code thật

$sourceFile = "$PSScriptRoot\index.html"
$outputFile = "$PSScriptRoot\index-encoded.html"

Write-Host "📦 Reading $sourceFile ..."
$content = [System.IO.File]::ReadAllText($sourceFile, [System.Text.Encoding]::UTF8)

# Tách phần <!doctype html>...<html...> + <head> đầu (giữ SEO meta tags để Google/social crawl)
# và phần còn lại (body + script) sẽ encode
$headEndIdx = $content.IndexOf("</head>")
if($headEndIdx -lt 0){ Write-Error "Khong tim thay closing head tag"; exit 1 }

$headPart = $content.Substring(0, $headEndIdx + 7) # bao gom head end
$bodyPart = $content.Substring($headEndIdx + 7)    # tu body tro di

Write-Host "🔒 Encoding body part ($($bodyPart.Length) chars) ..."
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyPart)
$b64 = [Convert]::ToBase64String($bytes)

# Chia base64 thành nhiều dòng ngắn để khó copy toàn bộ (còn nữa: obfuscate)
$chunks = @()
for($i=0; $i -lt $b64.Length; $i += 76){
  $len = [Math]::Min(76, $b64.Length - $i)
  $chunks += $b64.Substring($i, $len)
}
$b64Formatted = ($chunks -join "`n")

# Tạo file output với warning + loader
$warning = @"
<!doctype html>
<!--

  ██████╗    █████╗    ███╗   ███╗
  ██╔════╝  ██╔══██╗   ████╗ ████║
  ██║       ███████║   ██╔████╔██║
  ██║       ██╔══██║   ██║╚██╔╝██║
  ╚██████╗  ██║  ██║██╗██║ ╚═╝ ██║
   ╚═════╝  ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝

  ⛔ CẤM XEM MÃ NGUỒN — SOURCE CODE VIEWING PROHIBITED ⛔

  Fortuna © 2026 · All rights reserved

  Việc trích xuất / sao chép / tái sử dụng mã nguồn KHÔNG được phép
  mà không có sự đồng ý bằng văn bản của chủ sở hữu.

  This content is protected by copyright.
  Extracting, copying or reusing the source code is NOT permitted
  without written consent.

  Contact: datduongnvty@gmail.com
  Legal notice: Violators may be subject to legal action under
  copyright law of Vietnam and international treaties (Berne Convention).

  ⚠️  Attempts to decode, deobfuscate, or reverse-engineer this content
      may constitute a violation of applicable law.

-->
"@

$loader = @'
<script>
(function(){
  var _e=document.getElementById('__e').textContent.replace(/\s+/g,'');
  var _b=atob(_e);
  var _bytes=new Uint8Array(_b.length);
  for(var i=0;i<_b.length;i++) _bytes[i]=_b.charCodeAt(i);
  var _s=new TextDecoder('utf-8').decode(_bytes);
  document.open();document.write(_s);document.close();
})();
</script>
'@

# Extract chỉ <head> tối thiểu (title, meta charset, viewport, description) cho crawler
$minimalHead = @'
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description" content="Fortuna - Vòng quay may mắn online miễn phí">
<title>Fortuna — Vòng Quay May Mắn</title>
<style>body{background:#0f1120;color:#f1f3f9;font-family:sans-serif;margin:0;padding:40px;text-align:center}</style>
'@

# Bọc chỉ với minimal head, encoded body
$result = "$warning`n<html lang=`"vi`"><head>$minimalHead</head><body><noscript>Vui lòng bật JavaScript / Please enable JavaScript.</noscript><script id=`"__e`" type=`"text/plain`">`n$b64Formatted`n</script>$loader</body></html>"

[System.IO.File]::WriteAllText($outputFile, $result, [System.Text.Encoding]::UTF8)

$origSize = (Get-Item $sourceFile).Length
$newSize = (Get-Item $outputFile).Length
Write-Host ""
Write-Host "✅ Build xong: $outputFile"
Write-Host "   Original: $($origSize.ToString('N0')) bytes"
Write-Host "   Encoded:  $($newSize.ToString('N0')) bytes (~+33%)"
Write-Host ""
Write-Host "Deploy: copy index-encoded.html → index.html (backup gốc trước!)"
