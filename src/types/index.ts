export interface User {
  id: string;
  email: string;
  name?: string;
  createdAt: Date;
}

export interface Chat {
  id: string;
  userId: string;
  messages: Message[];
  createdAt: Date;
}

export interface Message {
  id: string;
  chatId: string;
  role: 'user' | 'assistant' | 'system';
  content: string;
  createdAt: Date;
}

export interface ChatbotConfig {
  name: string;
  welcomeMessage: string;
  primaryColor: string;
  personality: 'professional' | 'friendly' | 'casual';
  language: 'en' | 'es' | 'pt';
}