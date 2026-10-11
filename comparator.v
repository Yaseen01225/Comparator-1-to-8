//======================================================
// Digital Comparator (1-bit to 8-bit)
//======================================================
// Purpose:
//   Compare two unsigned binary numbers A and B.
//
// Outputs:
//   GT = 1 when A is greater than B.
//   EQ = 1 when A is equal to B.
//   LT = 1 when A is less than B.
//
// Supported parameter values:
//   N = 1, 2, 3, 4, 5, 6, 7, or 8.
//
// Comparison method:
//   Use bitwise operations to compare the numbers.
//   Check the most significant bit before lower bits.
//======================================================

module comparator #(parameter N = 4) (

    input wire [N-1:0] A,   // First binary number, containing N bits.
    input wire [N-1:0] B,   // Second binary number, containing N bits.

    output wire GT,         // Becomes 1 when A is greater than B.
    output wire EQ,         // Becomes 1 when A and B are equal.
    output wire LT          // Becomes 1 when A is less than B.

);

//======================================================
// Internal wires
//======================================================

// This wire stores the equality result for every bit.
// equal_bits[i] is 1 when A[i] and B[i] are the same.
// XOR gives 0 for matching bits, so NOT XOR gives 1.
// Example: A[i]=1, B[i]=1 -> equal_bits[i]=1.
wire [N-1:0] equal_bits;

// Compare each bit of A with the corresponding bit of B.
// XOR identifies different bits, and NOT reverses the result.
assign equal_bits = ~(A ^ B);

//======================================================
// Select the correct circuit for the chosen width
//======================================================

