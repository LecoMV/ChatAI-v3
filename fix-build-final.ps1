# Fix final build errors
Write-Host "Fixing build errors..." -ForegroundColor Cyan

# Fix 1: Remove border-border class from globals.css
Write-Host "Fixing globals.css..." -ForegroundColor Yellow
$globalsContent = @'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  * {
    box-sizing: border-box;
    padding: 0;
    margin: 0;
  }
  
  body {
    background: #F8FAFC;
    color: #0B1220;
  }
  
  html {
    scroll-behavior: smooth;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
}

/* Custom animations */
@keyframes pulse-slow {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.8; }
}

.animate-pulse-slow {
  animation: pulse-slow 3s ease-in-out infinite;
}
'@

Set-Content -Path "src/app/globals.css" -Value $globalsContent -Encoding UTF8
Write-Host "✓ globals.css fixed" -ForegroundColor Green

# Fix 2: Fix API route TypeScript error
Write-Host "Fixing API route..." -ForegroundColor Yellow
$apiRouteContent = @'
import { NextRequest, NextResponse } from 'next/server';
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function POST(req: NextRequest) {
  try {
    const { messages } = await req.json();

    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `You are a helpful assistant for Coastal Web, a web design and SEO company. 
          Help users with questions about web design, SEO, digital marketing, and growing their business online.
          Be professional but friendly. Keep responses concise and actionable.`
        },
        ...messages
      ],
      temperature: 0.7,
      max_tokens: 500,
    });

    const responseMessage = completion.choices[0]?.message?.content || 'I apologize, but I could not generate a response.';

    return NextResponse.json({
      message: responseMessage
    });
  } catch (error) {
    console.error('OpenAI error:', error);
    return NextResponse.json(
      { error: 'Failed to get response from AI' },
      { status: 500 }
    );
  }
}
'@

Set-Content -Path "src/app/api/chat/route.ts" -Value $apiRouteContent -Encoding UTF8
Write-Host "✓ API route fixed" -ForegroundColor Green

Write-Host "`n✅ All build errors fixed!" -ForegroundColor Green
Write-Host "Run: npm run build" -ForegroundColor Yellow