import { BookOpen } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

const steps = [
  {
    number: 1,
    title: "Prepare a Amostra",
    description:
      "Colete a amostra do paciente conforme o protocolo padrão, garantindo a quantidade e a qualidade necessárias para o teste.",
  },
  {
    number: 2,
    title: "Insira no Cartucho",
    description:
      "Com cuidado, transfira a amostra para o cartucho de teste, evitando bolhas de ar ou derramamentos. Certifique-se de que esteja bem encaixado.",
  },
  {
    number: 3,
    title: "Inicie o Dispositivo",
    description:
      "Conecte o cartucho ao dispositivo OKT e pressione o botão 'Iniciar' no painel frontal. O aparelho começará a processar a amostra.",
  },
  {
    number: 4,
    title: "Monitore o Progresso",
    description:
      "Aguarde a conclusão do teste. O dispositivo OKT exibirá o tempo restante e o status do processo na tela.",
  },
];

export default function TutorialPage() {
  return (
    <PageTransition>
      <MobileShell title="Tutorial" icon={<BookOpen className="h-5 w-5" />} backHref="/utente/relatorios">
        <div className="space-y-4">
          {steps.map((step) => (
            <Card key={step.number} className="overflow-hidden">
              <div className="relative">
                <div className="absolute left-4 top-4 flex h-7 w-7 items-center justify-center rounded-full bg-brand-50 text-xs font-semibold text-brand-700">
                  {step.number}
                </div>
                <div className="h-40 w-full bg-gradient-to-br from-brand-50 via-white to-brand-100" />
              </div>
              <div className="px-4 pb-4 pt-3">
                <h3 className="text-sm font-semibold text-brand-700">{step.title}</h3>
                <p className="mt-2 text-xs text-brand-500">{step.description}</p>
              </div>
            </Card>
          ))}
        </div>
        <Button className="mt-6 w-full">Iniciar Teste</Button>
      </MobileShell>
    </PageTransition>
  );
}
