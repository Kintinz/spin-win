# Build script: encode index.html -> index-encoded.html
# Keeps the full <head> (SEO meta, OG, Twitter, JSON-LD) intact so crawlers see it.
# Only the <body> is base64-encoded to discourage casual source viewing.

$sourceFile = Join-Path $PSScriptRoot 'index.html'
$outputFile = Join-Path $PSScriptRoot 'index-encoded.html'

Write-Host "Reading $sourceFile ..."
$content = [System.IO.File]::ReadAllText($sourceFile, [System.Text.Encoding]::UTF8)

$headEndIdx = $content.IndexOf("</head>")
if($headEndIdx -lt 0){ Write-Error "closing head tag not found"; exit 1 }

$headPart = $content.Substring(0, $headEndIdx + 7)
$bodyPart = $content.Substring($headEndIdx + 7)

Write-Host "Encoding body part ($($bodyPart.Length) chars) ..."
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyPart)
$b64 = [Convert]::ToBase64String($bytes)

$chunks = @()
for($i=0; $i -lt $b64.Length; $i += 76){
  $len = [Math]::Min(76, $b64.Length - $i)
  $chunks += $b64.Substring($i, $len)
}
$b64Formatted = ($chunks -join "`n")

$warning = @"
<!doctype html>
<!--
  CAM XEM MA NGUON - SOURCE CODE VIEWING PROHIBITED
  Fortuna (c) 2026 - All rights reserved
  Contact: datduongnvty@gmail.com
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

# Insert tiny noscript style right before </head>, keep full SEO head intact
$noscriptStyle = '<style>body.__ns{background:#0f1120;color:#f1f3f9;font-family:sans-serif;margin:0;padding:40px;text-align:center}</style>'
$headWithStyle = $headPart -replace '</head>', "$noscriptStyle</head>"

# Plain-text SEO content block for crawlers without JS (Bing, Coc Coc, Zalo, Yandex)
# Sits between <body> and the base64 blob. Hidden the moment JS runs.
$seoBlock = @'
<div id="seo-content" style="max-width:900px;margin:0 auto;padding:24px;font-family:sans-serif;line-height:1.7;color:#eef2f5">
<h1>Spin &amp; Win — Vòng Quay May Mắn &amp; Bốc Thăm Ngẫu Nhiên Miễn Phí</h1>
<p><strong>Spin &amp; Win</strong> (spinwin.io.vn) là công cụ vòng quay may mắn và bốc thăm ngẫu nhiên online miễn phí, dùng cho sự kiện, lớp học, livestream, chia đội và các hoạt động giải trí. Không cần đăng ký, không quảng cáo, hoạt động ngay trên trình duyệt.</p>
<h2>Tính năng chính</h2>
<ul>
<li><strong>Vòng quay tên ngẫu nhiên</strong> — nhập danh sách tên, quay để chọn ngẫu nhiên người thắng.</li>
<li><strong>Quay số ngẫu nhiên</strong> — chọn số trong khoảng bất kỳ, dùng cho xổ số nội bộ, bốc thăm giải thưởng.</li>
<li><strong>Chia đội tự động</strong> — nhập danh sách và số đội, hệ thống chia đều ngẫu nhiên.</li>
<li><strong>Nhiều vòng quay đồng thời</strong> — chạy 2–4 vòng cạnh nhau trên cùng màn hình.</li>
<li><strong>Text-to-speech đọc tên</strong> — đọc to kết quả bằng tiếng Việt / tiếng Anh.</li>
<li><strong>Overlay cho OBS streaming</strong> — nhúng làm Browser Source, nền trong suốt.</li>
<li><strong>QR share</strong> — chia sẻ vòng quay qua mã QR.</li>
<li><strong>Sessions</strong> — lưu và tải lại kịch bản vòng quay.</li>
<li><strong>Suspense drum roll</strong> — hiệu ứng âm thanh hồi hộp khi quay.</li>
</ul>
<h2>Câu hỏi thường gặp</h2>
<h3>Spin &amp; Win có miễn phí không?</h3>
<p>Có. Toàn bộ tính năng đều miễn phí, không cần đăng ký, không quảng cáo.</p>
<h3>Có thể thêm bao nhiêu tên hoặc số?</h3>
<p>Không giới hạn thực tế. Bạn có thể dán hàng trăm tên hoặc số vào một vòng quay.</p>
<h3>Có dùng cho stream OBS được không?</h3>
<p>Có. Trang hỗ trợ overlay trong suốt để nhúng làm Browser Source trong OBS/Streamlabs.</p>
<h3>Có thể chia đội tự động không?</h3>
<p>Có. Nhập danh sách và chọn số đội, hệ thống chia đều ngẫu nhiên.</p>
<h2>Dùng cho mục đích nào?</h2>
<p>Vòng quay may mắn dùng cho tiệc công ty, team building, quiz học sinh, livestream giveaway, chọn người thắng cuộc, bốc thăm giải thưởng, phân công công việc, chia nhóm học tập, chọn nhà hàng ăn trưa và mọi quyết định ngẫu nhiên cần công bằng minh bạch.</p>
<p><em>Lưu ý: Spin &amp; Win là công cụ giải trí, không dành cho cá cược.</em></p>
</div>
<script>(function(){var el=document.getElementById('seo-content');if(el)el.style.display='none';})();</script>
'@

$result = "$warning`n$headWithStyle<body class=`"__ns`">$seoBlock<noscript>Please enable JavaScript.</noscript><script id=`"__e`" type=`"text/plain`">`n$b64Formatted`n</script>$loader</body></html>"

[System.IO.File]::WriteAllText($outputFile, $result, [System.Text.Encoding]::UTF8)

$origSize = (Get-Item $sourceFile).Length
$newSize = (Get-Item $outputFile).Length
Write-Host ""
Write-Host "Build OK: $outputFile"
Write-Host "  Original: $($origSize.ToString('N0')) bytes"
Write-Host "  Encoded:  $($newSize.ToString('N0')) bytes"
