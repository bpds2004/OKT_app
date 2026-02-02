"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { CheckCircle2 } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function TesteRealizadoPage() {
  const { t } = useLanguage();
  const [latestTest, setLatestTest] = useState<{ id: string; createdAt: string } | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTests = async () => {
      try {
        const response = await fetch("/api/utente/tests");
        if (!response.ok) {
          setLatestTest(null);
          setLoading(false);
          return;
        }
        const data = (await response.json()) as {
          tests: { id: string; createdAt: string }[];
        };
        setLatestTest(data.tests[0] ?? null);
      } catch {
        setLatestTest(null);
      } finally {
        setLoading(false);
      }
    };
    fetchTests();
  }, []);

  return (
    <PageTransition>
      <MobileShell
        title={t("testComplete.title")}
        icon={<CheckCircle2 className="h-5 w-5" />}
        backHref="/utente/pagina-principal"
      >
        <div className="flex flex-col items-center text-center">
          <div className="mt-4 flex h-20 w-20 items-center justify-center rounded-full border border-brand-100">
            <CheckCircle2 className="h-10 w-10 text-brand-700" />
          </div>
          <h2 className="mt-4 text-lg font-semibold text-brand-800">
            {t("testComplete.successTitle")}
          </h2>
          <p className="mt-2 text-sm text-brand-500">
            {t("testComplete.successSubtitle")}
          </p>
        </div>

        <Card className="mt-6 p-4 text-sm text-brand-600">
          <h3 className="text-center text-sm font-semibold text-brand-700">
            {t("testComplete.detailsTitle")}
          </h3>
          {loading ? (
            <p className="mt-4 text-center text-xs text-brand-500">{t("common.loading")}</p>
          ) : latestTest ? (
            <div className="mt-4 space-y-2">
              <div className="flex items-center justify-between">
                <span>{t("testComplete.testId")}</span>
                <span className="font-semibold text-brand-800">{latestTest.id}</span>
              </div>
              <div className="flex items-center justify-between">
                <span>{t("testComplete.date")}</span>
                <span className="font-semibold text-brand-800">
                  {new Date(latestTest.createdAt).toLocaleDateString()}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span>{t("testComplete.time")}</span>
                <span className="font-semibold text-brand-800">
                  {new Date(latestTest.createdAt).toLocaleTimeString()}
                </span>
              </div>
            </div>
          ) : (
            <p className="mt-4 text-center text-xs text-brand-500">
              {t("tests.empty")}
            </p>
          )}
        </Card>

        <p className="mt-4 text-center text-xs text-brand-500">
          {t("testComplete.waitNotice")}
        </p>

        <div className="mt-6 space-y-3">
          <Link href="/utente/pagina-principal">
            <Button className="w-full">{t("common.backToHome")}</Button>
          </Link>
          <Link href="/utente/novo-teste">
            <Button variant="outline" className="w-full">
              {t("common.newTest")}
            </Button>
          </Link>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
