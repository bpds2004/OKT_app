"use client";

import { Phone } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function SosPage() {
  const { t } = useLanguage();

  const callEmergency = () => {
    window.location.href = "tel:112";
  };

  return (
    <PageTransition>
      <MobileShell
        title={t("sos.title")}
        icon={<Phone className="h-5 w-5" />}
        backHref="/utente/pagina-principal"
      >
        <div className="flex flex-col items-center justify-center gap-6 py-10">
          <div className="flex h-24 w-24 items-center justify-center rounded-full bg-brand-800 text-white">
            <Phone className="h-8 w-8" />
          </div>
          <p className="text-xl font-semibold text-brand-800">112</p>
          <Button className="w-full" onClick={callEmergency}>
            {t("sos.call")}
          </Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
