"use client";

import { useState } from "react";
import { Globe } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function IdiomaPage() {
  const { t, language, setLanguage, options } = useLanguage();
  const [selected, setSelected] = useState(language);

  const handleSave = () => {
    setLanguage(selected);
  };

  return (
    <PageTransition>
      <MobileShell
        title={t("language.title")}
        icon={<Globe className="h-5 w-5" />}
        backHref="/utente/definicoes"
      >
        <Card className="divide-y divide-brand-50">
          {options.map((option) => (
            <button
              key={option.code}
              type="button"
              onClick={() => setSelected(option.code)}
              className="flex w-full items-center justify-between px-4 py-4 text-sm font-semibold text-brand-700"
            >
              {option.label}
              <span
                className={`h-4 w-4 rounded-full border ${
                  selected === option.code
                    ? "border-brand-700 bg-brand-700"
                    : "border-brand-200"
                }`}
              />
            </button>
          ))}
        </Card>
        <Button className="mt-6 w-full" onClick={handleSave}>
          {t("language.save")}
        </Button>
      </MobileShell>
    </PageTransition>
  );
}
