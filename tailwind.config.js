/** @type {import('tailwindcss').Config} */
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
      },
    },
  },
  plugins: [],
}