import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        brand: {
          50: "#f1f6fb",
          100: "#e2edf6",
          200: "#b9d4ea",
          300: "#7cb0d6",
          400: "#4d8ac0",
          500: "#2f6ea8",
          600: "#245785",
          700: "#1d466b",
          800: "#173855",
          900: "#122c44",
        },
        slateBlue: "#2a2d4d",
      },
      boxShadow: {
        soft: "0 12px 30px rgba(18, 44, 68, 0.12)",
      },
      fontFamily: {
        sans: ["Inter", "system-ui", "sans-serif"],
      },
    },
  },
  plugins: [],
};

export default config;
