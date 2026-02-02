"use client";

import { FormEvent, useEffect, useState } from "react";
import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";
import { supabase } from "@/lib/supabase/client";

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
        const { data: userInfo } = await supabase.auth.getUser();
        if (!userInfo.user) {
          setLoading(false);
          return;
        }
        const { data, error } = await supabase
          .from("unit_profiles")
          .select("health_units(name, address, code)")
          .eq("user_id", userInfo.user.id)
          .single();
        if (error || !data) {
          setLoading(false);
          return;
        }
        const unit = Array.isArray(data.health_units) ? data.health_units[0] : data.health_units;
        setFormData({
          unitName: unit?.name ?? "",
          unitEmail: userInfo.user.email ?? "",
          unitPhone: "",
          unitAddress: unit?.address ?? "",
          unitCode: unit?.code ?? "",
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
    const { data: unitProfile } = await supabase
      .from("unit_profiles")
      .select("health_unit_id")
      .eq("user_id", userInfo.user.id)
      .single();
    if (!unitProfile?.health_unit_id) {
      return;
    }
    await supabase
      .from("health_units")
      .update({
        name: formData.unitName,
        address: formData.unitAddress || null,
        code: formData.unitCode,
      })
      .eq("id", unitProfile.health_unit_id);
  };

  return (
    <PageTransition>
      <MobileShell title={t("profile.editProfile")} icon={<User className="h-5 w-5" />} backHref="/unidade/perfil">
        <form className="space-y-4" onSubmit={handleSubmit}>
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
            <Button className="w-full" type="submit">
              {t("common.save")}
            </Button>
            <Button variant="outline" className="w-full" type="button" onClick={() => window.history.back()}>
              {t("common.cancel")}
            </Button>
          </div>
        </form>
      </MobileShell>
    </PageTransition>
  );
}
