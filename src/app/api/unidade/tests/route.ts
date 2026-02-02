import { NextResponse } from "next/server";
import { requireRole } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

export async function GET() {
  try {
    const sessionUser = await requireRole("UNIDADE_SAUDE");
    const user = await prisma.user.findUnique({
      where: { email: sessionUser.email ?? "" },
      include: { unitProfile: true },
    });
    if (!user?.unitProfile) {
      return NextResponse.json({ error: "NOT_FOUND" }, { status: 404 });
    }

    const tests = await prisma.test.findMany({
      where: { healthUnitId: user.unitProfile.healthUnitId },
      include: {
        patient: true,
        result: {
          include: {
            variables: true,
          },
        },
      },
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
