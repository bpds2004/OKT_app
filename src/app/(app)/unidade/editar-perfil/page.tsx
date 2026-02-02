"use client";

import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";

export default function UnidadeEditarPerfilPage() {
  return (
    <PageTransition>
      <MobileShell title="Editar Perfil" icon={<User className="h-5 w-5" />} backHref="/unidade/perfil">
        <form className="space-y-4">
          <div>
            <label className="text-sm font-semibold text-brand-700">ID Máquina</label>
            <Input defaultValue="OKT124456" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Nome Completo</label>
            <Input defaultValue="MedTech" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Email</label>
            <Input defaultValue="medtech@exemplo.com" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Número de Telemóvel</label>
            <Input defaultValue="+351 956 444 002" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Endereço da Unidade</label>
            <Input defaultValue="Rua da Saúde, nº1, 1000-000 Lisboa" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">Código da Unidade</label>
            <Input defaultValue="1452" className="mt-2" />
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
