import { FileText, Share2 } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

const infoRows = [
  { label: "ID do Relatório", value: "OKT-2023-08-15-001" },
  { label: "Nome do Paciente", value: "Ana Silva Santos" },
  { label: "Data do Teste", value: "04/12/2025" },
  { label: "Genes Testados", value: "BRCA1, BRCA2, TP53,..." },
];

const variants = [
  { gene: "BRCA1", variant: "c.5266dupC", classification: "Patogênica" },
  { gene: "TP53", variant: "c.349delT", classification: "Patogênica" },
];

export default function UnidadeResultadoTestePage() {
  return (
    <PageTransition>
      <MobileShell title="ID:Zx78T" icon={<FileText className="h-5 w-5" />} backHref="/unidade/pacientes">
        <p className="text-center text-lg font-semibold text-emerald-500">Positivo</p>
        <Card className="mt-4 p-4">
          <h2 className="text-sm font-semibold text-brand-700">
            Informações Gerais do Relatório
          </h2>
          <div className="mt-3 space-y-2 text-xs text-brand-600">
            {infoRows.map((row) => (
              <div key={row.label} className="flex items-center justify-between">
                <span className="font-semibold text-brand-500">{row.label}</span>
                <span className="text-brand-800">{row.value}</span>
              </div>
            ))}
          </div>
        </Card>

        <div className="mt-4 space-y-4">
          {variants.map((variant) => (
            <Card key={variant.gene} className="p-4">
              <h3 className="text-sm font-semibold text-brand-700">Variáveis Identificadas</h3>
              <div className="mt-3 space-y-2 text-xs text-brand-600">
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">Gene</span>
                  <span className="text-brand-800">{variant.gene}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">Variante</span>
                  <span className="text-brand-800">{variant.variant}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">Classificação</span>
                  <span className="text-brand-800">{variant.classification}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="font-semibold text-brand-500">Significado</span>
                  <span className="text-right text-brand-800">
                    Risco aumentado para cancro da mama e ovário
                  </span>
                </div>
              </div>
            </Card>
          ))}
        </div>

        <div className="mt-4 space-y-3">
          <Button className="w-full">
            <Share2 className="mr-2 h-4 w-4" />
            Enviar para paciente
          </Button>
          <Button variant="outline" className="w-full">
            Voltar
          </Button>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
