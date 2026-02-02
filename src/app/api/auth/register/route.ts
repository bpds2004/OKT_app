import { NextResponse } from "next/server";
import { z } from "zod";
import { hash } from "bcryptjs";
import { prisma } from "@/lib/prisma";

const registerSchema = z.object({
  role: z.enum(["UTENTE", "UNIDADE_SAUDE"]),
  name: z.string().min(2),
  email: z.string().email(),
  password: z.string().min(6),
  phone: z.string().optional(),
  nif: z.string().optional(),
  birthDate: z.string().optional(),
  address: z.string().optional(),
  healthNumber: z.string().optional(),
  healthUnitName: z.string().optional(),
  healthUnitAddress: z.string().optional(),
  healthUnitCode: z.string().optional(),
});

export async function POST(request: Request) {
  const payload = registerSchema.safeParse(await request.json());
  if (!payload.success) {
    return NextResponse.json({ error: payload.error.flatten() }, { status: 400 });
  }

  const data = payload.data;
  const existingUser = await prisma.user.findUnique({ where: { email: data.email } });
  if (existingUser) {
    return NextResponse.json({ error: "EMAIL_EXISTS" }, { status: 409 });
  }

  const passwordHash = await hash(data.password, 10);

  if (data.role === "UTENTE") {
    const birthDate =
      data.birthDate && data.birthDate.trim() !== ""
        ? new Date(data.birthDate)
        : undefined;
    const user = await prisma.user.create({
      data: {
        email: data.email,
        passwordHash,
        role: "UTENTE",
        name: data.name,
        patientProfile: {
          create: {
            phone: data.phone,
            nif: data.nif,
            birthDate,
            address: data.address,
            healthNumber: data.healthNumber,
          },
        },
      },
    });

    return NextResponse.json({ id: user.id });
  }

  if (!data.healthUnitName || !data.healthUnitAddress || !data.healthUnitCode) {
    return NextResponse.json({ error: "HEALTH_UNIT_REQUIRED" }, { status: 400 });
  }

  const healthUnit = await prisma.healthUnit.upsert({
    where: { code: data.healthUnitCode },
    update: {
      name: data.healthUnitName,
      address: data.healthUnitAddress,
    },
    create: {
      name: data.healthUnitName,
      address: data.healthUnitAddress,
      code: data.healthUnitCode,
    },
  });

  const user = await prisma.user.create({
    data: {
      email: data.email,
      passwordHash,
      role: "UNIDADE_SAUDE",
      name: data.name,
      unitProfile: {
        create: {
          healthUnitId: healthUnit.id,
        },
      },
    },
  });

  return NextResponse.json({ id: user.id });
}
