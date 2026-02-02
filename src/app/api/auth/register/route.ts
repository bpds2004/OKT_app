import { NextResponse } from "next/server";
import { z } from "zod";
import { supabaseAdmin } from "@/lib/supabase/server";

const registerSchema = z.object({
  role: z.enum(["UTENTE", "UNIDADE_SAUDE"]),
  name: z.string().min(1),
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
  const { data: existing } = await supabaseAdmin.auth.admin.getUserByEmail(data.email);
  if (existing?.user) {
    return NextResponse.json({ error: "EMAIL_EXISTS" }, { status: 409 });
  }

  const { data: createdUser, error: createError } =
    await supabaseAdmin.auth.admin.createUser({
      email: data.email,
      password: data.password,
      email_confirm: true,
    });

  if (createError || !createdUser.user) {
    return NextResponse.json({ error: "CREATE_FAILED" }, { status: 500 });
  }

  const userId = createdUser.user.id;

  const { error: profileError } = await supabaseAdmin.from("profiles").insert({
    id: userId,
    role: data.role,
    name: data.name,
  });

  if (profileError) {
    return NextResponse.json({ error: "PROFILE_FAILED" }, { status: 500 });
  }

  if (data.role === "UTENTE") {
    const { error: patientError } = await supabaseAdmin.from("patient_profiles").insert({
      user_id: userId,
      phone: data.phone || null,
      nif: data.nif || null,
      birth_date: data.birthDate ? new Date(data.birthDate).toISOString() : null,
      address: data.address || null,
      health_number: data.healthNumber || null,
    });

    if (patientError) {
      return NextResponse.json({ error: "PATIENT_PROFILE_FAILED" }, { status: 500 });
    }
  }

  if (data.role === "UNIDADE_SAUDE") {
    const unitCode = data.healthUnitCode || "";
    const { data: unitMatch, error: unitFetchError } = await supabaseAdmin
      .from("health_units")
      .select("id")
      .eq("code", unitCode)
      .maybeSingle();

    if (unitFetchError) {
      return NextResponse.json({ error: "UNIT_LOOKUP_FAILED" }, { status: 500 });
    }

    let healthUnitId = unitMatch?.id;
    if (!healthUnitId) {
      const { data: createdUnit, error: unitCreateError } = await supabaseAdmin
        .from("health_units")
        .insert({
          name: data.healthUnitName || data.name,
          address: data.healthUnitAddress || null,
          code: unitCode,
        })
        .select("id")
        .single();

      if (unitCreateError || !createdUnit) {
        return NextResponse.json({ error: "UNIT_CREATE_FAILED" }, { status: 500 });
      }
      healthUnitId = createdUnit.id;
    }

    const { error: unitProfileError } = await supabaseAdmin.from("unit_profiles").insert({
      user_id: userId,
      health_unit_id: healthUnitId,
    });

    if (unitProfileError) {
      return NextResponse.json({ error: "UNIT_PROFILE_FAILED" }, { status: 500 });
    }
  }

  return NextResponse.json({ id: userId });
}
