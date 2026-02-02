"use client";

import { useState } from "react";
import Link from "next/link";
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

export default function DefinicoesPage() {
  const [notifications, setNotifications] = useState(true);

  return (
    <PageTransition>
      <MobileShell title="Definições" icon={<Settings className="h-5 w-5" />} backHref="/">
        <Card className="divide-y divide-brand-50">
          <div className="flex items-center justify-between px-4 py-4">
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <Bell className="h-4 w-4" />
              Notificações
            </div>
            <Switch checked={notifications} onCheckedChange={setNotifications} />
          </div>
          <Link
            href="/utente/privacidade"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <ShieldCheck className="h-4 w-4" />
              Privacidade
            </div>
            <span className="text-brand-300">›</span>
          </Link>
          <Link
            href="/utente/alterar-password"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <Lock className="h-4 w-4" />
              Segurança (Mudar palavra-passe)
            </div>
            <span className="text-brand-300">›</span>
          </Link>
          <Link
            href="/utente/idioma"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <Globe className="h-4 w-4" />
              Idioma
            </div>
            <span className="text-brand-300">›</span>
          </Link>
          <Link
            href="/utente/termos"
            className="flex items-center justify-between px-4 py-4"
          >
            <div className="flex items-center gap-3 text-sm font-semibold text-brand-700">
              <FileText className="h-4 w-4" />
              Termos e Condições
            </div>
            <span className="text-brand-300">›</span>
          </Link>
        </Card>
        <Button className="mt-6 w-full" variant="danger">
          Logout
        </Button>
      </MobileShell>
    </PageTransition>
  );
}
