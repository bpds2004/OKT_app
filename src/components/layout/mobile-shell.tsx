import type { PropsWithChildren } from "react";
import Link from "next/link";
import { ChevronLeft } from "lucide-react";
import { cn } from "@/lib/utils";

interface MobileShellProps extends PropsWithChildren {
  title: string;
  subtitle?: string;
  icon?: React.ReactNode;
  backHref?: string;
  rightSlot?: React.ReactNode;
  className?: string;
}

export function MobileShell({
  title,
  subtitle,
  icon,
  backHref = "/",
  rightSlot,
  className,
  children,
}: MobileShellProps) {
  return (
    <div className={cn("min-h-screen bg-white", className)}>
      <header className="border-b border-brand-50 px-5 pb-4 pt-6">
        <div className="flex items-center justify-between">
          <Link
            href={backHref}
            className="flex h-9 w-9 items-center justify-center rounded-full border border-brand-100 text-brand-700 transition hover:bg-brand-50"
          >
            <ChevronLeft className="h-5 w-5" />
          </Link>
          <div className="flex items-center gap-2 text-brand-800">
            {icon}
            <h1 className="text-lg font-semibold">{title}</h1>
          </div>
          <div className="w-9">{rightSlot}</div>
        </div>
        {subtitle ? (
          <p className="mt-3 text-sm text-brand-500">{subtitle}</p>
        ) : null}
      </header>
      <main className="px-5 pb-10 pt-4">{children}</main>
    </div>
  );
}
