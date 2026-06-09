# H&M SportShoes — README

## 1) Mục tiêu dự án
Website bán giày (demo) với các chức năng:
- Trang **Home / Sản phẩm**: lọc – tìm kiếm – sắp xếp – phân trang
- **Giỏ hàng** và **Yêu thích**: lưu theo **session** (reload trang không mất)
- **Ưu đãi / giảm giá** hiển thị trên sản phẩm
- **Banner**: thay đổi banner hiển thị
- **Thanh toán**: checkout → popup “Thanh toán thành công”
- **Quan trọng**: dữ liệu giày lấy từ **database** (không hardcode link)

---

## 2) Những việc cần làm (Checklist)

### 2.1 Trang Home / Danh sách sản phẩm
- [ ] Hiển thị danh sách sản phẩm từ DB/API
- [ ] Tìm kiếm theo tên sản phẩm
- [ ] Lọc theo hãng (Nike/Adidas/Puma/…)
- [ ] Lọc theo size
- [ ] Lọc theo khoảng giá (min/max)
- [ ] Lọc theo màu sắc
- [ ] Nút **Xóa tất cả** để reset filter
- [ ] Sắp xếp (mặc định / giá tăng / giá giảm / mới nhất)
- [ ] Phân trang (giữ nguyên filter/search/sort khi đổi trang)
- [ ] Hiển thị ưu đãi:
    - [ ] Badge `-xx%` khi có giảm
    - [ ] Giá mới + giá cũ gạch ngang khi có giảm

---

### 2.2 Trang chi tiết sản phẩm
- [ ] Hiển thị thông tin sản phẩm từ DB/API (tên, thương hiệu, kho, giá)
- [ ] Hiển thị ưu đãi giống trang home (badge, giá cũ/gía mới)
- [ ] Gallery ảnh: thumbnail → đổi ảnh chính
- [ ] Chọn màu sắc
- [ ] Chọn kích thước (size)
- [ ] Chọn số lượng (+/-)
- [ ] Nút **Thêm giỏ** (lưu session, tăng badge)
- [ ] Nút **Mua ngay** (đi tới checkout)
- [ ] Nút **Yêu thích** (lưu session, tăng badge)
- [ ] Hiển thị mô tả sản phẩm

---

### 2.3 Giỏ hàng (Cart)
- [ ] Thêm vào giỏ từ Home/Detail
- [ ] Nếu sản phẩm đã có trong giỏ → +1 số lượng
- [ ] Badge giỏ hàng hiển thị tổng quantity
- [ ] Lưu giỏ hàng bằng `sessionStorage` (reload không mất)
    - Key: `cart_items`

---

### 2.4 Yêu thích (Wishlist)
- [ ] Toggle yêu thích (add/remove)
- [ ] Badge yêu thích hiển thị số lượng
- [ ] Lưu wishlist bằng `sessionStorage` (reload không mất)
    - Key: `wishlist_items`

---

### 2.5 Banner
- [ ] Hiển thị banner (slider)
- [ ] Thay đổi banner (lấy từ DB hoặc cấu hình)

---

### 2.6 Thanh toán (Checkout)
- [ ] Trang checkout hiển thị danh sách sản phẩm trong giỏ + tổng tiền
- [ ] Form thông tin khách hàng
- [ ] Nhấn thanh toán → hiện popup “Thanh toán thành công”
- [ ] (Tuỳ chọn) Clear cart sau khi thanh toán thành công