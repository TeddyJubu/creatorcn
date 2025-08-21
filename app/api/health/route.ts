import { NextResponse } from 'next/server';

export async function GET() {
  try {
    // Basic health check - could be extended to check database connectivity
    return NextResponse.json(
      { 
        status: 'ok',
        timestamp: new Date().toISOString(),
        version: process.env.npm_package_version || '0.1.0'
      },
      { status: 200 }
    );
  } catch (_error) {
    return NextResponse.json(
      { 
        status: 'error',
        timestamp: new Date().toISOString(),
        error: 'Health check failed'
      },
      { status: 500 }
    );
  }
}