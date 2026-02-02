"use client";

import { useEffect, useState } from "react";
import { ShieldCheck } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Switch } from "@/components/ui/switch";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

const STORAGE_KEY = "okt_privacy_settings";

export default function PrivacidadePage() {
  const { t } = useLanguage();
  const [shareData, setShareData] = useState(true);
  const [anonymousData, setAnonymousData] = useState(false);
  const [showPolicy, setShowPolicy] = useState(false);

  useEffect(() => {
    const stored = window.localStorage.getItem(STORAGE_KEY);
    if (stored) {
      const parsed = JSON.parse(stored) as { shareData: boolean; anonymousData: boolean };
      setShareData(parsed.shareData);
      setAnonymousData(parsed.anonymousData);
    }
  }, []);

  useEffect(() => {
    window.localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify({ shareData, anonymousData }),
    );
  }, [shareData, anonymousData]);

  return (
    <PageTransition>
      <MobileShell
        title={t("privacy.title")}
        icon={<ShieldCheck className="h-5 w-5" />}
        backHref="/utente/definicoes"
      >
        <Card className="p-4">
          <h2 className="text-sm font-semibold text-brand-700">
            {t("privacy.howWeUse")}
          </h2>
          <p className="mt-2 text-xs text-brand-500">
            {t("privacy.intro")}
          </p>
          <p className="mt-3 text-xs text-brand-500">
            {t("privacy.usage")}
          </p>
          <p className="mt-3 text-xs text-brand-500">
            {t("privacy.control")}
          </p>
        </Card>

        <div className="mt-4 space-y-3">
          <Card className="flex items-center justify-between px-4 py-4">
            <div>
              <p className="text-sm font-semibold text-brand-700">
                {t("privacy.shareDataTitle")}
              </p>
              <p className="mt-1 text-xs text-brand-500">
                {t("privacy.shareDataDescription")}
              </p>
            </div>
            <Switch checked={shareData} onCheckedChange={setShareData} />
          </Card>
          <Card className="flex items-center justify-between px-4 py-4">
            <div>
              <p className="text-sm font-semibold text-brand-700">
                {t("privacy.anonymousTitle")}
              </p>
              <p className="mt-1 text-xs text-brand-500">
                {t("privacy.anonymousDescription")}
              </p>
            </div>
            <Switch checked={anonymousData} onCheckedChange={setAnonymousData} />
          </Card>
        </div>

        <button
          className="mt-6 text-sm font-semibold text-brand-600"
          type="button"
          onClick={() => setShowPolicy((prev) => !prev)}
        >
          {t("privacy.fullPolicyButton")}
        </button>

        {showPolicy ? (
          <Card className="mt-4 space-y-3 p-4 text-xs text-brand-600">
            <h3 className="text-sm font-semibold text-brand-700">
              {t("privacy.fullPolicyTitle")}
            </h3>
            <div>
              <p className="font-semibold text-brand-700">
                {t("privacy.fullPolicySection1Title")}
              </p>
              <p>{t("privacy.fullPolicySection1Body")}</p>
            </div>
            <div>
              <p className="font-semibold text-brand-700">
                {t("privacy.fullPolicySection2Title")}
              </p>
              <p>{t("privacy.fullPolicySection2Body")}</p>
            </div>
            <div>
              <p className="font-semibold text-brand-700">
                {t("privacy.fullPolicySection3Title")}
              </p>
              <p>{t("privacy.fullPolicySection3Body")}</p>
            </div>
            <div>
              <p className="font-semibold text-brand-700">
                {t("privacy.fullPolicySection4Title")}
              </p>
              <p>{t("privacy.fullPolicySection4Body")}</p>
            </div>
            <div>
              <p className="font-semibold text-brand-700">
                {t("privacy.fullPolicySection5Title")}
              </p>
              <p>{t("privacy.fullPolicySection5Body")}</p>
            </div>
            <div>
              <p className="font-semibold text-brand-700">
                {t("privacy.fullPolicySection6Title")}
              </p>
              <p>{t("privacy.fullPolicySection6Body")}</p>
            </div>
          </Card>
        ) : null}
      </MobileShell>
    </PageTransition>
  );
}
