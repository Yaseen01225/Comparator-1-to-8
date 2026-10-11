//==============================================================
// 7-bit Digital Comparator using Bitwise Operations
//==============================================================
// Purpose: Compare two 7-bit unsigned numbers A and B.
//==============================================================

module comparator_7bit (
    input  wire [6:0] A,  // First 7-bit number
    input  wire [6:0] B,  // Second 7-bit number
    output wire GT,       // A is greater than B
    output wire EQ,       // A equals B
    output wire LT        // A is less than B
);

// Identify matching bits.
wire [6:0] equal_bits;
assign equal_bits = ~(A ^ B);

// Check greater-than conditions from bit 6 to bit 0.
assign GT =
    ( A[6] & ~B[6]) |
    (equal_bits[6] & A[5] & ~B[5]) |
    (equal_bits[6] & equal_bits[5] & A[4] & ~B[4]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & A[3] & ~B[3]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & equal_bits[3] & A[2] & ~B[2]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & equal_bits[3] & equal_bits[2] & A[1] & ~B[1]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & equal_bits[3] & equal_bits[2] & equal_bits[1] & A[0] & ~B[0]);

// Check less-than conditions from bit 6 to bit 0.
assign LT =
    (~A[6] & B[6]) |
    (equal_bits[6] & ~A[5] & B[5]) |
    (equal_bits[6] & equal_bits[5] & ~A[4] & B[4]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & ~A[3] & B[3]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & equal_bits[3] & ~A[2] & B[2]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & equal_bits[3] & equal_bits[2] & ~A[1] & B[1]) |
    (equal_bits[6] & equal_bits[5] & equal_bits[4] & equal_bits[3] & equal_bits[2] & equal_bits[1] & ~A[0] & B[0]);

// All seven bits must match.
assign EQ = &equal_bits;

endmodule