// setup-project.js
// Run with: node setup-project.js

const fs = require('fs');
const path = require('path');

// Define the project structure
const projectStructure = {
  'src': {
    'app': {
      'api': {
        'chat': {
          'route.ts': `import { NextRequest, NextResponse } from 'next/server';
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function POST(req: NextRequest) {
  try {
    const { messages } = await req.json();

    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages,
      temperature: 0.7,
    });

    return NextResponse.json({
      message: completion.choices[0].message.content,
    });
  } catch (error) {
    console.error('Chat API Error:', error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}`
        },
        'webhook': {},
        'admin': {}
      },
      'admin': {
        'page.tsx': `export default function AdminDashboard() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold text-coastal-navy">Admin Dashboard</h1>
      <p className="mt-4 text-gray-600">Manage your chatbot settings and analytics here.</p>
    </div>
  );
}`
      },
      'chat': {
        'page.tsx': `'use client';

import { useState } from 'react';
import ChatInterface from '@/components/chat/ChatInterface';

export default function ChatPage() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-coastal-blue/10 to-white">
      <ChatInterface />
    </div>
  );
}`
      },
      'layout.tsx': `import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import '@/styles/globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Coastal Web AI Assistant',
  description: 'AI-powered customer support for Coastal Web',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  );
}`,
      'page.tsx': `import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="min-h-screen bg-gradient-to-b from-coastal-blue to-coastal-navy">
      <div className="container mx-auto px-4 py-16">
        <h1 className="text-5xl font-bold text-white mb-6">
          Coastal Web AI Assistant
        </h1>
        <p className="text-xl text-white/90 mb-8">
          Intelligent customer support powered by OpenAI
        </p>
        <div className="space-x-4">
          <Link 
            href="/chat" 
            className="inline-block bg-coastal-teal text-white px-6 py-3 rounded-lg hover:bg-coastal-teal/90 transition"
          >
            Start Chat
          </Link>
          <Link 
            href="/admin" 
            className="inline-block bg-white text-coastal-navy px-6 py-3 rounded-lg hover:bg-gray-100 transition"
          >
            Admin Dashboard
          </Link>
        </div>
      </div>
    </main>
  );
}`
    },
    'components': {
      'chat': {
        'ChatInterface.tsx': `'use client';

import { useState } from 'react';
import MessageList from './MessageList';
import MessageInput from './MessageInput';

export default function ChatInterface() {
  const [messages, setMessages] = useState([
    { role: 'assistant', content: 'Hello! How can I help you with your website needs today?' }
  ]);

  const sendMessage = async (content: string) => {
    // Add user message
    setMessages(prev => [...prev, { role: 'user', content }]);
    
    // TODO: Send to API and get response
    // For now, just echo back
    setTimeout(() => {
      setMessages(prev => [...prev, { 
        role: 'assistant', 
        content: \`You said: "\${content}". I'm here to help with web development and SEO!\` 
      }]);
    }, 1000);
  };

  return (
    <div className="max-w-4xl mx-auto p-4">
      <div className="bg-white rounded-lg shadow-lg h-[600px] flex flex-col">
        <div className="bg-coastal-navy text-white p-4 rounded-t-lg">
          <h2 className="text-xl font-semibold">Coastal Web Assistant</h2>
        </div>
        <MessageList messages={messages} />
        <MessageInput onSend={sendMessage} />
      </div>
    </div>
  );
}`,
        'MessageList.tsx': `interface Message {
  role: 'user' | 'assistant';
  content: string;
}

interface MessageListProps {
  messages: Message[];
}

export default function MessageList({ messages }: MessageListProps) {
  return (
    <div className="flex-1 overflow-y-auto p-4 space-y-4">
      {messages.map((message, index) => (
        <div
          key={index}
          className={\`flex \${message.role === 'user' ? 'justify-end' : 'justify-start'}\`}
        >
          <div
            className={\`max-w-[70%] p-3 rounded-lg \${
              message.role === 'user'
                ? 'bg-coastal-teal text-white'
                : 'bg-gray-100 text-gray-800'
            }\`}
          >
            {message.content}
          </div>
        </div>
      ))}
    </div>
  );
}`,
        'MessageInput.tsx': `'use client';

import { useState } from 'react';

interface MessageInputProps {
  onSend: (message: string) => void;
}

export default function MessageInput({ onSend }: MessageInputProps) {
  const [input, setInput] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (input.trim()) {
      onSend(input);
      setInput('');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="p-4 border-t">
      <div className="flex space-x-2">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Type your message..."
          className="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-coastal-teal"
        />
        <button
          type="submit"
          className="px-6 py-2 bg-coastal-teal text-white rounded-lg hover:bg-coastal-teal/90 transition"
        >
          Send
        </button>
      </div>
    </form>
  );
}`
      },
      'ui': {
        'Button.tsx': `import { ReactNode } from 'react';

interface ButtonProps {
  children: ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary';
  className?: string;
}

export default function Button({ 
  children, 
  onClick, 
  variant = 'primary',
  className = ''
}: ButtonProps) {
  const baseStyles = 'px-4 py-2 rounded-lg transition font-medium';
  const variants = {
    primary: 'bg-coastal-teal text-white hover:bg-coastal-teal/90',
    secondary: 'bg-white text-coastal-navy border border-coastal-navy hover:bg-gray-50'
  };

  return (
    <button
      onClick={onClick}
      className={\`\${baseStyles} \${variants[variant]} \${className}\`}
    >
      {children}
    </button>
  );
}`,
        'Card.tsx': `import { ReactNode } from 'react';

interface CardProps {
  children: ReactNode;
  className?: string;
}

export default function Card({ children, className = '' }: CardProps) {
  return (
    <div className={\`bg-white rounded-lg shadow-md p-6 \${className}\`}>
      {children}
    </div>
  );
}`
      },
      'admin': {
        'Dashboard.tsx': `export default function Dashboard() {
  return (
    <div>
      <h2 className="text-2xl font-bold mb-4">Dashboard Overview</h2>
      {/* Add dashboard content here */}
    </div>
  );
}`,
        'Settings.tsx': `export default function Settings() {
  return (
    <div>
      <h2 className="text-2xl font-bold mb-4">Chatbot Settings</h2>
      {/* Add settings form here */}
    </div>
  );
}`
      }
    },
    'lib': {
      'openai.ts': `import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export default openai;

export async function getChatCompletion(messages: any[]) {
  try {
    const completion = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages,
      temperature: 0.7,
      max_tokens: 500,
    });

    return completion.choices[0].message.content;
  } catch (error) {
    console.error('OpenAI API Error:', error);
    throw error;
  }
}`,
      'db.ts': `import { PrismaClient } from '@prisma/client';

declare global {
  var prisma: PrismaClient | undefined;
}

const prisma = global.prisma || new PrismaClient();

if (process.env.NODE_ENV !== 'production') {
  global.prisma = prisma;
}

export default prisma;`,
      'utils.ts': `import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  }).format(date);
}

export function truncateText(text: string, maxLength: number): string {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}`
    },
    'hooks': {
      'useChat.ts': `import { useState, useCallback } from 'react';

export function useChat() {
  const [messages, setMessages] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  const sendMessage = useCallback(async (content: string) => {
    setIsLoading(true);
    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ messages: [...messages, { role: 'user', content }] }),
      });
      
      const data = await response.json();
      setMessages(prev => [...prev, { role: 'assistant', content: data.message }]);
    } catch (error) {
      console.error('Chat error:', error);
    } finally {
      setIsLoading(false);
    }
  }, [messages]);

  return { messages, sendMessage, isLoading };
}`,
      'useLocalStorage.ts': `import { useState, useEffect } from 'react';

export function useLocalStorage<T>(key: string, initialValue: T) {
  const [storedValue, setStoredValue] = useState<T>(initialValue);

  useEffect(() => {
    try {
      const item = window.localStorage.getItem(key);
      if (item) {
        setStoredValue(JSON.parse(item));
      }
    } catch (error) {
      console.error(\`Error loading \${key} from localStorage:\`, error);
    }
  }, [key]);

  const setValue = (value: T | ((val: T) => T)) => {
    try {
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error(\`Error saving \${key} to localStorage:\`, error);
    }
  };

  return [storedValue, setValue] as const;
}`
    },
    'types': {
      'index.ts': `export interface User {
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
}`
    },
    'styles': {
      'globals.css': `@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --coastal-blue: #2563eb;
    --coastal-navy: #1e40af;
    --coastal-teal: #0ea5e9;
  }

  body {
    @apply antialiased;
  }
}

@layer components {
  .chat-container {
    @apply max-w-4xl mx-auto p-4;
  }

  .message-bubble {
    @apply px-4 py-2 rounded-lg max-w-[70%];
  }
}

/* Custom scrollbar */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  @apply bg-gray-100;
}

::-webkit-scrollbar-thumb {
  @apply bg-gray-400 rounded-full;
}

::-webkit-scrollbar-thumb:hover {
  @apply bg-gray-500;
}`
    }
  },
  'prisma': {
    'schema.prisma': `generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(uuid())
  email     String   @unique
  name      String?
  role      String   @default("user")
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  chats     Chat[]
}

model Chat {
  id        String    @id @default(uuid())
  userId    String
  user      User      @relation(fields: [userId], references: [id])
  title     String?
  messages  Message[]
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt
}

model Message {
  id        String   @id @default(uuid())
  chatId    String
  chat      Chat     @relation(fields: [chatId], references: [id])
  role      String   // 'user' or 'assistant' or 'system'
  content   String   @db.Text
  createdAt DateTime @default(now())
}

model ChatbotConfig {
  id              String   @id @default(uuid())
  name            String
  welcomeMessage  String   @db.Text
  personality     String
  primaryColor    String
  language        String   @default("en")
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
}`
  },
  'public': {
    'robots.txt': `User-agent: *
Allow: /

Sitemap: http://localhost:3000/sitemap.xml`
  }
};

