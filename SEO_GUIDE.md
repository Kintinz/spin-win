# Hướng dẫn SEO cho Spin & Win

Tài liệu này mô tả trạng thái SEO hiện tại của repo và các bước cần làm khi đưa lên domain thật. URL deploy hiện tại là GitHub Pages `https://kintinz.github.io/lucky-wheel/`.

## Đã triển khai trong repo

### Trang chính `index.html`

- Có `title`, `description`, `canonical`, Open Graph và Twitter Card ổn định.
- Nội dung giới thiệu có thật trong HTML, gồm một `h1`, các `h2`, đoạn mô tả và danh sách tính năng. Nội dung nằm trong vùng người dùng có thể cuộn tới, không dùng text đặt ngoài màn hình hoặc chỉ chèn sau khi tải trang.
- JSON-LD mô tả đây là một `WebApplication`, có tên, mô tả, URL, ngôn ngữ, trạng thái miễn phí và các tính năng khớp với nội dung hiển thị.
- Các URL có `?admin=1`, `?overlay=1` hoặc `?panel=trick` được chuyển sang `noindex, nofollow, noarchive` bằng meta robots trong HTML.
- Không sử dụng `meta keywords`; Google không dùng thẻ này để xếp hạng.

### Trang nội bộ `trick.html`

- Không triển khai SEO content, description, structured data hoặc Open Graph cho trang này.
- Chỉ giữ title nội bộ để nhận diện cửa sổ và `noindex, nofollow, noarchive` để không đưa panel bảo mật vào kết quả tìm kiếm.
- Không có trong sitemap.
- Không chặn bằng `robots.txt`, để bot có thể crawl và nhìn thấy chỉ thị `noindex`.

### `robots.txt` và `sitemap.xml`

- `robots.txt` cho phép crawl và trỏ tới sitemap của GitHub Pages.
- `sitemap.xml` chỉ liệt kê trang chính; các trang nội bộ không được liệt kê.
- Khi đổi domain, phải thay URL trong cả hai file và trong `index.html`.

## SEO Google thường và Google AI Search

Google không yêu cầu một file, thẻ hoặc schema riêng cho AI Overviews/AI Mode. Nền tảng vẫn là SEO thông thường: trang phải có thể crawl, được index, đủ điều kiện xuất hiện trong kết quả tìm kiếm, có nội dung hữu ích và nội dung quan trọng nằm ở dạng text trong DOM. Việc có được trích dẫn trong kết quả AI hay không không được đảm bảo.

Các nguyên tắc cần giữ:

1. Viết title và mô tả ngắn, duy nhất, mô tả đúng chức năng.
2. Đưa thông tin quan trọng vào HTML có thể đọc được; không tạo nội dung chỉ để crawler nhìn thấy.
3. Giữ cấu trúc heading tự nhiên và nội dung khớp với JSON-LD.
4. Dùng liên kết nội bộ thật khi có các trang hướng dẫn, quy định hoặc landing page riêng.
5. Tạo các URL ngôn ngữ riêng (`/vi/`, `/en/` hoặc quy ước tương đương) nếu muốn SEO tiếng Việt và tiếng Anh độc lập; việc đổi text bằng JavaScript trên cùng một URL chưa phải chiến lược multilingual SEO đầy đủ.
6. Theo dõi Search Console sau khi deploy; báo cáo hiệu suất có thể bao gồm lưu lượng từ các tính năng AI khi Google cung cấp dữ liệu.

## Việc cần làm trước khi deploy

### 1. Khi đổi sang domain thật

Nếu chuyển sang domain riêng, thay `https://kintinz.github.io/lucky-wheel/` bằng domain thật tại:

- `index.html`: canonical, `og:url`, `og:image`, `twitter:image` và URL trong JSON-LD.
- `robots.txt`: URL sitemap.
- `sitemap.xml`: URL trang chính.

### 2. Kiểm tra ảnh chia sẻ

Repo giữ `logo-web.jpg` làm ảnh nguồn, có `logo-web-removebg-preview.png` làm logo chính nền trong suốt kích thước 750×333 và `logo-mark.png` làm biểu tượng riêng cho favicon. Metadata Open Graph/Twitter Card đang trỏ tới `logo-web-removebg-preview.png`. Trước khi phát hành chính thức, kiểm tra ảnh trên các nền tảng chia sẻ thực tế; nếu cần ảnh chia sẻ theo tỉ lệ khác, xuất một bản riêng rồi cập nhật `og:image` và `twitter:image`.

### 3. Kiểm tra tài nguyên public

`DEV_SECRETS.md` đang nằm trong thư mục web. Nếu hosting phục vụ toàn bộ thư mục tĩnh, phải loại file này khỏi thư mục public hoặc cấu hình máy chủ để không phục vụ file đó. `robots.txt` không phải biện pháp bảo vệ secret.

### 4. Google Search Console

1. Xác minh domain thật.
2. Gửi `sitemap.xml`.
3. Dùng URL Inspection để kiểm tra trang chính có thể crawl và index.
4. Sau khi có dữ liệu, theo dõi truy vấn, CTR, trang được index và lỗi trải nghiệm.

### 5. Đo hiệu năng

Chạy PageSpeed Insights hoặc Lighthouse trên bản deploy thật. Kết quả local, source hoặc HTTP 200 không thay thế cho kiểm tra trình duyệt và dữ liệu người dùng thực tế.

## Không làm

- Không thêm `aggregateRating`, review hoặc số điểm nếu không có dữ liệu thật.
- Không nhồi các từ khóa liên quan cá cược, cờ bạc, đổi thưởng hoặc dịch vụ mà Spin & Win không cung cấp.
- Không dùng `robots.txt` để thay thế `noindex`.
- Không khẳng định trang chắc chắn xuất hiện trong AI Search; Google không có cam kết hiển thị.

## Ghi chú pháp lý nội dung

Nội dung giới thiệu và policy trên giao diện định vị Spin & Win cho mục đích giải trí và hoạt động hợp pháp. Dòng cảnh báo không thay thế tư vấn pháp lý chuyên nghiệp; người vận hành cần rà soát lại theo domain, quốc gia, mô hình kinh doanh và cách sử dụng thực tế trước khi phát hành.
