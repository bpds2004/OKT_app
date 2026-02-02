"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { FileText } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

const reports = [
  { id: "Zx78T", date: "04/12/2025", status: "Positivo", tone: "positive" },
  { id: "ZW59C", date: "04/12/2025", status: "Negativo", tone: "negative" },
  { id: "HG76C2", date: "12/11/2025", status: "Negativo", tone: "negative" },
];

export default function RelatoriosPage() {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 600);
    return () => clearTimeout(timer);
  }, []);

  return (
    <PageTransition>
      <MobileShell
        title="Relatórios"
        icon={<FileText className="h-5 w-5" />}
        backHref="/"
      >
        <div className="mb-5 flex items-center justify-between text-sm text-brand-500">
          <span>Ordenar por:</span>
          <select className="rounded-full border border-brand-100 bg-white px-4 py-2 text-sm font-semibold text-brand-700 shadow-sm">
            <option>Data (Mais Recente)</option>
            <option>Data (Mais Antiga)</option>
          </select>
        </div>
        <div className="space-y-4">
          {loading
            ? Array.from({ length: 3 }).map((_, index) => (
                <Card key={index} className="p-4">
                  <div className="flex items-center gap-4">
                    <div className="h-12 w-12 rounded-full bg-brand-50" />
                    <div className="flex-1 space-y-2">
                      <div className="h-4 w-2/3 rounded-full bg-brand-50" />
                      <div className="h-3 w-1/3 rounded-full bg-brand-50" />
                      <div className="h-5 w-20 rounded-full bg-brand-50" />
                    </div>
                    <div className="h-8 w-24 rounded-full bg-brand-50" />
                  </div>
                </Card>
              ))
            : reports.map((report) => (
                <Card key={report.id} className="p-4">
                  <div className="flex items-center gap-4">
                    <div className="flex h-12 w-12 items-center justify-center rounded-full bg-brand-50 text-brand-700">
                      <FileText className="h-5 w-5" />
                    </div>
                    <div className="flex-1">
                      <div className="text-base font-semibold text-brand-800">
                        Relatório ID:{report.id}
                      </div>
                      <div className="text-sm text-brand-400">{report.date}</div>
                      <Badge
                        variant={report.tone as "positive" | "negative"}
                        className="mt-2"
                      >
                        {report.status}
                      </Badge>
                    </div>
                    <Link href="/utente/resultado-teste">
                      <Button size="sm" className="rounded-full px-4 text-sm">
                        Ver Detalhes
                      </Button>
                    </Link>
                  </div>
                </Card>
              ))}
        </div>
      </MobileShell>
    </PageTransition>
  );
}
