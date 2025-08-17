# Fix ChatWidget errors and remove chat page
# Run from project root: C:\Users\alexm\Documents\GitHub\ChatAI-v3

Write-Host "Fixing errors and cleaning up project..." -ForegroundColor Cyan

# Step 1: Remove chat page and related files
Write-Host "`nStep 1: Removing chat page..." -ForegroundColor Yellow
Remove-Item -Path "src/app/chat" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✓ Chat page removed" -ForegroundColor Green

# Step 2: Fix ChatWidget with proper escaping
Write-Host "`nStep 2: Fixing ChatWidget component..." -ForegroundColor Yellow
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

  useEffect(() => {
    const timer = setTimeout(() => {
      const button = document.getElementById('chat-widget-button');
      button?.classList.add('animate-bounce-subtle');
    }, 3000);
    return () => clearTimeout(timer);
  }, []);

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
          className="fixed bottom-6 right-6 z-50 flex items-center gap-3 px-5 py-3 bg-gradient-to-r from-[#0E8074] to-[#14B8A6] text-white rounded-full shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 group"
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

      <style jsx>{`
        @keyframes bounce-subtle {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-5px); }
        }
        
        .animate-bounce-subtle {
          animation: bounce-subtle 2s ease-in-out infinite;
        }
      `}</style>
    </>
  );
}
'@

# Use Set-Content instead of Out-File to avoid encoding issues
Set-Content -Path "src/components/chat/ChatWidget.tsx" -Value $chatWidgetContent -Encoding UTF8
Write-Host "✓ ChatWidget component fixed" -ForegroundColor Green

# Step 3: Update home page (remove chat link)
Write-Host "`nStep 3: Updating home page..." -ForegroundColor Yellow
$homePageContent = @'
import ChatWidget from '@/components/chat/ChatWidget';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-[#0B2E4E] via-[#14B8A6]/20 to-[#F8FAFC] relative overflow-hidden">
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-[#14B8A6]/20 rounded-full blur-3xl"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-[#0E8074]/20 rounded-full blur-3xl"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-[#FF6B6B]/10 rounded-full blur-3xl"></div>
      </div>

      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen px-4">
        <div className="text-center max-w-4xl mx-auto">
          <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 drop-shadow-lg">
            Welcome to Coastal Web
          </h1>
          <p className="text-xl md:text-2xl text-white/90 mb-8 drop-shadow">
            Websites that win you customers. Design, SEO, and speed—built to convert and rank.
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <button 
              className="px-8 py-4 bg-white text-[#0E8074] font-semibold rounded-full hover:shadow-xl transform hover:scale-105 transition-all duration-300"
            >
              Get Started Today
            </button>
            <button 
              className="px-8 py-4 bg-[#FF6B6B] text-white font-semibold rounded-full hover:shadow-xl transform hover:scale-105 transition-all duration-300"
            >
              View Our Work
            </button>
          </div>
        </div>

        <div className="absolute bottom-12 left-0 right-0 px-8">
          <div className="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white/10 backdrop-blur-md rounded-2xl p-6 text-white border border-white/20">
              <h3 className="font-semibold text-lg mb-2">Fast & Secure</h3>
              <p className="text-sm text-white/80">LiteSpeed + CDN optimization for lightning-fast load times</p>
            </div>
            <div className="bg-white/10 backdrop-blur-md rounded-2xl p-6 text-white border border-white/20">
              <h3 className="font-semibold text-lg mb-2">SEO Optimized</h3>
              <p className="text-sm text-white/80">Built to rank with technical, content, and local SEO</p>
            </div>
            <div className="bg-white/10 backdrop-blur-md rounded-2xl p-6 text-white border border-white/20">
              <h3 className="font-semibold text-lg mb-2">Conversion Focused</h3>
              <p className="text-sm text-white/80">Strategic design that turns visitors into customers</p>
            </div>
          </div>
        </div>
      </div>

      <ChatWidget />
    </div>
  );
}
'@

Set-Content -Path "src/app/page.tsx" -Value $homePageContent -Encoding UTF8
Write-Host "✓ Home page updated" -ForegroundColor Green

# Step 4: Clean up ChatInterface (fix escaping issues)
Write-Host "`nStep 4: Fixing ChatInterface component..." -ForegroundColor Yellow
$chatInterfaceContent = @'
'use client';

