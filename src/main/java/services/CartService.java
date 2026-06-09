package services;

import DTO.ProductDTO;
import dao.CartDao;
import dao.Product.ProductVariantDao;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import model.user.CartRow;
import model.user.User;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CartService {

    private final ProductService productService = new ProductService();
    private final PromotionService promotionService = new PromotionService();
    private final ProductVariantDao variantDao = new ProductVariantDao();
    private final CartDao cartDao = new CartDao();

    // ─────────────────────────────────────────────
    // CORE: Thêm sản phẩm vào giỏ
    // ─────────────────────────────────────────────

    /**
     * Thêm sản phẩm vào giỏ hàng.
     * - Nếu user đã đăng nhập → ghi vào DB trước, rồi sync lại session
     * - Nếu chưa đăng nhập → chỉ lưu vào session
     */
    public void addToCart(HttpSession session, int productId, int colorId, int sizeId, int qty) {
        User user = (User) session.getAttribute("currentUser");

        if (user != null) {
            // Ghi vào DB (cộng dồn nếu đã có)
            cartDao.upsertItem(user.getId(), productId, colorId, sizeId, qty);
            // Reload từ DB → đồng bộ session
            Map<String, CartItem> cart = loadCartFromDB(user.getId());
            session.setAttribute("cart", cart);
        } else {
            // Chưa login → lưu session tạm
            Map<String, CartItem> cart = getOrCreateSessionCart(session);
            String key = productId + "-" + colorId + "-" + sizeId;
            if (cart.containsKey(key)) {
                cart.get(key).setQuantity(cart.get(key).getQuantity() + qty);
            } else {
                cart.put(key, buildCartItem(productId, colorId, sizeId, qty));
            }
            session.setAttribute("cart", cart);
        }
    }

    // ─────────────────────────────────────────────
    // Cập nhật số lượng (+/-)
    // ─────────────────────────────────────────────

    /**
     * Tăng/giảm quantity trong giỏ.
     * key format: "productId-colorId-sizeId"
     */
    public void updateQuantity(HttpSession session, String key, String action) {
        User user = (User) session.getAttribute("currentUser");
        Map<String, CartItem> cart = getOrCreateSessionCart(session);

        CartItem item = cart.get(key);
        if (item == null) return;

        int newQty = item.getQuantity();
        if ("plus".equals(action)) {
            newQty++;
        } else if ("minus".equals(action) && newQty > 1) {
            newQty--;
        }
        item.setQuantity(newQty);
        session.setAttribute("cart", cart);

        if (user != null) {
            cartDao.updateQuantity(user.getId(),
                    item.getProductId(), item.getColorId(), item.getSizeId(), newQty);
        }
    }

    // ─────────────────────────────────────────────
    // Xóa 1 item khỏi giỏ
    // ─────────────────────────────────────────────

    public void removeFromCart(HttpSession session, String key) {
        User user = (User) session.getAttribute("currentUser");
        Map<String, CartItem> cart = getOrCreateSessionCart(session);

        CartItem item = cart.remove(key);
        session.setAttribute("cart", cart);

        if (user != null && item != null) {
            cartDao.removeItem(user.getId(),
                    item.getProductId(), item.getColorId(), item.getSizeId());
        }
    }

    // ─────────────────────────────────────────────
    // Load cart từ DB → trả về Map<key, CartItem>
    // ─────────────────────────────────────────────

    public Map<String, CartItem> loadCartFromDB(int userId) {
        List<CartRow> rows = cartDao.findByUser(userId);
        Map<String, CartItem> cart = new LinkedHashMap<>();
        for (CartRow row : rows) {
            String key = row.getProduct_id() + "-" + row.getColor_id() + "-" + row.getSize_id();
            CartItem item = buildCartItem(row.getProduct_id(), row.getColor_id(), row.getSize_id(), row.getQuantity());
            cart.put(key, item);
        }
        return cart;
    }

    // ─────────────────────────────────────────────
    // Merge session cart → DB (gọi khi login)
    // ─────────────────────────────────────────────

    /**
     * Khi user login:
     * 1. Lấy session cart (giỏ hàng chưa login)
     * 2. Merge từng item vào DB (cộng dồn qty nếu trùng key)
     * 3. Load lại từ DB → cập nhật session
     */
    public void mergeSessionCartToDB(HttpSession session, int userId) {
        @SuppressWarnings("unchecked")
        Map<String, CartItem> sessionCart =
                (Map<String, CartItem>) session.getAttribute("cart");

        if (sessionCart != null && !sessionCart.isEmpty()) {
            for (CartItem item : sessionCart.values()) {
                cartDao.mergeItem(userId,
                        item.getProductId(),
                        item.getColorId(),
                        item.getSizeId(),
                        item.getQuantity());
            }
        }

        // Reload từ DB (đã merge xong)
        Map<String, CartItem> updatedCart = loadCartFromDB(userId);
        session.setAttribute("cart", updatedCart);
    }

    // ─────────────────────────────────────────────
    // Xóa toàn bộ giỏ sau checkout
    // ─────────────────────────────────────────────

    public void clearCart(HttpSession session, int userId) {
        cartDao.clearCart(userId);
        session.removeAttribute("cart");
    }

    // ─────────────────────────────────────────────
    // Tính tổng tiền giỏ hàng
    // ─────────────────────────────────────────────

    public BigDecimal calculateTotal(Map<String, CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        if (cart == null) return total;
        for (CartItem item : cart.values()) {
            BigDecimal price = promotionService.parsePrice(item.getFinalPrice());
            total = total.add(price.multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        return total;
    }

    // ─────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────

    public CartItem buildCartItem(int productId, int colorId, int sizeId, int qty) {
        ProductDTO product = productService.getProductById(productId);
        PromotionResult promo = promotionService.calculateBestPromotion(productId);

        CartItem item = new CartItem();
        item.setProductId(productId);
        item.setColorId(colorId);
        item.setSizeId(sizeId);

        item.setName(product.getName());
        item.setImage(product.getMainImageUrl());

        item.setColorName(variantDao.getColorName(colorId));
        item.setSizeName(variantDao.getSizeName(sizeId));

        item.setOriginalPrice(product.getPrice());
        item.setFinalPrice(promotionService.formatVND(promo.getFinalPrice()));
        item.setDiscountValue(promotionService.getDiscountValueString(promo.getBestPromotion()));

        item.setQuantity(qty);
        return item;
    }

    @SuppressWarnings("unchecked")
    private Map<String, CartItem> getOrCreateSessionCart(HttpSession session) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
