"use client";

import { useState } from "react";
import Link from "next/link";
import { Bell, FileText } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { PageTransition } from "@/components/common/page-transition";

const notifications = [
  { id: "Zx78T", status: "Positivo", tone: "positive", time: "Há 5 minutos" },
  { id: "ZW59C", status: "Negativo", tone: "negative", time: "Há 10 horas" },
  { id: "HG76C2", status: "Positivo", tone: "positive", time: "Há 1 dia" },
];

export default function UnidadeNotificacoesPage() {
  const [filter, setFilter] = useState<"all" | "unread">("all");

  return (
    <PageTransition>
      <MobileShell title="Notificações" icon={<Bell className="h-5 w-5" />} backHref="/unidade/pagina-principal">
        <div className="space-y-4">
          <div className="text-sm font-semibold text-brand-500">Marcar todas como lidas</div>
          <div className="flex gap-3">
            <button
              type="button"
              onClick={() => setFilter("all")}
              className={`flex-1 rounded-lg px-4 py-2 text-sm font-semibold ${
                filter === "all" ? "bg-brand-800 text-white" : "bg-brand-50 text-brand-600"
              }`}
            >
              Todas
            </button>
            <button
              type="button"
              onClick={() => setFilter("unread")}
              className={`flex-1 rounded-lg px-4 py-2 text-sm font-semibold ${
                filter === "unread" ? "bg-brand-800 text-white" : "bg-brand-50 text-brand-600"
              }`}
            >
              Não lidas
            </button>
          </div>
        </div>

        <div className="mt-4 space-y-3">
          {notifications.map((item, index) => (
            <Card key={item.id} className="relative p-4">
              {index < 2 ? (
                <span className="absolute left-2 top-4 h-14 w-1 rounded-full bg-brand-700" />
              ) : null}
              <div className="flex items-start gap-4">
                <div className="flex h-10 w-10 items-center justify-center rounded-full bg-brand-50 text-brand-700">
                  <FileText className="h-5 w-5" />
                </div>
                <div className="flex-1">
                  <div className="flex items-center justify-between">
                    <p className="text-sm font-semibold text-brand-800">
                      Relatório ID:{item.id}
                    </p>
                    <span className="text-xs text-brand-400">{item.time}</span>
                  </div>
                  <Badge variant={item.tone as "positive" | "negative"} className="mt-2">
                    {item.status}
                  </Badge>
                  <Link href="/unidade/resultado-teste" className="mt-2 inline-block text-xs font-semibold text-brand-600">
                    Ver relatório
                  </Link>
                </div>
              </div>
            </Card>
          ))}
        </div>
      </MobileShell>
    </PageTransition>
  );
}
