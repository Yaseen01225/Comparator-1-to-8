//==============================================================
// 3-bit Digital Comparator using Bitwise Operations
//==============================================================
// Purpose: Compare two 3-bit unsigned numbers A and B.
//==============================================================

module comparator_3bit (
    input  wire [2:0] A,  // First 3-bit number
    input  wire [2:0] B,  // Second 3-bit number
    output wire GT,       // A is greater than B
    output wire EQ,       // A equals B
    output wire LT        // A is less than B
);

// Identify matching bits.
wire [2:0] equal_bits;
assign equal_bits = ~(A ^ B);

// Compare from bit 2 toward bit 0.
assign GT =
    ( A[2] & ~B[2]) |
    (equal_bits[2] & A[1] & ~B[1]) |
    (equal_bits[2] & equal_bits[1] & A[0] & ~B[0]);

// Check whether A is less at the highest differing bit.
assign LT =
    (~A[2] & B[2]) |
    (equal_bits[2] & ~A[1] & B[1]) |
    (equal_bits[2] & equal_bits[1] & ~A[0] & B[0]);

// Equality requires all three bits to match.
assign EQ = &equal_bits;

endmodule