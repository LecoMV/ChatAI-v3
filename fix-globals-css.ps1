# Fix globals.css location issue
Write-Host "Fixing globals.css location..." -ForegroundColor Cyan

# Ensure globals.css exists in src/app/
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

# Create the file in the correct location
Set-Content -Path "src/app/globals.css" -Value $globalsContent -Encoding UTF8
Write-Host "✓ Created src/app/globals.css" -ForegroundColor Green

# Verify file exists
if (Test-Path "src/app/globals.css") {
    Write-Host "✓ File verified at src/app/globals.css" -ForegroundColor Green
} else {
    Write-Host "⚠ File creation failed" -ForegroundColor Red
}

Write-Host "`n✅ Fixed! Run: npm run build" -ForegroundColor Green