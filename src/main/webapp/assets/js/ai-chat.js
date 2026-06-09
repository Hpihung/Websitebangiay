(function() {
    let ctx = window.ctx || '';

    function initChat() {
        const launcher = document.querySelector('.ai-chat-launcher');
        const chatWindow = document.querySelector('.ai-chat-window');
        const input = document.querySelector('.ai-chat-input');
        const sendBtn = document.querySelector('.ai-send-btn');
        const messagesContainer = document.querySelector('.ai-chat-messages');

        if (!launcher || !chatWindow) return;

        launcher.addEventListener('click', () => {
            chatWindow.classList.toggle('active');
            if (chatWindow.classList.contains('active') && messagesContainer.children.length === 0) {
                sendBotMessage("Xin chào! Tôi là Trợ lý ảo H&M. Tôi có thể giúp gì cho bạn hôm nay?", [
                    "Tư vấn chọn size",
                    "Gợi ý sản phẩm hot",
                    "Kiểm tra còn hàng",
                    "Địa chỉ shop"
                ]);
            }
        });

        let typingIndicator = null;

        function showTypingIndicator() {
            if (typingIndicator) return;
            typingIndicator = document.createElement('div');
            typingIndicator.className = 'ai-typing';
            typingIndicator.innerHTML = '<span></span><span></span><span></span>';
            messagesContainer.appendChild(typingIndicator);
            scrollToBottom();
        }

        function hideTypingIndicator() {
            if (typingIndicator) {
                typingIndicator.remove();
                typingIndicator = null;
            }
        }

        function sendMessage(text) {
            const msg = text || input.value.trim();
            if (!msg) return;

            addUserMessage(msg);
            input.value = '';
            
            showTypingIndicator();

            const formData = new URLSearchParams();
            formData.append('message', msg);

            fetch(ctx + '/ai-chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(res => {
                if (!res.ok) throw new Error('Status: ' + res.status);
                return res.json();
            })
            .then(data => {
                hideTypingIndicator();
                sendBotMessage(data.reply, data.suggestions, data.products);
            })
            .catch(err => {
                hideTypingIndicator();
                console.error('Chat Error:', err);
                sendBotMessage("Kết nối gián đoạn (" + err.message + "). Bạn vui lòng thử lại sau nhé!");
            });
        }

        window.handleQuickReply = function(text) {
            sendMessage(text);
        };

        sendBtn.addEventListener('click', () => sendMessage());
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMessage();
        });

        function addUserMessage(text) {
            const div = document.createElement('div');
            div.className = 'message user-msg';
            div.innerText = text;
            messagesContainer.appendChild(div);
            scrollToBottom();
        }

        function sendBotMessage(text, suggestions = [], products = []) {
            const msgDiv = document.createElement('div');
            msgDiv.className = 'message bot-msg';
            if (products && products.length > 0) {
                msgDiv.classList.add('has-products');
            }
            
            let content = `<div class="text">${text}</div>`;
            
            if (products && products.length > 0) {
                content += `<div class="ai-products-list">`;
                products.forEach(p => {
                    content += `
                        <a href="${ctx}/product?id=${p.id}" class="ai-product-card">
                            <img src="${p.image}" alt="${p.name}">
                            <div class="ai-product-info">
                                <span class="ai-product-name">${p.name}</span>
                                <span class="ai-product-price">${p.price}₫</span>
                            </div>
                            <div class="ai-product-action">
                                <i class="fa-solid fa-chevron-right"></i>
                            </div>
                        </a>
                    `;
                });
                content += `</div>`;
            }

            if (suggestions && suggestions.length > 0) {
                content += `<div class="quick-replies" style="margin-top:10px; display:flex; flex-wrap:wrap; gap:5px;">`;
                suggestions.forEach(s => {
                    content += `<button class="quick-reply-btn" onclick="handleQuickReply('${s}')" style="cursor:pointer; padding:6px 12px; border:1px solid #6C5DD3; border-radius:15px; background:white; color:#6C5DD3; font-size:12px;">${s}</button>`;
                });
                content += `</div>`;
            }

            msgDiv.innerHTML = content;
            messagesContainer.appendChild(msgDiv);
            scrollToBottom();
        }

        function scrollToBottom() {
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initChat);
    } else {
        initChat();
    }
})();