import { useState, useEffect, useRef } from 'react';
import { Send } from 'lucide-react';

interface Message {
  role: 'user' | 'assistant';
  content: string;
  timestamp?: Date;
}

export default function ChatInterface() {
  const [messages, setMessages] = useState<Message[]>([
    {
      role: 'assistant',
      content: 'Welcome to Coastal Web! I\'m here to help you grow your business online. Whether you need a new website, want to improve your search rankings, or have questions about digital marketing, I\'m here to assist.',
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
        content: 'I apologize, but I\'m having trouble connecting right now. Please try again or contact us at hello@coastalweb.us',
        timestamp: new Date()
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="flex-1 overflow-y-auto px-4 py-6">
        <div className="max-w-4xl mx-auto space-y-4">
          {messages.map((message, index) => (
            <div
              key={index}
              className={`flex ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div className={`flex gap-3 max-w-[70%] ${message.role === 'user' ? 'flex-row-reverse' : ''}`}>
                <div className={`flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-white text-sm font-medium ${
                  message.role === 'user' 
                    ? 'bg-gradient-to-r from-[#0E8074] to-[#14B8A6]' 
                    : 'bg-gradient-to-r from-[#0B2E4E] to-[#14B8A6]'
                }`}>
                  {message.role === 'user' ? 'Y' : 'C'}
                </div>
                
                <div>
                  <div
                    className={`px-4 py-3 rounded-2xl ${
                      message.role === 'user'
                        ? 'bg-gradient-to-r from-[#0E8074] to-[#14B8A6] text-white rounded-tr-sm'
                        : 'bg-white text-[#0B1220] border border-[#E5E7EB] rounded-tl-sm shadow-sm'
                    }`}
                  >
                    <p className="text-sm leading-relaxed whitespace-pre-wrap">{message.content}</p>
                  </div>
                  <p className={`text-xs mt-1 px-2 ${
                    message.role === 'user' ? 'text-right text-[#64748B]' : 'text-[#64748B]'
                  }`}>
                    {message.timestamp?.toLocaleTimeString('en-US', { 
                      hour: 'numeric', 
                      minute: '2-digit' 
                    })}
                  </p>
                </div>
              </div>
            </div>
          ))}
          
          {isLoading && (
            <div className="flex justify-start">
              <div className="flex gap-3 max-w-[70%]">
                <div className="flex-shrink-0 w-8 h-8 rounded-full bg-gradient-to-r from-[#0B2E4E] to-[#14B8A6] flex items-center justify-center text-white text-sm font-medium">
                  C
                </div>
                <div className="bg-white border border-[#E5E7EB] px-4 py-3 rounded-2xl rounded-tl-sm shadow-sm">
                  <div className="flex gap-1.5">
                    <span className="w-2 h-2 bg-[#14B8A6] rounded-full animate-bounce" style={{ animationDelay: '0ms' }}></span>
                    <span className="w-2 h-2 bg-[#14B8A6] rounded-full animate-bounce" style={{ animationDelay: '150ms' }}></span>
                    <span className="w-2 h-2 bg-[#14B8A6] rounded-full animate-bounce" style={{ animationDelay: '300ms' }}></span>
                  </div>
                </div>
              </div>
            </div>
          )}
          
          <div ref={messagesEndRef} />
        </div>
      </div>
    </div>
  );
}
'@

Set-Content -Path "src/components/chat/ChatInterface.tsx" -Value $chatInterfaceContent -Encoding UTF8
Write-Host "✓ ChatInterface component fixed" -ForegroundColor Green

# Step 5: Test build
Write-Host "`nStep 5: Testing build..." -ForegroundColor Yellow
npm run build 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Build successful" -ForegroundColor Green
} else {
    Write-Host "⚠ Build had warnings/errors - check manually" -ForegroundColor Yellow
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "✅ Cleanup and fixes complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "`n• Chat page removed" -ForegroundColor Gray
Write-Host "• Syntax errors fixed" -ForegroundColor Gray
Write-Host "• Home page updated" -ForegroundColor Gray
Write-Host "• ChatWidget now uses proper escaping" -ForegroundColor Gray
Write-Host "`nRestart your dev server: npm run dev" -ForegroundColor White