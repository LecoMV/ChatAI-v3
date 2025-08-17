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
