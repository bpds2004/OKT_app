import { Wifi, ClipboardCheck } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";

export default function NovoTestePage() {
  return (
    <PageTransition>
      <MobileShell title="Novo teste" icon={<ClipboardCheck className="h-5 w-5" />} backHref="/utente/pagina-principal">
        <div className="space-y-4">
          <Card className="p-6 text-center">
            <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-brand-50 text-brand-700">
              <Wifi className="h-6 w-6" />
            </div>
            <p className="mt-4 text-sm text-brand-600">
              Certifique-se de que sua máquina OncoKit esteja ligada e ao alcance do Bluetooth para iniciar a conexão.
            </p>
          </Card>
          <Card className="flex items-center justify-between px-4 py-3">
            <span className="text-sm font-semibold text-brand-600">Status da Conexão:</span>
            <span className="text-sm font-semibold text-red-500">Desconectado</span>
          </Card>
          <Button variant="outline" className="w-full">
            Conectar Dispositivo
          </Button>
          <div>
            <label className="text-sm font-semibold text-brand-700">ID do Teste</label>
            <Input placeholder="Ex: TST001234" className="mt-2" />
          </div>
          <Button className="w-full" disabled>
            Continuar
          </Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
