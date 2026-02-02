import Link from "next/link";
import { Eye, User } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

const rows = [
  { label: "ID Máquina:", value: "OKT123456" },
  { label: "Nome Completo:", value: "Ana Pires" },
  { label: "Email:", value: "ana.pires@exemplo.com" },
  { label: "Número de Telemóvel:", value: "+351 965 123 456" },
  { label: "Número de Utente:", value: "•••••••••", icon: Eye },
  { label: "NIF:", value: "•••••••••", icon: Eye },
  { label: "Data de Nascimento:", value: "12/08/1985" },
];

export default function PerfilPage() {
  return (
    <PageTransition>
      <MobileShell title="Perfil" icon={<User className="h-5 w-5" />} backHref="/utente/pagina-principal">
        <Card className="divide-y divide-brand-50">
          {rows.map((row) => (
            <div key={row.label} className="flex items-center justify-between px-4 py-3 text-sm">
              <span className="font-semibold text-brand-500">{row.label}</span>
              <div className="flex items-center gap-2 text-brand-800">
                <span>{row.value}</span>
                {row.icon ? <row.icon className="h-4 w-4 text-brand-300" /> : null}
              </div>
            </div>
          ))}
          <div className="px-4 py-4">
            <p className="text-sm font-semibold text-brand-500">Histórico Médico:</p>
            <Card className="mt-2 bg-brand-50 p-3 text-sm text-brand-600">
              Histórico de alergia a penicilina. Sem outras condições crónicas.
            </Card>
          </div>
          <div className="flex items-center justify-between px-4 py-3 text-sm">
            <span className="font-semibold text-brand-500">Médico de Família:</span>
            <span className="text-brand-800">Dr. Sofia Santos</span>
          </div>
        </Card>
        <div className="mt-6 space-y-3">
          <Link href="/utente/editar-perfil">
            <Button className="w-full">Editar Perfil</Button>
          </Link>
          <Link href="/utente/definicoes">
            <Button className="w-full" variant="outline">
              Definições de Conta
            </Button>
          </Link>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
