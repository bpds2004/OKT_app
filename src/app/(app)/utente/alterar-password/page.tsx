"use client";

import { Shield } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageTransition } from "@/components/common/page-transition";

const requirements = [
  "Pelo menos 8 caracteres",
  "Pelo menos uma letra maiúscula",
  "Pelo menos uma letra minúscula",
  "Pelo menos um número",
  "Pelo menos um caractere especial",
];

export default function AlterarPasswordPage() {
  return (
    <PageTransition>
      <MobileShell
        title="Alterar Password"
        icon={<Shield className="h-5 w-5" />}
        backHref="/utente/definicoes"
      >
        <div className="space-y-4">
          <div>
            <label className="text-sm font-semibold text-brand-700">
              Palavra-passe atual
            </label>
            <Input placeholder="Insira a sua palavra-passe atual" className="mt-2" />
          </div>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              Nova palavra-passe
            </label>
            <Input placeholder="Insira a nova palavra-passe" className="mt-2" />
          </div>
          <Card className="bg-brand-50 px-4 py-4">
            <p className="text-xs font-semibold text-brand-500">A palavra-passe deve conter:</p>
            <ul className="mt-3 space-y-2 text-xs text-brand-500">
              {requirements.map((item) => (
                <li key={item} className="flex items-center gap-2">
                  <span className="flex h-4 w-4 items-center justify-center rounded-full border border-brand-200 text-[10px]">
                    ✕
                  </span>
                  {item}
                </li>
              ))}
            </ul>
          </Card>
          <div>
            <label className="text-sm font-semibold text-brand-700">
              Confirmar nova palavra-passe
            </label>
            <Input placeholder="Confirme a nova palavra-passe" className="mt-2" />
          </div>
          <div className="space-y-3 pt-4">
            <Button className="w-full">Guardar</Button>
            <Button className="w-full" variant="outline">
              Cancelar
            </Button>
          </div>
        </div>
      </MobileShell>
    </PageTransition>
  );
}
