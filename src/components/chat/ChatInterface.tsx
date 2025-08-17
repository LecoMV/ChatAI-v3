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
