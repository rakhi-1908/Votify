import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase"; // ✅ correct path

// UPDATE alert (resolve)
export async function PUT(
  req: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await context.params; // ✅ FIX
    const body = await req.json();

    const { data, error } = await supabase
      .from("alerts")
      .update({
        is_resolved: body.is_resolved,
        resolved_at: body.is_resolved ? new Date() : null,
        resolved_by: body.resolved_by,
      })
      .eq("id", id) // ✅ use id
      .select()
      .single();

    if (error) throw error;

    return NextResponse.json(data);
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 400 }
    );
  }
}