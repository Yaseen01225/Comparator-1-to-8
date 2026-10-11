//==============================================================
// 5-bit Digital Comparator using Bitwise Operations
//==============================================================
// Purpose: Compare two 5-bit unsigned numbers A and B.
//==============================================================

module comparator_5bit (
    input  wire [4:0] A,  // First 5-bit number
    input  wire [4:0] B,  // Second 5-bit number
    output wire GT,       // A is greater than B
    output wire EQ,       // A equals B
    output wire LT        // A is less than B
);

// Identify matching bits.
wire [4:0] equal_bits;
assign equal_bits = ~(A ^ B);

// A is greater at the first differing bit from the top.
assign GT =
    ( A[4] & ~B[4]) |
    (equal_bits[4] & A[3] & ~B[3]) |
    (equal_bits[4] & equal_bits[3] & A[2] & ~B[2]) |
    (equal_bits[4] & equal_bits[3] & equal_bits[2] & A[1] & ~B[1]) |
    (equal_bits[4] & equal_bits[3] & equal_bits[2] & equal_bits[1] & A[0] & ~B[0]);

// A is less at the first differing bit from the top.
assign LT =
    (~A[4] & B[4]) |
    (equal_bits[4] & ~A[3] & B[3]) |
    (equal_bits[4] & equal_bits[3] & ~A[2] & B[2]) |
    (equal_bits[4] & equal_bits[3] & equal_bits[2] & ~A[1] & B[1]) |
    (equal_bits[4] & equal_bits[3] & equal_bits[2] & equal_bits[1] & ~A[0] & B[0]);

// All five bits must match.
assign EQ = &equal_bits;

endmodule