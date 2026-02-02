"use client";

import { FormEvent, useEffect, useState } from "react";
import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

export default function EditarPerfilPage() {
  const { t } = useLanguage();
  const [formData, setFormData] = useState({
    fullName: "",
    email: "",
    phone: "",
    healthNumber: "",
    nif: "",
    birthDate: "",
    medicalHistory: "",
    familyDoctor: "",
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const { data: userInfo } = await supabase.auth.getUser();
        if (!userInfo.user) {
          setLoading(false);
          return;
        }
        const { data, error } = await supabase
          .from("profiles")
          .select("name, patient_profiles(phone, nif, birth_date, address, health_number)")
          .eq("id", userInfo.user.id)
          .single();
        if (error || !data) {
          setLoading(false);
          return;
        }
        const patientProfile = Array.isArray(data.patient_profiles)
          ? data.patient_profiles[0]
          : data.patient_profiles;
        setFormData({
          fullName: data.name,
          email: userInfo.user.email ?? "",
          phone: patientProfile?.phone ?? "",
          healthNumber: patientProfile?.health_number ?? "",
          nif: patientProfile?.nif ?? "",
          birthDate: patientProfile?.birth_date
            ? new Date(patientProfile.birth_date).toISOString().split("T")[0]
            : "",
          medicalHistory: patientProfile?.address ?? "",
          familyDoctor: "",
        });
      } finally {
        setLoading(false);
      }
    };
    fetchProfile();
  }, []);

  const handleChange = (field: string, value: string) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const { data: userInfo } = await supabase.auth.getUser();
    if (!userInfo.user) {
      return;
    }
    await supabase
      .from("profiles")
      .update({ name: formData.fullName })
      .eq("id", userInfo.user.id);
    await supabase
      .from("patient_profiles")
      .update({
        phone: formData.phone || null,
        nif: formData.nif || null,
        birth_date: formData.birthDate ? new Date(formData.birthDate).toISOString() : null,
        address: formData.medicalHistory || null,
        health_number: formData.healthNumber || null,
      })
      .eq("user_id", userInfo.user.id);
  };

  return (
    <PageTransition>
      <MobileShell title={t("profile.editProfile")} icon={<User className="h-5 w-5" />} backHref="/utente/perfil">
        <form className="space-y-4" onSubmit={handleSubmit}>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.deviceId")}</label>
            <Input value={t("profile.deviceUnavailable")} className="mt-2" disabled />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.fullName")}</label>
            <Input
              value={formData.fullName}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("fullName", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.email")}</label>
            <Input
              value={formData.email}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("email", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.phone")}</label>
            <Input
              value={formData.phone}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("phone", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.userNumber")}</label>
            <Input
              value={formData.healthNumber}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("healthNumber", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.nif")}</label>
            <Input
              value={formData.nif}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("nif", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.birthDate")}</label>
            <Input
              value={formData.birthDate}
              className="mt-2"
              type="date"
              disabled={loading}
              onChange={(event) => handleChange("birthDate", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.medicalHistory")}</label>
            <textarea
              className="mt-2 h-28 w-full rounded-lg border border-brand-100 px-4 py-3 text-sm text-brand-700 focus-visible:border-brand-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-200"
              value={formData.medicalHistory}
              disabled={loading}
              onChange={(event) => handleChange("medicalHistory", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.familyDoctor")}</label>
            <Input
              value={formData.familyDoctor}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("familyDoctor", event.target.value)}
            />
          </div>
          <div className="space-y-3 pt-4">
            <Button className="w-full" type="submit">
              {t("common.save")}
            </Button>
            <Button
              variant="outline"
              className="w-full"
              type="button"
              onClick={() => window.history.back()}
            >
              {t("common.cancel")}
            </Button>
          </div>
        </form>
      </MobileShell>
    </PageTransition>
  );
}
