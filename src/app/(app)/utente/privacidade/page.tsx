"use client";

import { useState } from "react";
import { ShieldCheck } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Switch } from "@/components/ui/switch";
import { PageTransition } from "@/components/common/page-transition";

export default function PrivacidadePage() {
  const [shareData, setShareData] = useState(true);
  const [anonymousData, setAnonymousData] = useState(false);

  return (
    <PageTransition>
      <MobileShell title="Privacidade" icon={<ShieldCheck className="h-5 w-5" />} backHref="/utente/definicoes">
        <Card className="p-4">
          <h2 className="text-sm font-semibold text-brand-700">
            Como usamos os seus dados
          </h2>
          <p className="mt-2 text-xs text-brand-500">
            Valorizamos a sua privacidade. Esta secção explica como os seus dados
            são recolhidos, usados e partilhados no âmbito da aplicação OKT.
          </p>
          <p className="mt-3 text-xs text-brand-500">
            Utilizamos os seus dados para melhorar a sua experiência, personalizar
            o conteúdo e fornecer funcionalidades essenciais. Nunca vendemos os
            seus dados a terceiros.
          </p>
          <p className="mt-3 text-xs text-brand-500">
            Tem controlo total sobre as suas preferências de privacidade abaixo.
          </p>
        </Card>

        <div className="mt-4 space-y-3">
          <Card className="flex items-center justify-between px-4 py-4">
            <div>
              <p className="text-sm font-semibold text-brand-700">
                Partilhar dados com terceiros
              </p>
              <p className="mt-1 text-xs text-brand-500">
                Permitir que a aplicação partilhe dados anonimizados com
                parceiros para serviços melhorados.
              </p>
            </div>
            <Switch checked={shareData} onCheckedChange={setShareData} />
          </Card>
          <Card className="flex items-center justify-between px-4 py-4">
            <div>
              <p className="text-sm font-semibold text-brand-700">
                Análises anónimas
              </p>
              <p className="mt-1 text-xs text-brand-500">
                Contribuir com dados anónimos sobre a utilização da aplicação
                para nos ajudar a melhorar o serviço.
              </p>
            </div>
            <Switch checked={anonymousData} onCheckedChange={setAnonymousData} />
          </Card>
        </div>

        <button className="mt-6 text-sm font-semibold text-brand-600">
          Ver política de privacidade completa
        </button>
      </MobileShell>
    </PageTransition>
  );
}
