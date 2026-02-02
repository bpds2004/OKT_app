"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Eye, User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

export default function PerfilPage() {
  const { t } = useLanguage();
  const [profile, setProfile] = useState<{
    name: string;
    email: string;
    phone?: string | null;
    nif?: string | null;
    birthDate?: string | null;
    healthNumber?: string | null;
    medicalHistory?: string | null;
  } | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const { data: userInfo } = await supabase.auth.getUser();
        if (!userInfo.user) {
          setProfile(null);
          setLoading(false);
          return;
        }
        const { data, error } = await supabase
          .from("profiles")
          .select("name, patient_profiles(phone, nif, birth_date, address, health_number)")
          .eq("id", userInfo.user.id)
          .single();
        if (error || !data) {
          setProfile(null);
          setLoading(false);
          return;
        }
        const patientProfile = Array.isArray(data.patient_profiles)
          ? data.patient_profiles[0]
          : data.patient_profiles;
        setProfile({
          name: data.name,
          email: userInfo.user.email ?? "",
          phone: patientProfile?.phone ?? null,
          nif: patientProfile?.nif ?? null,
          birthDate: patientProfile?.birth_date ?? null,
          healthNumber: patientProfile?.health_number ?? null,
          medicalHistory: patientProfile?.address ?? null,
        });
      } catch {
        setProfile(null);
      } finally {
        setLoading(false);
      }
    };
    fetchProfile();
  }, []);

  const rows = [
    { label: `${t("profile.fullName")}:`, value: profile?.name ?? t("profile.emptyValue") },
    { label: `${t("profile.email")}:`, value: profile?.email ?? t("profile.emptyValue") },
    { label: `${t("profile.phone")}:`, value: profile?.phone ?? t("profile.emptyValue") },
    { label: `${t("profile.userNumber")}:`, value: profile?.healthNumber ?? t("profile.emptyValue"), icon: Eye },
    { label: `${t("profile.nif")}:`, value: profile?.nif ?? t("profile.emptyValue"), icon: Eye },
    {
      label: `${t("profile.birthDate")}:`,
      value: profile?.birthDate
        ? new Date(profile.birthDate).toLocaleDateString()
        : t("profile.emptyValue"),
    },
  ];

  return (
    <PageTransition>
      <MobileShell
        title={t("profile.title")}
        icon={<User className="h-5 w-5" />}
        backHref="/utente/pagina-principal"
      >
        <Card className="divide-y divide-brand-50">
          {loading ? (
            <div className="px-4 py-6 text-center text-sm text-brand-500">
              {t("common.loading")}
            </div>
          ) : (
            <>
              {rows.map((row) => (
                <div key={row.label} className="flex items-center justify-between px-4 py-3 text-sm">
                  <span className="font-semibold text-brand-500">{row.label}</span>
                  <div className="flex items-center gap-2 text-brand-800">
                    <span>{row.value}</span>
                    {row.icon ? <row.icon className="h-4 w-4 text-brand-300" /> : null}
                  </div>
                </div>
              ))}
              <div className="px-4 py-4">
                <p className="text-sm font-semibold text-brand-500">
                  {t("profile.medicalHistory")}:
                </p>
                <Card className="mt-2 bg-brand-50 p-3 text-sm text-brand-600">
                  {profile?.medicalHistory ?? t("profile.emptyValue")}
                </Card>
              </div>
              <div className="flex items-center justify-between px-4 py-3 text-sm">
                <span className="font-semibold text-brand-500">
                  {t("profile.familyDoctor")}:
                </span>
                <span className="text-brand-800">{t("profile.familyDoctorEmpty")}</span>
              </div>
            </>
          )}
        </Card>
        <div className="mt-6 space-y-3">
          <Link href="/utente/editar-perfil">
            <Button className="w-full">{t("profile.editProfile")}</Button>
          </Link>
          <Link href="/utente/definicoes">
            <Button className="w-full" variant="outline">
              {t("settings.title")}
            </Button>
          </Link>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