generate

    //==================================================
    // 1-bit comparator
    //==================================================
    if (N == 1) begin : COMP_1

        // A is greater when A is 1 and B is 0.
        assign GT = A[0] & ~B[0];

        // A is less when A is 0 and B is 1.
        assign LT = ~A[0] & B[0];

        // A and B are equal when their only bits match.
        assign EQ = equal_bits[0];

    end

    //==================================================
    // 2-bit comparator
    //==================================================
    else if (N == 2) begin : COMP_2

        // A is greater if its highest bit is greater.
        // If the highest bits match, compare the lowest bits.
        assign GT =
            ( A[1] & ~B[1]) |
            (equal_bits[1] & A[0] & ~B[0]);

        // A is less if its highest bit is smaller.
        // If the highest bits match, compare the lowest bits.
        assign LT =
            (~A[1] & B[1]) |
            (equal_bits[1] & ~A[0] & B[0]);

        // A and B are equal only when both bits match.
        // The AND reduction checks all bits at once.
        assign EQ = &equal_bits;

    end

    //==================================================
    // 3-bit comparator
    //==================================================
    else if (N == 3) begin : COMP_3

        // Case 1: Bit 2 decides that A is greater.
        // Case 2: Bit 2 matches, and bit 1 decides.
        // Case 3: Bits 2 and 1 match, and bit 0 decides.
        assign GT =
            ( A[2] & ~B[2]) |
            (equal_bits[2] & A[1] & ~B[1]) |
            (equal_bits[2] & equal_bits[1] &
              A[0] & ~B[0]);

        // Apply the same comparison in the opposite direction.
        // The first differing bit must have A=0 and B=1.
        assign LT =
            (~A[2] & B[2]) |
            (equal_bits[2] & ~A[1] & B[1]) |
            (equal_bits[2] & equal_bits[1] &
             ~A[0] & B[0]);

        // All three bits must match for equality.
        assign EQ = &equal_bits;

    end

    //==================================================
    // 4-bit comparator
    //==================================================
    else if (N == 4) begin : COMP_4

        // Check bit 3 first, then bits 2, 1, and 0.
        // A lower bit matters only when every higher bit matches.
        assign GT =
            ( A[3] & ~B[3]) |
            (equal_bits[3] & A[2] & ~B[2]) |
            (equal_bits[3] & equal_bits[2] &
              A[1] & ~B[1]) |
            (equal_bits[3] & equal_bits[2] &
             equal_bits[1] & A[0] & ~B[0]);

        // Check the same bit positions for A being smaller.
        assign LT =
            (~A[3] & B[3]) |
            (equal_bits[3] & ~A[2] & B[2]) |
            (equal_bits[3] & equal_bits[2] &
             ~A[1] & B[1]) |
            (equal_bits[3] & equal_bits[2] &
             equal_bits[1] & ~A[0] & B[0]);

        // Equality requires every bit to match.
        assign EQ = &equal_bits;

    end

    //==================================================
    // 5-bit comparator
    //==================================================
    else if (N == 5) begin : COMP_5

        // Compare from the most significant bit, bit 4.
        // Continue to a lower bit only when higher bits match.
        assign GT =
            ( A[4] & ~B[4]) |
            (equal_bits[4] & A[3] & ~B[3]) |
            (equal_bits[4] & equal_bits[3] &
              A[2] & ~B[2]) |
            (equal_bits[4] & equal_bits[3] & equal_bits[2] &
              A[1] & ~B[1]) |
            (equal_bits[4] & equal_bits[3] & equal_bits[2] &
             equal_bits[1] & A[0] & ~B[0]);

        // Reverse the bit comparison to detect A being smaller.
        assign LT =
            (~A[4] & B[4]) |
            (equal_bits[4] & ~A[3] & B[3]) |
            (equal_bits[4] & equal_bits[3] &
             ~A[2] & B[2]) |
            (equal_bits[4] & equal_bits[3] & equal_bits[2] &
             ~A[1] & B[1]) |
            (equal_bits[4] & equal_bits[3] & equal_bits[2] &
             equal_bits[1] & ~A[0] & B[0]);

        // Equality is true only if all five bits match.
        assign EQ = &equal_bits;

    end

    //==================================================
    // 6-bit comparator
    //==================================================
    else if (N == 6) begin : COMP_6

        // Check bits 5 down to 0 for the first difference.
        // A greater result is produced when A has 1 and B has 0
        // at that first differing bit.
        assign GT =
            ( A[5] & ~B[5]) |
            (equal_bits[5] & A[4] & ~B[4]) |
            (equal_bits[5] & equal_bits[4] &
              A[3] & ~B[3]) |
            (equal_bits[5] & equal_bits[4] & equal_bits[3] &
              A[2] & ~B[2]) |
            (equal_bits[5] & equal_bits[4] & equal_bits[3] &
             equal_bits[2] & A[1] & ~B[1]) |
            (equal_bits[5] & equal_bits[4] & equal_bits[3] &
             equal_bits[2] & equal_bits[1] & A[0] & ~B[0]);

        // A smaller result is produced when A has 0 and B has 1
        // at the first differing bit.
        assign LT =
            (~A[5] & B[5]) |
            (equal_bits[5] & ~A[4] & B[4]) |
            (equal_bits[5] & equal_bits[4] &
             ~A[3] & B[3]) |
            (equal_bits[5] & equal_bits[4] & equal_bits[3] &
             ~A[2] & B[2]) |
            (equal_bits[5] & equal_bits[4] & equal_bits[3] &
             equal_bits[2] & ~A[1] & B[1]) |
            (equal_bits[5] & equal_bits[4] & equal_bits[3] &
             equal_bits[2] & equal_bits[1] & ~A[0] & B[0]);

        // Equality is true only if all six bits match.
        assign EQ = &equal_bits;

    end

    //==================================================
    // 7-bit comparator
    //==================================================
    else if (N == 7) begin : COMP_7

        // Check bits 6 down to 0.
        // Each lower-bit condition is enabled only when all
        // higher bits are equal.
        assign GT =
            ( A[6] & ~B[6]) |
            (equal_bits[6] & A[5] & ~B[5]) |
            (equal_bits[6] & equal_bits[5] &
              A[4] & ~B[4]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
              A[3] & ~B[3]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             equal_bits[3] & A[2] & ~B[2]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             equal_bits[3] & equal_bits[2] & A[1] & ~B[1]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             equal_bits[3] & equal_bits[2] & equal_bits[1] &
             A[0] & ~B[0]);

        // Check the same bit positions for A being smaller.
        assign LT =
            (~A[6] & B[6]) |
            (equal_bits[6] & ~A[5] & B[5]) |
            (equal_bits[6] & equal_bits[5] &
             ~A[4] & B[4]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             ~A[3] & B[3]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             equal_bits[3] & ~A[2] & B[2]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             equal_bits[3] & equal_bits[2] & ~A[1] & B[1]) |
            (equal_bits[6] & equal_bits[5] & equal_bits[4] &
             equal_bits[3] & equal_bits[2] & equal_bits[1] &
             ~A[0] & B[0]);

        // Equality is true only if all seven bits match.
        assign EQ = &equal_bits;

    end

    //==================================================
    // 8-bit comparator
    //==================================================
    else if (N == 8) begin : COMP_8

        // Check bits 7 down to 0.
        // A greater result occurs when the first differing bit
        // has A=1 and B=0.
        assign GT =
            ( A[7] & ~B[7]) |
            (equal_bits[7] & A[6] & ~B[6]) |
            (equal_bits[7] & equal_bits[6] &
              A[5] & ~B[5]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
              A[4] & ~B[4]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & A[3] & ~B[3]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & equal_bits[3] & A[2] & ~B[2]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & equal_bits[3] & equal_bits[2] &
             A[1] & ~B[1]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & equal_bits[3] & equal_bits[2] &
             equal_bits[1] & A[0] & ~B[0]);

        // A smaller result occurs when the first differing bit
        // has A=0 and B=1.
        assign LT =
            (~A[7] & B[7]) |
            (equal_bits[7] & ~A[6] & B[6]) |
            (equal_bits[7] & equal_bits[6] &
             ~A[5] & B[5]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             ~A[4] & B[4]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & ~A[3] & B[3]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & equal_bits[3] & ~A[2] & B[2]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & equal_bits[3] & equal_bits[2] &
             ~A[1] & B[1]) |
            (equal_bits[7] & equal_bits[6] & equal_bits[5] &
             equal_bits[4] & equal_bits[3] & equal_bits[2] &
             equal_bits[1] & ~A[0] & B[0]);

        // Equality is true only if all eight bits match.
        assign EQ = &equal_bits;

    end

    //==================================================
    // Unsupported parameter value
    //==================================================
    else begin : INVALID_WIDTH

        // Report an error during simulation if N is outside 1 to 8.
        initial begin
            $error("Comparator supports N from 1 to 8 only.");
        end

    end

endgenerate

endmodule