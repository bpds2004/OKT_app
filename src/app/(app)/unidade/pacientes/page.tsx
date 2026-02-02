"use client";

import { useEffect, useMemo, useState } from "react";
import { Users, Eye } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

type PatientRow = {
  id: string;
  name: string;
};

export default function PacientesPage() {
  const { t } = useLanguage();
  const [patients, setPatients] = useState<PatientRow[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchPatients = async () => {
      try {
        const { data, error } = await supabase
          .from("tests")
          .select("patient:profiles!tests_patient_user_id_fkey ( id, name )")
          .order("created_at", { ascending: false });
        if (error || !data) {
          setPatients([]);
          setLoading(false);
          return;
        }
        const unique = new Map<string, PatientRow>();
        data.forEach((test) => {
          const patient = Array.isArray(test.patient) ? test.patient[0] : test.patient;
          if (patient) {
            unique.set(patient.id, {
              id: patient.id,
              name: patient.name,
            });
          }
        });
        setPatients(Array.from(unique.values()));
      } catch {
        setPatients([]);
      } finally {
        setLoading(false);
      }
    };
    fetchPatients();
  }, []);

  const patientCount = useMemo(() => patients.length, [patients]);

  return (
    <PageTransition>
      <MobileShell title={t("home.shortcuts.patients")} icon={<Users className="h-5 w-5" />} backHref="/unidade/pagina-principal">
        <div className="space-y-4">
          <div className="flex items-center gap-3">
            <Input placeholder={t("patients.searchPlaceholder")} className="h-10" />
            <Button className="h-10 px-4">{t("patients.filter")}</Button>
          </div>
          <p className="text-sm font-semibold text-brand-600">
            {t("patients.results", { count: patientCount })}
          </p>
        </div>

        <div className="mt-4 space-y-3">
          {loading ? (
            <Card className="p-6 text-center text-sm text-brand-500">
              {t("common.loading")}
            </Card>
          ) : patients.length > 0 ? (
            patients.map((patient) => (
              <Card key={patient.id} className="flex items-center justify-between px-4 py-3">
                <div className="flex items-center gap-3">
                  <div className="flex h-9 w-9 items-center justify-center rounded-full bg-brand-50 text-brand-400">
                    <Users className="h-4 w-4" />
                  </div>
                  <span className="text-sm font-semibold text-brand-700">{patient.name}</span>
                </div>
                <Eye className="h-5 w-5 text-brand-300" />
              </Card>
            ))
          ) : (
            <Card className="p-6 text-center">
              <p className="text-sm font-semibold text-brand-700">
                {t("patients.emptyTitle")}
              </p>
              <p className="mt-2 text-xs text-brand-500">
                {t("patients.emptyDescription")}
              </p>
            </Card>
          )}
        </div>

        <div className="mt-6 flex items-center justify-between">
          <Button variant="outline" className="px-6">
            {t("patients.previous")}
          </Button>
          <Button className="px-6">{t("patients.next")}</Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
