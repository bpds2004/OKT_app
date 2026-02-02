"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

export default function UnidadePerfilPage() {
  const { t } = useLanguage();
  const [profile, setProfile] = useState<{
    name: string;
    email: string;
    healthUnitName?: string | null;
    healthUnitAddress?: string | null;
    healthUnitCode?: string | null;
  } | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const response = await fetch("/api/me");
        if (!response.ok) {
          setProfile(null);
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
        setProfile({
          name: data.user.name,
          email: data.user.email,
          healthUnitName: data.user.unitProfile?.healthUnit.name ?? null,
          healthUnitAddress: data.user.unitProfile?.healthUnit.address ?? null,
          healthUnitCode: data.user.unitProfile?.healthUnit.code ?? null,
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
    { label: `${t("profile.unitName")}:`, value: profile?.healthUnitName ?? t("profile.emptyValue") },
    { label: `${t("profile.unitEmail")}:`, value: profile?.email ?? t("profile.emptyValue") },
    { label: `${t("profile.unitAddress")}:`, value: profile?.healthUnitAddress ?? t("profile.emptyValue") },
    { label: `${t("profile.unitCode")}:`, value: profile?.healthUnitCode ?? t("profile.emptyValue") },
  ];

  return (
    <PageTransition>
      <MobileShell title={t("profile.title")} icon={<User className="h-5 w-5" />} backHref="/unidade/pagina-principal">
        <Card className="divide-y divide-brand-50">
          {loading ? (
            <div className="px-4 py-6 text-center text-sm text-brand-500">
              {t("common.loading")}
            </div>
          ) : (
            rows.map((row) => (
              <div key={row.label} className="flex items-center justify-between px-4 py-3 text-sm">
                <span className="font-semibold text-brand-500">{row.label}</span>
                <span className="text-right text-brand-800">{row.value}</span>
              </div>
            ))
          )}
        </Card>
        <div className="mt-6 space-y-3">
          <Link href="/unidade/editar-perfil">
            <Button className="w-full">{t("profile.editProfile")}</Button>
          </Link>
          <Link href="/unidade/pagina-principal">
            <Button className="w-full" variant="outline">
              {t("settings.title")}
            </Button>
          </Link>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
