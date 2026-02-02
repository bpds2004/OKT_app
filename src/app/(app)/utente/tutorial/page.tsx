"use client";

import { BookOpen } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function TutorialPage() {
  const { t } = useLanguage();
  const steps = [
    {
      number: 1,
      title: t("tutorial.step1Title"),
      description: t("tutorial.step1"),
    },
    {
      number: 2,
      title: t("tutorial.step2Title"),
      description: t("tutorial.step2"),
    },
    {
      number: 3,
      title: t("tutorial.step3Title"),
      description: t("tutorial.step3"),
    },
    {
      number: 4,
      title: t("tutorial.step4Title"),
      description: t("tutorial.step4"),
    },
  ];

  return (
    <PageTransition>
      <MobileShell title={t("tutorial.title")} icon={<BookOpen className="h-5 w-5" />} backHref="/utente/relatorios">
        <div className="space-y-4">
          {steps.map((step) => (
            <Card key={step.number} className="overflow-hidden">
              <div className="relative">
                <div className="absolute left-4 top-4 flex h-7 w-7 items-center justify-center rounded-full bg-brand-50 text-xs font-semibold text-brand-700">
                  {step.number}
                </div>
                <div className="h-40 w-full bg-gradient-to-br from-brand-50 via-white to-brand-100" />
              </div>
              <div className="px-4 pb-4 pt-3">
                <h3 className="text-sm font-semibold text-brand-700">{step.title}</h3>
                <p className="mt-2 text-xs text-brand-500">{step.description}</p>
              </div>
            </Card>
          ))}
        </div>
        <Button className="mt-6 w-full">{t("tutorial.startTest")}</Button>
      </MobileShell>
    </PageTransition>
  );
}
