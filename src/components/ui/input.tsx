import * as React from "react";
import { cn } from "@/lib/utils";

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, disabled, ...props }, ref) => (
    <input
      ref={ref}
      type={type}
      disabled={disabled}
      className={cn(
        "flex h-11 w-full rounded-lg border border-brand-100 bg-white px-4 text-sm text-brand-800 shadow-sm transition-all placeholder:text-brand-300 focus-visible:border-brand-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-200 disabled:cursor-not-allowed disabled:bg-brand-50 disabled:text-brand-400",
        className,
      )}
      {...props}
    />
  ),
);
Input.displayName = "Input";
