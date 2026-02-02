import type { HTMLAttributes } from "react";
import { cn } from "@/lib/utils";

export function Logo({ className }: HTMLAttributes<HTMLDivElement>) {
  return (
    <div className={cn("flex flex-col items-center gap-2 text-brand-800", className)}>
      <div className="flex items-center gap-2">
        <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-brand-50">
          <svg
            viewBox="0 0 48 48"
            className="h-10 w-10"
            aria-hidden
          >
            <defs>
              <linearGradient id="okt-gradient" x1="0" y1="0" x2="1" y2="1">
                <stop offset="0%" stopColor="#2f6ea8" />
                <stop offset="100%" stopColor="#1d466b" />
              </linearGradient>
            </defs>
            <path
              d="M16 8c5 0 9 4 9 9v14c0 5-4 9-9 9s-9-4-9-9V17c0-5 4-9 9-9z"
              fill="none"
              stroke="url(#okt-gradient)"
              strokeWidth="3"
            />
            <path
              d="M32 8c5 0 9 4 9 9v14c0 5-4 9-9 9s-9-4-9-9V17c0-5 4-9 9-9z"
              fill="none"
              stroke="url(#okt-gradient)"
              strokeWidth="3"
            />
            <path
              d="M12 18h24M12 30h24"
              stroke="#4d8ac0"
              strokeWidth="3"
              strokeLinecap="round"
            />
          </svg>
        </div>
        <div className="text-3xl font-bold tracking-tight">OKT</div>
      </div>
      <span className="text-lg font-semibold text-brand-700">OncoKit test</span>
    </div>
  );
}
