//==============================================================
// 2-bit Digital Comparator using Bitwise Operations
//==============================================================
// Purpose: Compare two 2-bit unsigned numbers A and B.
//==============================================================

module comparator_2bit (
    input  wire [1:0] A,  // First 2-bit number
    input  wire [1:0] B,  // Second 2-bit number
    output wire GT,       // A is greater than B
    output wire EQ,       // A equals B
    output wire LT        // A is less than B
);

// Identify matching bits.
wire [1:0] equal_bits;
assign equal_bits = ~(A ^ B);

// A is greater if the highest differing bit has A = 1, B = 0.
assign GT =
    ( A[1] & ~B[1]) |
    (equal_bits[1] & A[0] & ~B[0]);

// A is less if the highest differing bit has A = 0, B = 1.
assign LT =
    (~A[1] & B[1]) |
    (equal_bits[1] & ~A[0] & B[0]);

// Both bits must match for equality.
assign EQ = &equal_bits;

endmodule