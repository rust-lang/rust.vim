/**  @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        'ton-blue': '#0088cc',
        'ton-blue-dark': '#0066aa',
      }
    },
  },
  plugins: [],
}
 