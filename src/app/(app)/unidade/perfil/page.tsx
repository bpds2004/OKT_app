import Link from "next/link";
import { User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

const rows = [
  { label: "ID Máquina", value: "OKT124456" },
  { label: "Nome Completo:", value: "MedTech" },
  { label: "Email:", value: "medtech@exemplo.com" },
  { label: "Número de Telemóvel:", value: "+351 956 444 002" },
  { label: "Endereço da Unidade:", value: "Rua da Saúde, nº1, 1000-000 Lisboa" },
  { label: "Código da Unidade:", value: "1452" },
];

export default function UnidadePerfilPage() {
  return (
    <PageTransition>
      <MobileShell title="Perfil" icon={<User className="h-5 w-5" />} backHref="/unidade/pagina-principal">
        <Card className="divide-y divide-brand-50">
          {rows.map((row) => (
            <div key={row.label} className="flex items-center justify-between px-4 py-3 text-sm">
              <span className="font-semibold text-brand-500">{row.label}</span>
              <span className="text-right text-brand-800">{row.value}</span>
            </div>
          ))}
        </Card>
        <div className="mt-6 space-y-3">
          <Link href="/unidade/editar-perfil">
            <Button className="w-full">Editar Perfil</Button>
          </Link>
          <Button className="w-full" variant="outline">
            Definições de Conta
          </Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
