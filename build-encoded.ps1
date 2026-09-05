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

$result = "$warning`n$headWithStyle<body class=`"__ns`"><noscript>Please enable JavaScript.</noscript><script id=`"__e`" type=`"text/plain`">`n$b64Formatted`n</script>$loader</body></html>"

[System.IO.File]::WriteAllText($outputFile, $result, [System.Text.Encoding]::UTF8)

$origSize = (Get-Item $sourceFile).Length
$newSize = (Get-Item $outputFile).Length
Write-Host ""
Write-Host "Build OK: $outputFile"
Write-Host "  Original: $($origSize.ToString('N0')) bytes"
Write-Host "  Encoded:  $($newSize.ToString('N0')) bytes"
