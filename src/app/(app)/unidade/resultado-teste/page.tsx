"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { FileText, Share2 } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

type ReportData = {
  id: string;
  createdAt: string;
  patientName: string;
  summary: string;
  riskLevel: string;
  variables: {
    id: string;
    name: string;
    significance: string;
    recommendation: string;
  }[];
};

export default function UnidadeResultadoTestePage() {
  const { t } = useLanguage();
  const searchParams = useSearchParams();
  const requestedId = searchParams.get("id");
  const [report, setReport] = useState<ReportData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchReport = async () => {
      try {
        const response = await fetch("/api/unidade/tests");
        if (!response.ok) {
          setReport(null);
          setLoading(false);
          return;
        }
        const data = (await response.json()) as {
          tests: {
            id: string;
            createdAt: string;
            patient: { name: string } | null;
            result: {
              summary: string;
              riskLevel: string;
              variables: {
                id: string;
                name: string;
                significance: string;
                recommendation: string;
              }[];
            } | null;
          }[];
        };
        const selected = data.tests.find((test) => test.id === requestedId) ?? data.tests[0];
        if (!selected || !selected.result) {
          setReport(null);
          setLoading(false);
          return;
        }
        setReport({
          id: selected.id,
          createdAt: selected.createdAt,
          patientName: selected.patient?.name ?? t("result.unknownPatient"),
          summary: selected.result.summary,
          riskLevel: selected.result.riskLevel,
          variables: selected.result.variables ?? [],
        });
      } catch {
        setReport(null);
      } finally {
        setLoading(false);
      }
    };
    fetchReport();
  }, [requestedId, t]);

  const mailtoHref = useMemo(() => {
    if (!report) return "#";
    return `mailto:?subject=${encodeURIComponent(
      t("result.emailSubject", { id: report.id }),
    )}&body=${encodeURIComponent(t("result.emailBody", { id: report.id }))}`;
  }, [report, t]);

  return (
    <PageTransition>
      <MobileShell
        title={report ? `ID:${report.id}` : t("home.shortcuts.reports")}
        icon={<FileText className="h-5 w-5" />}
        backHref="/unidade/pacientes"
      >
        {loading ? (
          <p className="text-center text-sm text-brand-500">{t("common.loading")}</p>
        ) : report ? (
          <>
            <p className="text-center text-lg font-semibold text-emerald-500">
              {report.riskLevel}
            </p>
            <Card className="mt-4 p-4">
              <h2 className="text-sm font-semibold text-brand-700">
                {t("result.title")}
              </h2>
              <div className="mt-3 space-y-2 text-xs text-brand-600">
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">{t("result.reportId")}</span>
                  <span className="text-brand-800">{report.id}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">{t("result.patientName")}</span>
                  <span className="text-brand-800">{report.patientName}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">{t("result.testDate")}</span>
                  <span className="text-brand-800">
                    {new Date(report.createdAt).toLocaleDateString()}
                  </span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">{t("result.summary")}</span>
                  <span className="text-brand-800">{report.summary}</span>
                </div>
              </div>
            </Card>

            <div className="mt-4 space-y-4">
              {report.variables.length > 0 ? (
                report.variables.map((variable) => (
                  <Card key={variable.id} className="p-4">
                    <h3 className="text-sm font-semibold text-brand-700">
                      {t("result.variants")}
                    </h3>
                    <div className="mt-3 space-y-2 text-xs text-brand-600">
                      <div className="flex items-center justify-between">
                        <span className="font-semibold text-brand-500">{t("result.gene")}</span>
                        <span className="text-brand-800">{variable.name}</span>
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="font-semibold text-brand-500">
                          {t("result.classification")}
                        </span>
                        <span className="text-brand-800">{variable.significance}</span>
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="font-semibold text-brand-500">
                          {t("result.recommendation")}
                        </span>
                        <span className="text-right text-brand-800">
                          {variable.recommendation}
                        </span>
                      </div>
                    </div>
                  </Card>
                ))
              ) : (
                <Card className="p-4 text-center text-xs text-brand-500">
                  {t("result.noVariables")}
                </Card>
              )}
            </div>

            <div className="mt-4 space-y-3">
              <Button className="w-full" onClick={() => window.open(mailtoHref, "_blank")}>
                <Share2 className="mr-2 h-4 w-4" />
                {t("result.sharePatient")}
              </Button>
              <Button variant="outline" className="w-full" onClick={() => window.history.back()}>
                {t("result.back")}
              </Button>
            </div>
          </>
        ) : (
          <Card className="mt-4 p-6 text-center">
            <p className="text-sm font-semibold text-brand-700">{t("reports.emptyTitle")}</p>
            <p className="mt-2 text-xs text-brand-500">{t("reports.emptyDescription")}</p>
          </Card>
        )}
      </MobileShell>
    </PageTransition>
  );
}
