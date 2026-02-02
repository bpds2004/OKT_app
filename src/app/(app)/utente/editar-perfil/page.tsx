"use client";

import { useEffect, useState } from "react";
import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

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
        const response = await fetch("/api/me");
        if (!response.ok) {
          setLoading(false);
          return;
        }
        const data = (await response.json()) as {
          user: {
            name: string;
            email: string;
            patientProfile: {
              phone?: string | null;
              nif?: string | null;
              birthDate?: string | null;
              healthNumber?: string | null;
              address?: string | null;
            } | null;
          };
        };
        setFormData({
          fullName: data.user.name,
          email: data.user.email,
          phone: data.user.patientProfile?.phone ?? "",
          healthNumber: data.user.patientProfile?.healthNumber ?? "",
          nif: data.user.patientProfile?.nif ?? "",
          birthDate: data.user.patientProfile?.birthDate
            ? new Date(data.user.patientProfile.birthDate).toISOString().split("T")[0]
            : "",
          medicalHistory: data.user.patientProfile?.address ?? "",
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

  return (
    <PageTransition>
      <MobileShell title={t("profile.editProfile")} icon={<User className="h-5 w-5" />} backHref="/utente/perfil">
        <form className="space-y-4">
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
            <Button className="w-full">{t("common.save")}</Button>
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
