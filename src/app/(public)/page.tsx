"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Logo } from "@/components/common/logo";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function HomePage() {
  const { t } = useLanguage();

  return (
    <PageTransition>
      <div className="flex min-h-screen flex-col items-center justify-center bg-white px-6 py-10 text-center">
        <Logo />
        <div className="mt-16 flex w-full max-w-xs flex-col gap-4">
          <Link href="/login">
            <Button className="w-full text-lg">{t("common.enter")}</Button>
          </Link>
          <Link href="/registo">
            <Button className="w-full text-lg" variant="primary" type="button">
              {t("common.register")}
            </Button>
          </Link>
        </div>
        <p className="mt-10 text-xs text-brand-400">
          {t("public.privacyAgreement")}
        </p>
      </div>
    </PageTransition>
  );
}
