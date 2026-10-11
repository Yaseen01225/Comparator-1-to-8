//======================================================
// Digital Comparator (n-bit)
// Compares two n-bit binary numbers A and B.
// Outputs:
// GT = 1 when A > B
// EQ = 1 when A == B
// LT = 1 when A < B
//======================================================

module comparator #(parameter N = 4) (
    input  wire [N-1:0] A,   // First number
    input  wire [N-1:0] B,   // Second number

    output wire GT,          // A > B
    output wire EQ,          // A == B
    output wire LT           // A < B
);

// Internal wires for comparison results
wire greater, less, equal;
if(N==1)
begin
    // A is greater when A = 1 and B = 0.
    assign GT = A[0] & ~B[0];

    // A is less when A = 0 and B = 1.
    assign LT = ~A[0] & B[0];

    // A equals B when their XOR result is 0.
    assign EQ = ~(A[0] ^ B[0]);
end
else if (N == 2)
begin
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
   end
else
begin
    // A is greater than B
    assign greater = (A > B);
    
    // A is less than B
    assign less = (A < B);
    
    // A is equal to B
    assign equal = (A == B);
end
// Drive outputs
assign GT = greater;
assign LT = less;
assign EQ = equal;

endmodule