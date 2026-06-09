import { supabase } from "@/lib/supabase"; // ✅ FIXED
import { NextRequest, NextResponse } from "next/server";

// GET all voters
export async function GET(req: NextRequest) {
  try {
    const searchParams = req.nextUrl.searchParams;
    const boothId = searchParams.get("booth_id");
    const hasVoted = searchParams.get("has_voted");

    let query = supabase.from("voters").select("*");

    if (boothId) {
      query = query.eq("booth_id", boothId);
    }

    if (hasVoted !== null) {
      query = query.eq("has_voted", hasVoted === "true");
    }

    const { data, error } = await query;

    if (error) throw error;

    return NextResponse.json(data);
  } catch (error: any) {
    return NextResponse.json(
      { error: error.message },
      { status: 500 }
    );
  }
}

// POST new voter
export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    if (!body?.name) {
      return NextResponse.json(
        { error: "Voter name is required" },
        { status: 400 }
      );
    }

    const { data, error } = await supabase
      .from("voters")
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