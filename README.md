# Spin &amp; Win

> Bộ công cụ ngẫu nhiên trực tuyến — miễn phí, không đăng ký, chạy hoàn toàn trên trình duyệt.
>
> **Live:** [spinwin.io.vn](https://spinwin.io.vn/)

Vòng quay may mắn, bốc thăm, chọn số, con lăn slot machine và một đường đua ngẫu nhiên (6 loại nhân vật) — tất cả trong một trang, hai ngôn ngữ VI/EN, sẵn overlay cho OBS livestream.

---

## Các trang

| URL | Chức năng |
|---|---|
| [`/`](https://spinwin.io.vn/) | Landing hub — giới thiệu + link 5 công cụ |
| [`/spin/`](https://spinwin.io.vn/spin/) | Vòng quay tên (Random Name Picker) |
| [`/number/`](https://spinwin.io.vn/number/) | Quay số ngẫu nhiên nhiều chữ số |
| [`/range/`](https://spinwin.io.vn/range/) | Chọn 1 số trong khoảng bất kỳ |
| [`/roller/`](https://spinwin.io.vn/roller/) | Con lăn slot machine đa cột |
| [`/duck/`](https://spinwin.io.vn/duck/) | Đường đua ngẫu nhiên — tối đa 3.000 người, 6 skin |

Các URL `.html` cũ (`spin.html`, `duck.html`, …) redirect 200ms sang path clean tương ứng, canonical đã cập nhật để Google index đúng.

## Tính năng nổi bật

- **Song ngữ VI / EN** — chuyển ngôn ngữ realtime ở header.
- **TTS đọc tên winner** — Web Speech API, tự chọn giọng OS phù hợp với ngôn ngữ đang bật.
- **Overlay OBS / Streamlabs** — thêm `?overlay=1` vào URL cho nền trong suốt, dùng làm Browser Source.
- **QR share** — sinh mã QR cho mỗi vòng quay để người xem quét tham gia.
- **Sessions** — lưu / tải lại danh sách vòng quay ở `localStorage`, không upload server.
- **Dark / Light theme** — theo hệ thống, có nút chuyển thủ công.
- **Đường đua**: 6 skin (vịt, ngựa, xe, rùa, ốc sên, tàu vũ trụ), leaderboard live, xem "top winners" hoặc "toàn bộ xếp hạng", nhạc nền, victory drift camera.

## Cấu trúc thư mục

```
lucky-wheel/
├── index.html                landing hub (plaintext, SEO tối ưu)
├── spin/index.html           mode: name wheel
├── number/index.html         mode: number picker
├── range/index.html          mode: single-number range
├── roller/index.html         mode: slot machine roller
├── duck/index.html           mode: random race track
├── {spin,number,...}.html    stub redirect từ URL cũ sang path clean
├── trick.html                utility page
├── CNAME                     tên miền tùy chỉnh (GitHub Pages)
├── robots.txt, sitemap.xml   SEO
├── assets/
│   ├── img/                  logo, cup, og-image, 6 skin racer
│   ├── css/main.css          CSS chung cho 5 mode pages
│   ├── js/
│   │   ├── app.js            engine chính (5 mode)
│   │   └── protect.js        chống copy source (bypass tự động ở localhost)
│   └── mp3/                  nhạc nền race
├── docs/                     documentation nội bộ
├── build/                    script build cũ (không dùng trong CI hiện tại)
└── .github/workflows/
    └── deploy.yml            GitHub Pages CI
```

## Công nghệ

- **Vanilla HTML/CSS/JavaScript** — không có framework, không build step, không bundler
- **GitHub Pages** — host miễn phí kèm domain tùy chỉnh
- **GitHub Actions** — auto deploy khi push lên `main`
- **Web APIs sử dụng:** Canvas 2D, requestAnimationFrame, Web Speech API, Web Audio API, BroadcastChannel, localStorage, Fullscreen, `<audio>` HTML5

## Chạy local

Yêu cầu: 1 static server (không cần Node, không cần build).

**Cách 1 — VS Code Live Server:**
1. Clone repo
2. Cài extension [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) trong VS Code
3. Chuột phải vào `index.html` → **Open with Live Server**
4. Trình duyệt tự mở `http://127.0.0.1:5500/`

**Cách 2 — Python:**
```bash
cd lucky-wheel
python3 -m http.server 5500
```
Mở [http://127.0.0.1:5500/](http://127.0.0.1:5500/).

**Cách 3 — Node:**
```bash
npx http-server -p 5500
```

Trên `localhost` / `127.0.0.1` layer bảo vệ source tự tắt (`protect.js` có bypass) và popup "CẤM XEM MÃ NGUỒN" sẽ không hiện.

## Deploy

- Push lên `main` → [GitHub Actions](https://github.com/Kintinz/spin-win/actions) tự chạy workflow `.github/workflows/deploy.yml`
- Workflow copy toàn bộ HTML, assets (img/css/js/mp3), CNAME, robots, sitemap sang `_site/` rồi upload GitHub Pages
- Domain tùy chỉnh `spinwin.io.vn` được khai báo qua `CNAME`

## SEO

Mỗi mode page có `<title>`, `<meta description>`, canonical, hreflang, Open Graph, Twitter Card, JSON-LD (`WebApplication`, `BreadcrumbList`, `FAQPage`) riêng.

`sitemap.xml` liệt kê 6 URL clean và có image sitemap; `robots.txt` cho phép `/assets/`, chặn `/build/` `/docs/`.

## Đóng góp

Đây là project cá nhân, không nhận PR public tại thời điểm hiện tại. Nếu bạn tìm thấy bug hoặc muốn góp ý, mở issue trên [GitHub repo](https://github.com/Kintinz/spin-win/issues).

## License

© 2026 Spin &amp; Win. Mã nguồn hiển thị công khai để phục vụ mục đích SEO và tham khảo. Không được sao chép, tái phân phối hoặc bán lại toàn bộ hoặc một phần cho mục đích thương mại mà không có sự đồng ý bằng văn bản.

Công cụ này chỉ dành cho mục đích **giải trí**, **không sử dụng cho cá cược** dưới bất kỳ hình thức nào.
