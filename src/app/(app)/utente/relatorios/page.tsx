"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { FileText } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

type ReportItem = {
  id: string;
  createdAt: string;
  riskLevel: string;
};

export default function RelatoriosPage() {
  const [loading, setLoading] = useState(true);
  const [reports, setReports] = useState<ReportItem[]>([]);
  const { t } = useLanguage();

  useEffect(() => {
    const fetchReports = async () => {
      try {
        const { data, error } = await supabase
          .from("tests")
          .select("id, created_at, test_results(risk_level)")
          .order("created_at", { ascending: false });
        if (error || !data) {
          setReports([]);
          setLoading(false);
          return;
        }
        const mapped = data.map((test) => {
          const result = Array.isArray(test.test_results)
            ? test.test_results[0]
            : test.test_results;
          return {
            id: test.id,
            createdAt: test.created_at,
            riskLevel: result?.risk_level ?? t("reports.pending"),
          };
        });
        setReports(mapped);
      } catch {
        setReports([]);
      } finally {
        setLoading(false);
      }
    };
    fetchReports();
  }, []);

  return (
    <PageTransition>
      <MobileShell
        title={t("reports.title")}
        icon={<FileText className="h-5 w-5" />}
        backHref="/"
      >
        <div className="mb-5 flex items-center justify-between text-sm text-brand-500">
          <span>{t("reports.sortBy")}</span>
          <select className="rounded-full border border-brand-100 bg-white px-4 py-2 text-sm font-semibold text-brand-700 shadow-sm">
            <option>{t("reports.sortNewest")}</option>
            <option>{t("reports.sortOldest")}</option>
          </select>
        </div>
        <div className="space-y-4">
          {loading
            ? Array.from({ length: 3 }).map((_, index) => (
                <Card key={index} className="p-4">
                  <div className="flex items-center gap-4">
                    <div className="h-12 w-12 rounded-full bg-brand-50" />
                    <div className="flex-1 space-y-2">
                      <div className="h-4 w-2/3 rounded-full bg-brand-50" />
                      <div className="h-3 w-1/3 rounded-full bg-brand-50" />
                      <div className="h-5 w-20 rounded-full bg-brand-50" />
                    </div>
                    <div className="h-8 w-24 rounded-full bg-brand-50" />
                  </div>
                </Card>
              ))
            : reports.length > 0
              ? reports.map((report) => (
                  <Card key={report.id} className="p-4">
                    <div className="flex items-center gap-4">
                      <div className="flex h-12 w-12 items-center justify-center rounded-full bg-brand-50 text-brand-700">
                        <FileText className="h-5 w-5" />
                      </div>
                      <div className="flex-1">
                        <div className="text-base font-semibold text-brand-800">
                          {t("reports.reportId", { id: report.id })}
                        </div>
                        <div className="text-sm text-brand-400">
                          {new Date(report.createdAt).toLocaleDateString()}
                        </div>
                        <Badge variant="neutral" className="mt-2">
                          {report.riskLevel}
                        </Badge>
                      </div>
                      <Link href={`/utente/resultado-teste?id=${report.id}`}>
                        <Button size="sm" className="rounded-full px-4 text-sm">
                          {t("reports.viewDetails")}
                        </Button>
                      </Link>
                    </div>
                  </Card>
                ))
              : (
                  <Card className="p-6 text-center">
                    <p className="text-sm font-semibold text-brand-700">
                      {t("reports.emptyTitle")}
                    </p>
                    <p className="mt-2 text-xs text-brand-500">
                      {t("reports.emptyDescription")}
                    </p>
                  </Card>
                )}
        </div>
      </MobileShell>
    </PageTransition>
  );
}