// Helper function to create directories and files
function createStructure(basePath, structure) {
  Object.entries(structure).forEach(([name, content]) => {
    const fullPath = path.join(basePath, name);
    
    if (typeof content === 'object' && content !== null && !content.hasOwnProperty('content')) {
      // It's a directory
      if (!fs.existsSync(fullPath)) {
        fs.mkdirSync(fullPath, { recursive: true });
        console.log(`✅ Created directory: ${fullPath}`);
      }
      // Recursively create subdirectories and files
      createStructure(fullPath, content);
    } else if (typeof content === 'string') {
      // It's a file
      if (!fs.existsSync(fullPath)) {
        fs.writeFileSync(fullPath, content);
        console.log(`✅ Created file: ${fullPath}`);
      } else {
        console.log(`⚠️  File already exists: ${fullPath}`);
      }
    }
  });
}

// Create root config files
const rootFiles = {
  '.env.local': `# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Database Configuration
DATABASE_URL="postgresql://postgres:password@localhost:5432/chatai_v3"

# Authentication (Clerk)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=

# App Configuration
NEXT_PUBLIC_APP_URL=http://localhost:3000
NODE_ENV=development

# WebSocket Configuration
NEXT_PUBLIC_SOCKET_URL=http://localhost:3001`,
  
  '.gitignore': `# Dependencies
node_modules/
.pnp
.pnp.js

# Testing
coverage/

# Next.js
.next/
out/
build/
dist/

# Production
build/

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Vercel
.vercel

# TypeScript
*.tsbuildinfo

# IDE
.vscode/
.idea/

# Database
prisma/migrations/
*.db
*.db-journal`,

  'tsconfig.json': `{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}`,

  'next.config.js': `/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    serverActions: true,
  },
}

module.exports = nextConfig`,

  'tailwind.config.js': `/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'coastal-blue': '#2563eb',
        'coastal-navy': '#1e40af',
        'coastal-teal': '#0ea5e9',
        'coastal-orange': '#f97316',
        'coastal-green': '#10b981',
      },
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic': 'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
      },
    },
  },
  plugins: [],
}`,

  'postcss.config.js': `module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}`,

  '.eslintrc.json': `{
  "extends": "next/core-web-vitals"
}`,

  '.prettierrc': `{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "tabWidth": 2,
  "useTabs": false
}`
};

// Main execution
console.log('🚀 Setting up ChatAI-v3 project structure...\n');

// Create main structure
createStructure('.', projectStructure);

// Create root config files
Object.entries(rootFiles).forEach(([filename, content]) => {
  if (!fs.existsSync(filename)) {
    fs.writeFileSync(filename, content);
    console.log(`✅ Created config file: ${filename}`);
  } else {
    console.log(`⚠️  Config file already exists: ${filename}`);
  }
});

console.log('\n✨ Project structure created successfully!');
console.log('\n📝 Next steps:');
console.log('1. Run: npm install');
console.log('2. Update .env.local with your actual API keys');
console.log('3. Run: npm run dev');
console.log('\n🔐 IMPORTANT: Generate a new OpenAI API key since the previous one was exposed!');
