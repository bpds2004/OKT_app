"use client";

import { useEffect, useState } from "react";
import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function UnidadeEditarPerfilPage() {
  const { t } = useLanguage();
  const [formData, setFormData] = useState({
    unitName: "",
    unitEmail: "",
    unitPhone: "",
    unitAddress: "",
    unitCode: "",
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
            unitProfile: { healthUnit: { name: string; address: string; code: string } } | null;
          };
        };
        setFormData({
          unitName: data.user.unitProfile?.healthUnit.name ?? "",
          unitEmail: data.user.email,
          unitPhone: "",
          unitAddress: data.user.unitProfile?.healthUnit.address ?? "",
          unitCode: data.user.unitProfile?.healthUnit.code ?? "",
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
      <MobileShell title={t("profile.editProfile")} icon={<User className="h-5 w-5" />} backHref="/unidade/perfil">
        <form className="space-y-4">
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.deviceId")}</label>
            <Input value={t("profile.deviceUnavailable")} className="mt-2" disabled />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.unitName")}</label>
            <Input
              value={formData.unitName}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("unitName", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.unitEmail")}</label>
            <Input
              value={formData.unitEmail}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("unitEmail", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.unitPhone")}</label>
            <Input
              value={formData.unitPhone}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("unitPhone", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.unitAddress")}</label>
            <Input
              value={formData.unitAddress}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("unitAddress", event.target.value)}
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">{t("profile.unitCode")}</label>
            <Input
              value={formData.unitCode}
              className="mt-2"
              disabled={loading}
              onChange={(event) => handleChange("unitCode", event.target.value)}
            />
          </div>
          <div className="space-y-3 pt-4">
            <Button className="w-full">{t("common.save")}</Button>
            <Button variant="outline" className="w-full" type="button" onClick={() => window.history.back()}>
              {t("common.cancel")}
            </Button>
          </div>
        </form>
      </MobileShell>
    </PageTransition>
  );
}
