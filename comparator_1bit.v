//==============================================================
// 1-bit Digital Comparator using Bitwise Operations
//==============================================================
// Purpose: Compare two 1-bit unsigned numbers A and B.
// GT = 1 when A > B
// EQ = 1 when A == B
// LT = 1 when A < B
//==============================================================

module comparator_1bit (
    input  wire [0:0] A,  // First 1-bit number
    input  wire [0:0] B,  // Second 1-bit number
    output wire GT,       // A is greater than B
    output wire EQ,       // A equals B
    output wire LT        // A is less than B
);

// A is greater when A = 1 and B = 0.
assign GT = A[0] & ~B[0];

// A is less when A = 0 and B = 1.
assign LT = ~A[0] & B[0];

// A equals B when their XOR result is 0.
assign EQ = ~(A[0] ^ B[0]);

endmodule