import { NextResponse } from "next/server";
import { z } from "zod";
import { requireRole } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

const createTestSchema = z.object({
  healthUnitId: z.string().optional(),
});

export async function GET() {
  try {
    const sessionUser = await requireRole("UTENTE");
    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
    });
    if (!user) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }
    const tests = await prisma.test.findMany({
      where: { patientUserId: user.id },
      include: { healthUnit: true, result: true },
      orderBy: { createdAt: "desc" },
    });
    return NextResponse.json({ tests });
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

export async function POST(request: Request) {
  try {
    const sessionUser = await requireRole("UTENTE");
    const payload = createTestSchema.safeParse(await request.json());
    if (!payload.success) {
      return NextResponse.json({ error: payload.error.flatten() }, { status: 400 });
    }

    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
    });
    if (!user) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }

    let healthUnitId = payload.data.healthUnitId;
    if (!healthUnitId) {
      const fallbackUnit = await prisma.healthUnit.findFirst({
        orderBy: { createdAt: "desc" },
      });
      if (!fallbackUnit) {
        return NextResponse.json({ error: "NO_HEALTH_UNIT" }, { status: 400 });
      }
      healthUnitId = fallbackUnit.id;
    }

    const test = await prisma.test.create({
      data: {
        patientUserId: user.id,
        healthUnitId,
        status: "PENDING",
      },
    });

    return NextResponse.json({ test });
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
