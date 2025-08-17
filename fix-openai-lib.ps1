# Fix openai.ts type error
Write-Host "Fixing openai.ts..." -ForegroundColor Cyan

$openaiContent = @'
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function getChatResponse(messages: any[]) {
  try {
    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: 'You are a helpful assistant for Coastal Web, a web design and SEO company.'
        },
        ...messages
      ],
    });

    return completion.choices[0]?.message?.content || 'I apologize, but I could not generate a response.';
  } catch (error) {
    console.error('OpenAI API Error:', error);
    throw error;
  }
}
'@

Set-Content -Path "src/lib/openai.ts" -Value $openaiContent -Encoding UTF8
Write-Host "✓ Fixed openai.ts" -ForegroundColor Green

Write-Host "`nRun: npm run build" -ForegroundColor Yellow