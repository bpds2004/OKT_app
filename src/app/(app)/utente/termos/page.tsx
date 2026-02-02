"use client";

import { FileText } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function TermosPage() {
  const { t } = useLanguage();

  return (
    <PageTransition>
      <MobileShell title={t("terms.title")} icon={<FileText className="h-5 w-5" />} backHref="/utente/definicoes">
        <div className="space-y-4 text-sm text-brand-600">
          <h2 className="text-base font-semibold text-brand-800">
            {t("terms.acceptanceTitle")}
          </h2>
          <p>
            {t("terms.acceptanceBody")}
          </p>
          <div>
            <p className="font-semibold text-brand-700">{t("terms.section1Title")}</p>
            <p>
              {t("terms.section1Body")}
            </p>
          </div>
          <div>
            <p className="font-semibold text-brand-700">{t("terms.section2Title")}</p>
            <p>
              {t("terms.section2Body")}
            </p>
          </div>
          <p className="font-semibold text-brand-700">
            {t("terms.section2Footer")}
          </p>
          <div>
            <p className="font-semibold text-brand-700">{t("terms.section3Title")}</p>
            <p>
              {t("terms.section3Body")}
            </p>
          </div>
          <div>
            <p className="font-semibold text-brand-700">{t("terms.section4Title")}</p>
            <p>
              {t("terms.section4Body")}
            </p>
          </div>
        </div>
        <Button className="mt-8 w-full" variant="outline" onClick={() => window.history.back()}>
          {t("common.back")}
        </Button>
      </MobileShell>
    </PageTransition>
  );
}
