import { CheckCircle2 } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

export default function TesteRealizadoPage() {
  return (
    <PageTransition>
      <MobileShell title="Teste Realizado" icon={<CheckCircle2 className="h-5 w-5" />} backHref="/utente/pagina-principal">
        <div className="flex flex-col items-center text-center">
          <div className="mt-4 flex h-20 w-20 items-center justify-center rounded-full border border-brand-100">
            <CheckCircle2 className="h-10 w-10 text-brand-700" />
          </div>
          <h2 className="mt-4 text-lg font-semibold text-brand-800">
            Teste concluído com sucesso!
          </h2>
          <p className="mt-2 text-sm text-brand-500">
            Parabéns! O processo de análise foi finalizado com êxito.
          </p>
        </div>

        <Card className="mt-6 p-4 text-sm text-brand-600">
          <h3 className="text-center text-sm font-semibold text-brand-700">Detalhes do Teste</h3>
          <div className="mt-4 space-y-2">
            <div className="flex items-center justify-between">
              <span>ID do Teste:</span>
              <span className="font-semibold text-brand-800">OKT-2023-XYZ-12345</span>
            </div>
            <div className="flex items-center justify-between">
              <span>Data:</span>
              <span className="font-semibold text-brand-800">20/11/2025</span>
            </div>
            <div className="flex items-center justify-between">
              <span>Hora:</span>
              <span className="font-semibold text-brand-800">14:37:05</span>
            </div>
          </div>
        </Card>

        <p className="mt-4 text-center text-xs text-brand-500">
          Aguarde 1h para receber o seu relatório
        </p>

        <div className="mt-6 space-y-3">
          <Button className="w-full">Voltar à página principal</Button>
          <Button variant="outline" className="w-full">
            Novo Teste
          </Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
