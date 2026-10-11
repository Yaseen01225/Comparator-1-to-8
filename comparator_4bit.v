//==============================================================
// 4-bit Digital Comparator using Bitwise Operations
//==============================================================
// Purpose: Compare two 4-bit unsigned numbers A and B.
//==============================================================

module comparator_4bit (
    input  wire [3:0] A,  // First 4-bit number
    input  wire [3:0] B,  // Second 4-bit number
    output wire GT,       // A is greater than B
    output wire EQ,       // A equals B
    output wire LT        // A is less than B
);

// Identify matching bits.
wire [3:0] equal_bits;
assign equal_bits = ~(A ^ B);

// Compare from the most significant bit, bit 3.
assign GT =
    ( A[3] & ~B[3]) |
    (equal_bits[3] & A[2] & ~B[2]) |
    (equal_bits[3] & equal_bits[2] & A[1] & ~B[1]) |
    (equal_bits[3] & equal_bits[2] & equal_bits[1] & A[0] & ~B[0]);

// Check whether A is less than B.
assign LT =
    (~A[3] & B[3]) |
    (equal_bits[3] & ~A[2] & B[2]) |
    (equal_bits[3] & equal_bits[2] & ~A[1] & B[1]) |
    (equal_bits[3] & equal_bits[2] & equal_bits[1] & ~A[0] & B[0]);

// All four bits must match.
assign EQ = &equal_bits;

endmodule