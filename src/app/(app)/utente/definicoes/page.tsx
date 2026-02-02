"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { signOut } from "next-auth/react";
import {
  Bell,
  Lock,
  Globe,
  FileText,
  ShieldCheck,
  Settings,
} from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Switch } from "@/components/ui/switch";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";
import { useLanguage } from "@/lib/i18n";

const STORAGE_KEY = "okt_settings";

export default function DefinicoesPage() {
  const { t } = useLanguage();
  const [notifications, setNotifications] = useState(true);

  useEffect(() => {
    const stored = window.localStorage.getItem(STORAGE_KEY);
    if (stored) {
      const parsed = JSON.parse(stored) as { notifications: boolean };
      setNotifications(parsed.notifications);
    }
  }, []);

  useEffect(() => {
    window.localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify({ notifications }),
    );
  }, [notifications]);

  const handleLogout = () => {
    signOut({ callbackUrl: "/" });
  };

  return (
    <PageTransition>
      <MobileShell title={t("settings.title")} icon={<Settings className="h-5 w-5" />} backHref="/">
        <Card className="divide-y divide-brand-50">
          <div className="flex items-center justify-between px-4 py-4">
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <Bell className="h-4 w-4" />
              {t("settings.notifications")}
            </div>
            <Switch checked={notifications} onCheckedChange={setNotifications} />
          </div>
          <Link
            href="/utente/privacidade"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <ShieldCheck className="h-4 w-4" />
              {t("settings.privacy")}
            </div>
            <span className="text-brand-300">›</span>
          </Link>
          <Link
            href="/utente/alterar-password"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <Lock className="h-4 w-4" />
              {t("settings.security")}
            </div>
            <span className="text-brand-300">›</span>
          </Link>
          <Link
            href="/utente/idioma"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <Globe className="h-4 w-4" />
              {t("settings.language")}
            </div>
            <span className="text-brand-300">›</span>
          </Link>
          <Link
            href="/utente/termos"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <FileText className="h-4 w-4" />
              {t("settings.terms")}
            </div>
            <span className="text-brand-300">›</span>
          </Link>
        </Card>
        <Button className="mt-6 w-full" variant="danger" onClick={handleLogout}>
          {t("common.logout")}
        </Button>
      </MobileShell>
    </PageTransition>
  );
}
