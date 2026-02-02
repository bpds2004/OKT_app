import { FileText } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

export default function TermosPage() {
  return (
    <PageTransition>
      <MobileShell title="Termos e Condições" icon={<FileText className="h-5 w-5" />} backHref="/utente/definicoes">
        <div className="space-y-4 text-sm text-brand-600">
          <h2 className="text-base font-semibold text-brand-800">
            Aceitação dos Termos e Condições
          </h2>
          <p>
            Bem-vindo à aplicação OKT. Ao aceder e utilizar os nossos serviços,
            concorda em ficar vinculado aos seguintes termos e condições. Por
            favor, leia-os atentamente. Se não concordar com qualquer parte
            destes termos, não poderá utilizar os nossos serviços.
          </p>
          <div>
            <p className="font-semibold text-brand-700">1. Utilização da Aplicação</p>
            <p>
              A aplicação OKT (OncoKit Test) destina-se a gerir as suas
              configurações e preferências para uma experiência personalizada.
              É da sua responsabilidade garantir a segurança da sua conta e de
              todas as atividades que nela ocorram.
            </p>
          </div>
          <div>
            <p className="font-semibold text-brand-700">2. Privacidade de Dados</p>
            <p>
              A sua privacidade é crucial para nós. Recolhemos e utilizamos os
              seus dados apenas para melhorar a sua experiência na aplicação e
              fornecer os serviços solicitados.
            </p>
          </div>
          <p className="font-semibold text-brand-700">
            Política de Privacidade completa para mais detalhes sobre como
            recolhemos, usamos e protegemos as suas informações.
          </p>
          <div>
            <p className="font-semibold text-brand-700">3. Segurança da Conta</p>
            <p>
              Compromete-se a manter a confidencialidade da sua palavra-passe e
              a notificar-nos imediatamente sobre qualquer uso não autorizado da
              sua conta.
            </p>
          </div>
          <div>
            <p className="font-semibold text-brand-700">4. Alterações aos Termos</p>
            <p>
              Reservamos o direito de modificar estes termos e condições a
              qualquer momento. As alterações serão comunicadas aos utilizadores.
            </p>
          </div>
        </div>
        <Button className="mt-8 w-full" variant="outline">
          Voltar
        </Button>
      </MobileShell>
    </PageTransition>
  );
}
