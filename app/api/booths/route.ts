import { NextRequest, NextResponse } from "next/server";
import { supabase } from "@/lib/supabase"; // ✅ FIX

// GET all booths
export async function GET(req: NextRequest) {
  try {
    const { data, error } = await supabase
      .from("booths")
      .select("*")
      .order("booth_name", { ascending: true });

    if (error) throw error;

    return NextResponse.json(data);
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 500 }
    );
  }
}

// POST new booth
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    if (!body?.booth_name) {
      return NextResponse.json(
        { error: "booth_name is required" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("booths")
      .insert([body])
      .select();

    if (error) throw error;

    return NextResponse.json(data[0], { status: 201 });
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 400 }
    );
  }
}