import { NextResponse } from "next/server";
import { z } from "zod";
import { requireRole } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

const resultSchema = z.object({
  summary: z.string().min(5),
  riskLevel: z.enum(["BAIXO", "MEDIO", "ALTO"]),
  variables: z
    .array(
      z.object({
        name: z.string().min(2),
        significance: z.string().min(2),
        recommendation: z.string().min(2),
      }),
    )
    .default([]),
});

export async function POST(
  request: Request,
  { params }: { params: { id: string } },
) {
  try {
    const sessionUser = await requireRole("UNIDADE_SAUDE");
    const payload = resultSchema.safeParse(await request.json());
    if (!payload.success) {
      return NextResponse.json({ error: payload.error.flatten() }, { status: 400 });
    }

    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
      include: { unitProfile: true },
    });
    if (!user?.unitProfile) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }

    const test = await prisma.test.findUnique({
      where: { id: params.id },
      include: { result: true },
    });
    if (!test || test.healthUnitId !== user.unitProfile.healthUnitId) {
      return NextResponse.json({ error: "FORBIDDEN" }, { status: 403 });
    }
    if (test.result) {
      return NextResponse.json({ error: "RESULT_EXISTS" }, { status: 400 });
    }

    const result = await prisma.testResult.create({
      data: {
        testId: test.id,
        summary: payload.data.summary,
        riskLevel: payload.data.riskLevel,
        variables: {
          create: payload.data.variables.map((variable) => ({
            name: variable.name,
            significance: variable.significance,
            recommendation: variable.recommendation,
          })),
        },
      },
      include: { variables: true },
    });

    await prisma.test.update({
      where: { id: test.id },
      data: { status: "DONE" },
    });

    return NextResponse.json({ result });
  } catch (error) {
    if (error instanceof Error && error.message === "UNAUTHORIZED") {
      return NextResponse.json({ error: "UNAUTHORIZED" }, { status: 401 });
    }
    if (error instanceof Error && error.message === "FORBIDDEN") {
      return NextResponse.json({ error: "FORBIDDEN" }, { status: 403 });
    }
    return NextResponse.json({ error: "SERVER_ERROR" }, { status: 500 });
  }
}
