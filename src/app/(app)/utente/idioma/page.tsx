"use client";

import { useState } from "react";
import { Globe } from "lucide-react";
import { MobileShell } from "@/components/layout/mobile-shell";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { PageTransition } from "@/components/common/page-transition";

const languages = [
  "Português",
  "English",
  "Español",
  "Français",
  "Deutsch",
  "Italiano",
];

export default function IdiomaPage() {
  const [selected, setSelected] = useState("Português");

  return (
    <PageTransition>
      <MobileShell title="Escolher Idioma" icon={<Globe className="h-5 w-5" />} backHref="/utente/definicoes">
        <Card className="divide-y divide-brand-50">
          {languages.map((language) => (
            <button
              key={language}
              type="button"
              onClick={() => setSelected(language)}
              className="flex w-full items-center justify-between px-4 py-4 text-sm font-semibold text-brand-700"
            >
              {language}
              <span
                className={`h-4 w-4 rounded-full border ${
                  selected === language ? "border-brand-700 bg-brand-700" : "border-brand-200"
                }`}
              />
            </button>
          ))}
        </Card>
        <Button className="mt-6 w-full">Guardar</Button>
      </MobileShell>
    </PageTransition>
  );
}
