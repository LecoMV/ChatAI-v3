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

