import { NextResponse } from "next/server";
import { z } from "zod";
import { requireRole } from "@/lib/api-auth";
import { prisma } from "@/lib/prisma";

const statusSchema = z.object({
  status: z.enum(["PENDING", "IN_REVIEW", "DONE"]),
});

const nextStatusMap: Record<string, string> = {
  PENDING: "IN_REVIEW",
  IN_REVIEW: "DONE",
};

export async function PATCH(
  request: Request,
  { params }: { params: { id: string } },
) {
  try {
    const sessionUser = await requireRole("UNIDADE_SAUDE");
    const payload = statusSchema.safeParse(await request.json());
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

    const test = await prisma.test.findUnique({ where: { id: params.id } });
    if (!test || test.healthUnitId !== user.unitProfile.healthUnitId) {
      return NextResponse.json({ error: "FORBIDDEN" }, { status: 403 });
    }

    const expectedNext = nextStatusMap[test.status] ?? test.status;
    if (payload.data.status !== expectedNext && payload.data.status !== test.status) {
      return NextResponse.json({ error: "INVALID_STATUS_TRANSITION" }, { status: 400 });
    }

    const updated = await prisma.test.update({
      where: { id: test.id },
      data: { status: payload.data.status },
    });

    return NextResponse.json({ test: updated });
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
