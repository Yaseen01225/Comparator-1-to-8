`timescale 1ns/1ps

//==============================================================
// Project     : Digital Logic Design
// Module      : Digital Comparator Testbench
// File Name   : comparator_tb.v
// Date        : 11 October 2026
// Description : Tests an N-bit unsigned digital comparator.
// Author      : Ghulam Yaseen Nangraj
//==============================================================
//
// PURPOSE:
//   Verify that the comparator correctly compares inputs A and B.
//
// INPUTS:
//   A : First unsigned binary number.
//   B : Second unsigned binary number.
//
// OUTPUTS:
//   GT = 1 when A is greater than B.
//   EQ = 1 when A is equal to B.
//   LT = 1 when A is less than B.
//
// TEST CASES:
//   1. Both inputs are zero.
//   2. A is greater than B.
//   3. A is less than B.
//   4. Both inputs are equal.
//   5. Maximum input value compared with zero.
//   6. A is one greater than B.
//   7. A is one less than B.
//   8. Compare two small values.
//   9. Equal inputs at the maximum value.
//  10. Compare two middle-range values.
//
// NOTE:
//   Change N to test different comparator widths.
//   Supported widths are N = 1 through N = 8.
//==============================================================

module comparator_tb;

//--------------------------------------------------------------
// Parameter Configuration
//--------------------------------------------------------------

// Select the number of bits used by the comparator.
// Example: N=2 tests 2-bit numbers; N=8 tests 8-bit numbers.
parameter N = 4;

//--------------------------------------------------------------
// Testbench Signals
//--------------------------------------------------------------

// Register used to apply the first input to the comparator.
reg [N-1:0] A;

// Register used to apply the second input to the comparator.
reg [N-1:0] B;

// Wire that receives 1 when A is greater than B.
wire GT;

// Wire that receives 1 when A is equal to B.
wire EQ;

// Wire that receives 1 when A is less than B.
wire LT;

//--------------------------------------------------------------
// Unit Under Test (UUT) / Device Under Test (DUT)
//--------------------------------------------------------------

// Create an instance of the comparator.
// Pass N to the comparator so its input width matches this testbench.
comparator #(N) DUT (
    .A(A),
    .B(B),
    .GT(GT),
    .EQ(EQ),
    .LT(LT)
);

//--------------------------------------------------------------
// Task: Display the Comparison Results
//--------------------------------------------------------------

// This task prints the input values and comparator outputs.
// The %0d format displays decimal values without extra padding.
// The %b format displays the inputs and outputs in binary.
task print_result;
    input [N-1:0] a;
    input [N-1:0] b;

    begin
        $display(
            "A=%0d (%b), B=%0d (%b) | GT=%b EQ=%b LT=%b",
            a, a, b, b, GT, EQ, LT
        );
    end
endtask

//--------------------------------------------------------------
// Main Test Sequence
//--------------------------------------------------------------

initial begin

    // Display the testbench heading.
    $display("");
    $display("==================================================");
    $display("          DIGITAL COMPARATOR TESTBENCH");
    $display("==================================================");

    // Display the selected comparator width.
    $display("Date              : 11 October 2026");
    $display("Comparator Width  : N = %0d bits", N);
    $display("Maximum Input     : %0d", (2**N)-1);

    // Display the output column headings.
    $display("--------------------------------------------------");
    $display(" A (decimal/binary)   B (decimal/binary)   GT EQ LT");
    $display("--------------------------------------------------");

    //----------------------------------------------------------
    // Test 1: Both inputs are zero
    //----------------------------------------------------------

    // Expected result: A equals B.
    A = {N{1'b0}};
    B = {N{1'b0}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 2: A is greater than B
    //----------------------------------------------------------

    // Set A to the maximum value and B to zero.
    // Expected result: GT=1.
    A = {N{1'b1}};
    B = {N{1'b0}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 3: A is less than B
    //----------------------------------------------------------

    // Set A to zero and B to the maximum value.
    // Expected result: LT=1.
    A = {N{1'b0}};
    B = {N{1'b1}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 4: Both inputs are equal
    //----------------------------------------------------------

    // Apply the same alternating bit pattern to both inputs.
    // The replication expression keeps the pattern within N bits.
    A = {N{2'b10}};
    B = {N{2'b10}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 5: Maximum value compared with zero
    //----------------------------------------------------------

    // All bits of A are 1 and all bits of B are 0.
    // Expected result: GT=1.
    A = {N{1'b1}};
    B = {N{1'b0}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 6: A is one greater than B
    //----------------------------------------------------------

    // Compare the maximum value with the value immediately below it.
    // Expected result: GT=1.
    A = {N{1'b1}};
    B = (2**N)-2;
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 7: A is one less than B
    //----------------------------------------------------------

    // Compare the value immediately below the maximum with the maximum.
    // Expected result: LT=1.
    A = (2**N)-2;
    B = {N{1'b1}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 8: Compare two small values
    //----------------------------------------------------------

    // For N >= 2, compare 1 and 2.
    // For N = 1, use 0 and 1 because 2 cannot be represented.
    if (N >= 2) begin
        A = 1;
        B = 2;
    end
    else begin
        A = 0;
        B = 1;
    end

    // Expected result: LT=1.
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 9: Equal inputs at the maximum value
    //----------------------------------------------------------

    // Both inputs contain all 1s.
    // Expected result: EQ=1.
    A = {N{1'b1}};
    B = {N{1'b1}};
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // Test 10: Compare two middle-range values
    //----------------------------------------------------------

    // Compare approximately one-quarter of the range
    // against approximately three-quarters of the range.
    // Expected result: LT=1.
    A = (2**N)/4;
    B = (3*(2**N))/4;
    #10;
    print_result(A, B);

    //----------------------------------------------------------
    // End of Test Sequence
    //----------------------------------------------------------

    // Print a message to show that all tests have completed.
    $display("--------------------------------------------------");
    $display("All test cases completed.");
    $display("==================================================");

    // Stop the simulation.
    $finish;

end

endmodule