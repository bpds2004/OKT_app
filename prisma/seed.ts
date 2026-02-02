import { hash } from "bcryptjs";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const passwordHash = await hash("Password123!", 10);

  const healthUnit = await prisma.healthUnit.create({
    data: {
      name: "Unidade Central",
      address: "Rua Principal, 100, Lisboa",
      code: "UNIT-001",
    },
  });

  const unitUser = await prisma.user.create({
    data: {
      email: "unidade@example.com",
      passwordHash,
      role: "UNIDADE_SAUDE",
      name: "Unidade Central",
      unitProfile: {
        create: {
          healthUnitId: healthUnit.id,
        },
      },
    },
  });

  const patientUser = await prisma.user.create({
    data: {
      email: "utente@example.com",
      passwordHash,
      role: "UTENTE",
      name: "Utente Exemplo",
      patientProfile: {
        create: {
          phone: "+351 910 000 000",
          nif: "123456789",
          birthDate: new Date("1990-05-15"),
        },
      },
    },
  });

  const test = await prisma.test.create({
    data: {
      patientUserId: patientUser.id,
      healthUnitId: healthUnit.id,
      status: "DONE",
    },
  });

  await prisma.testResult.create({
    data: {
      testId: test.id,
      summary: "Resultado de risco moderado com recomendações preventivas.",
      riskLevel: "MEDIO",
      variables: {
        create: [
          {
            name: "BRCA1",
            significance: "Mutação moderada",
            recommendation: "Consulta com especialista em genética.",
          },
        ],
      },
    },
  });

  await prisma.notification.create({
    data: {
      userId: patientUser.id,
      title: "Novo relatório disponível",
      message: "O seu relatório foi atualizado com novos resultados.",
      read: false,
    },
  });

  await prisma.notification.create({
    data: {
      userId: unitUser.id,
      title: "Teste concluído",
      message: "Um teste foi concluído para revisão clínica.",
      read: false,
    },
  });
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
