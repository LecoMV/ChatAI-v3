# Fix TypeScript CSS import error
Write-Host "Fixing CSS TypeScript error..." -ForegroundColor Cyan

# Create globals.css
$globalsCSS = @'
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html {
  scroll-behavior: smooth;
}

@keyframes pulse-slow {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.8; }
}

.animate-pulse-slow {
  animation: pulse-slow 3s ease-in-out infinite;
}
'@

New-Item -Path "src/app/globals.css" -ItemType File -Force | Out-Null
[System.IO.File]::WriteAllText("$PWD\src\app\globals.css", $globalsCSS)
Write-Host "✓ Created globals.css" -ForegroundColor Green

# Create CSS module declaration
$cssDeclaration = @'
declare module '*.css' {
  const content: { [className: string]: string };
  export default content;
}
'@

[System.IO.File]::WriteAllText("$PWD\src\app\globals.d.ts", $cssDeclaration)
Write-Host "✓ Created globals.d.ts" -ForegroundColor Green

# Verify files
if ((Test-Path "src/app/globals.css") -and (Test-Path "src/app/globals.d.ts")) {
    Write-Host "✓ Files created successfully" -ForegroundColor Green
    Get-Item "src/app/globals.css" | Select-Object Name, Length
} else {
    Write-Host "⚠ File creation issue" -ForegroundColor Red
}

Write-Host "`nRun: npm run build" -ForegroundColor Yellow