"use client";

import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";

export default function EditarPerfilPage() {
  return (
    <PageTransition>
      <MobileShell title="Editar Perfil" icon={<User className="h-5 w-5" />} backHref="/utente/perfil">
        <form className="space-y-4">
          <div>
            <label className="text-sm font-semibold text-brand-700">ID Máquina</label>
            <Input defaultValue="OKT123456" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Nome Completo</label>
            <Input defaultValue="Sofia Rocha" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Email</label>
            <Input defaultValue="sofia.rocha@onco-kit.com" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Número de Telemóvel</label>
            <Input defaultValue="912 345 678" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Número de Utente</label>
            <Input defaultValue="123 456 789" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">NIF</label>
            <Input defaultValue="234 567 890" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Data de Nascimento</label>
            <Input defaultValue="15/05/1990" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Histórico Médico</label>
            <textarea
              className="mt-2 h-28 w-full rounded-lg border border-brand-100 px-4 py-3 text-sm text-brand-700 focus-visible:border-brand-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand-200"
              defaultValue="Sem histórico médico significativo. Alergias: Penicilina. Medicação atual: Nenhuma."
            />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Nome do Médico de Família</label>
            <Input defaultValue="Dr. Pedro Santos" className="mt-2" />
          </div>
          <div className="space-y-3 pt-4">
            <Button className="w-full">Guardar</Button>
            <Button variant="outline" className="w-full">
              Cancelar
            </Button>
          </div>
        </form>
      </MobileShell>
    </PageTransition>
  );
}
