# Fix TypeScript import errors in UI components
Write-Host "Fixing TypeScript imports..." -ForegroundColor Cyan

# Fix Button.tsx
$buttonContent = @'
import type { ReactNode } from 'react';

interface ButtonProps {
  children: ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  className?: string;
}

export default function Button({ 
  children, 
  onClick, 
  variant = 'primary', 
  disabled = false,
  className = ''
}: ButtonProps) {
  const baseClass = 'px-4 py-2 rounded-lg font-medium transition-all';
  const variantClass = variant === 'primary' 
    ? 'bg-blue-600 text-white hover:bg-blue-700' 
    : 'bg-gray-200 text-gray-800 hover:bg-gray-300';
  const disabledClass = disabled ? 'opacity-50 cursor-not-allowed' : '';
  
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`${baseClass} ${variantClass} ${disabledClass} ${className}`}
    >
      {children}
    </button>
  );
}
'@

Set-Content -Path "src/components/ui/Button.tsx" -Value $buttonContent -Encoding UTF8
Write-Host "✓ Fixed Button.tsx" -ForegroundColor Green

# Fix any other UI components with similar issues
Get-ChildItem -Path "src/components/ui" -Filter "*.tsx" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $fixed = $content -replace "import \{ ReactNode \}", "import type { ReactNode }"
    $fixed = $fixed -replace "import \{ FC \}", "import type { FC }"
    $fixed = $fixed -replace "import \{ ComponentProps \}", "import type { ComponentProps }"
    Set-Content -Path $_.FullName -Value $fixed -Encoding UTF8
}
Write-Host "✓ Fixed all UI component imports" -ForegroundColor Green

Write-Host "`nRun: npm run build" -ForegroundColor Yellow