import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase";

// GET single booth using booth_code
export async function GET(
  req: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await context.params;

    const { data, error } = await supabase
      .from("booths")
      .select("*")
      .eq("booth_code", id) // ✅ using booth_code instead of UUID
      .maybeSingle();

    if (error) throw error;

    if (!data) {
      return NextResponse.json(
        { error: "Booth not found" },
        { status: 404 }
      );
    }

    return NextResponse.json(data);
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 500 }
    );
  }
}

// UPDATE booth using booth_code
export async function PUT(
  req: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await context.params;
    const body = await req.json();

    const { data, error } = await supabase
      .from("booths")
      .update(body)
      .eq("booth_code", id) // ✅ using booth_code
      .select()
      .maybeSingle();

    if (error) throw error;

    return NextResponse.json(data);
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 400 }
    );
  }
}

// DELETE booth using booth_code
export async function DELETE(
  req: NextRequest,
  context: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await context.params;

    const { error } = await supabase
      .from("booths")
      .delete()
      .eq("booth_code", id); // ✅ using booth_code

    if (error) throw error;

    return NextResponse.json({ message: "Booth deleted successfully" });
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 400 }
    );
  }
}