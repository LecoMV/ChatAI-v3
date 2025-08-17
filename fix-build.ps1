# Fix build errors
Write-Host "Fixing build errors..." -ForegroundColor Cyan

# Fix ChatWidget - remove style jsx and use inline styles
$chatWidgetContent = @'
'use client';

import { useState, useEffect, useRef } from 'react';
import { MessageCircle, X, Send, Minimize2 } from 'lucide-react';

interface Message {
  role: 'user' | 'assistant';
  content: string;
  timestamp?: Date;
}

export default function ChatWidget() {
  const [isOpen, setIsOpen] = useState(false);
  const [isMinimized, setIsMinimized] = useState(false);
  const [messages, setMessages] = useState<Message[]>([
    {
      role: 'assistant',
      content: 'Hi there! 👋 Welcome to Coastal Web. How can I help you grow your business online today?',
      timestamp: new Date()
    }
  ]);
  const [input, setInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim() || isLoading) return;
    
    const userMessage: Message = { 
      role: 'user', 
      content: input,
      timestamp: new Date()
    };
    
    setMessages(prev => [...prev, userMessage]);
    setInput('');
    setIsLoading(true);
    
    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          messages: [...messages, userMessage],
        }),
      });
      
      if (!response.ok) {
        throw new Error('Failed to get response');
      }
      
      const data = await response.json();
      
      setMessages(prev => [...prev, {
        role: 'assistant',
        content: data.message,
        timestamp: new Date()
      }]);
    } catch (error) {
      console.error('Error:', error);
      setMessages(prev => [...prev, {
        role: 'assistant',
        content: 'I apologize, but I\'m having trouble connecting right now. Please try again in a moment or contact us directly at hello@coastalweb.us',
        timestamp: new Date()
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      {!isOpen && (
        <button
          id="chat-widget-button"
          onClick={() => setIsOpen(true)}
          className="fixed bottom-6 right-6 z-50 flex items-center gap-3 px-5 py-3 bg-gradient-to-r from-[#0E8074] to-[#14B8A6] text-white rounded-full shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 group animate-pulse-slow"
          aria-label="Open chat"
        >
          <MessageCircle className="w-6 h-6" />
          <span className="font-medium">Chat with us</span>
          <span className="absolute -top-1 -right-1 w-3 h-3 bg-[#FF6B6B] rounded-full animate-pulse"></span>
        </button>
      )}

      {isOpen && (
        <div
          className={`fixed z-50 transition-all duration-300 ${
            isMinimized 
              ? 'bottom-6 right-6 w-80 h-16' 
              : 'bottom-6 right-6 w-96 h-[600px] max-h-[80vh]'
          }`}
        >
          <div className="flex flex-col h-full bg-white rounded-2xl shadow-2xl border border-[#E5E7EB] overflow-hidden">
            <div className="flex items-center justify-between px-6 py-4 bg-gradient-to-r from-[#0B2E4E] to-[#14B8A6] text-white">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
                  <MessageCircle className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="font-semibold text-lg">Coastal Web</h3>
                  <p className="text-xs text-white/80">We typically reply instantly</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => setIsMinimized(!isMinimized)}
                  className="p-1.5 hover:bg-white/20 rounded-lg transition-colors"
                  aria-label="Minimize chat"
                >
                  <Minimize2 className="w-4 h-4" />
                </button>
                <button
                  onClick={() => setIsOpen(false)}
                  className="p-1.5 hover:bg-white/20 rounded-lg transition-colors"
                  aria-label="Close chat"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            </div>

            {!isMinimized && (
              <>
                <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-[#F8FAFC]">
                  {messages.map((message, index) => (
                    <div
                      key={index}
                      className={`flex ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
                    >
                      <div
                        className={`max-w-[80%] px-4 py-3 rounded-2xl ${
                          message.role === 'user'
                            ? 'bg-gradient-to-r from-[#0E8074] to-[#14B8A6] text-white rounded-br-sm'
                            : 'bg-white text-[#0B1220] border border-[#E5E7EB] rounded-bl-sm shadow-sm'
                        }`}
                      >
                        <p className="text-sm leading-relaxed whitespace-pre-wrap">{message.content}</p>
                        <p className={`text-xs mt-1 ${
                          message.role === 'user' ? 'text-white/70' : 'text-[#64748B]'
                        }`}>
                          {message.timestamp?.toLocaleTimeString('en-US', { 
                            hour: 'numeric', 
                            minute: '2-digit' 
                          })}
                        </p>
                      </div>
                    </div>
                  ))}
                  
                  {isLoading && (
                    <div className="flex justify-start">
                      <div className="bg-white border border-[#E5E7EB] px-4 py-3 rounded-2xl rounded-bl-sm shadow-sm">
                        <div className="flex gap-1.5">
                          <span className="w-2 h-2 bg-[#14B8A6] rounded-full animate-bounce" style={{ animationDelay: '0ms' }}></span>
                          <span className="w-2 h-2 bg-[#14B8A6] rounded-full animate-bounce" style={{ animationDelay: '150ms' }}></span>
                          <span className="w-2 h-2 bg-[#14B8A6] rounded-full animate-bounce" style={{ animationDelay: '300ms' }}></span>
                        </div>
                      </div>
                    </div>
                  )}
                  
                  <div ref={messagesEndRef} />
                </div>

                <div className="px-4 py-2 border-t border-[#E5E7EB] bg-white">
                  <div className="flex gap-2 overflow-x-auto">
                    {['Get a quote', 'SEO help', 'Website design'].map((action) => (
                      <button
                        key={action}
                        onClick={() => setInput(action)}
                        className="px-3 py-1.5 text-xs font-medium text-[#0E8074] bg-[#14B8A6]/10 hover:bg-[#14B8A6]/20 rounded-full whitespace-nowrap transition-colors"
                      >
                        {action}
                      </button>
                    ))}
                  </div>
                </div>

                <form 
                  onSubmit={(e) => {
                    e.preventDefault();
                    handleSend();
                  }}
                  className="p-4 border-t border-[#E5E7EB] bg-white"
                >
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={input}
                      onChange={(e) => setInput(e.target.value)}
                      placeholder="Type your message..."
                      className="flex-1 px-4 py-2.5 text-sm border border-[#E5E7EB] rounded-full focus:outline-none focus:ring-2 focus:ring-[#14B8A6] focus:border-transparent transition-all text-[#0B1220] placeholder-[#64748B]"
                      disabled={isLoading}
                    />
                    <button
                      type="submit"
                      disabled={isLoading || !input.trim()}
                      className="p-2.5 bg-gradient-to-r from-[#0E8074] to-[#14B8A6] text-white rounded-full hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300 hover:scale-105"
                    >
                      <Send className="w-5 h-5" />
                    </button>
                  </div>
                </form>
              </>
            )}
          </div>
        </div>
      )}
    </>
  );
}
'@

Set-Content -Path "src/components/chat/ChatWidget.tsx" -Value $chatWidgetContent -Encoding UTF8
Write-Host "✓ ChatWidget fixed" -ForegroundColor Green

# Add custom animation to globals.css
$globalsContent = Get-Content "src/app/globals.css" -Raw
if ($globalsContent -notmatch "animate-pulse-slow") {
    $animationCSS = @"

/* Custom animations */
@keyframes pulse-slow {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.8; }
}

.animate-pulse-slow {
  animation: pulse-slow 3s ease-in-out infinite;
}
"@
    Add-Content -Path "src/app/globals.css" -Value $animationCSS
    Write-Host "✓ Added animations to globals.css" -ForegroundColor Green
}

Write-Host "`n✅ Build errors fixed!" -ForegroundColor Green
Write-Host "Run: npm run build" -ForegroundColor Yellow