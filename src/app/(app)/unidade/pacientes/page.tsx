"use client";

import { Users, Eye } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";

const patients = [
  "Joana Lopes Gomes",
  "Joana Almeida",
  "Joana Gomes",
  "Joana Sofia Pereira",
  "Joana Maria Ferreira",
  "Joana Moreira Carvalho",
];

export default function PacientesPage() {
  return (
    <PageTransition>
      <MobileShell title="Pacientes" icon={<Users className="h-5 w-5" />} backHref="/unidade/pagina-principal">
        <div className="space-y-4">
          <div className="flex items-center gap-3">
            <Input placeholder="Joana" className="h-10" />
            <Button className="h-10 px-4">Filtro</Button>
          </div>
          <p className="text-sm font-semibold text-brand-600">20 Resultados</p>
        </div>

        <div className="mt-4 space-y-3">
          {patients.map((name) => (
            <Card key={name} className="flex items-center justify-between px-4 py-3">
              <div className="flex items-center gap-3">
                <div className="flex h-9 w-9 items-center justify-center rounded-full bg-brand-50 text-brand-400">
                  <Users className="h-4 w-4" />
                </div>
                <span className="text-sm font-semibold text-brand-700">{name}</span>
              </div>
              <Eye className="h-5 w-5 text-brand-300" />
            </Card>
          ))}
        </div>

        <div className="mt-6 flex items-center justify-between">
          <Button variant="outline" className="px-6">
            Anterior
          </Button>
          <Button className="px-6">Seguinte</Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
