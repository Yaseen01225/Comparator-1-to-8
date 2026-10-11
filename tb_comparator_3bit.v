`timescale 1ns / 1ps

//======================================================
// Testbench: 3-Bit Magnitude Comparator
// No for loops used
//======================================================

module tb_comparator_3bit;

    // Step 1: Declare input registers
    reg [2:0] A;
    reg [2:0] B;

    // Step 2: Declare output wires
    wire A_gt_B;
    wire A_eq_B;
    wire A_lt_B;

    // Step 3: Instantiate the Design Under Test (DUT)
    comparator_3bit DUT (
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_eq_B(A_eq_B),
        .A_lt_B(A_lt_B)
    );

    // Step 4: Task to check one input combination
    task check_result;
        input [2:0] test_A;
        input [2:0] test_B;
        begin
            A = test_A;
            B = test_B;

            // Allow time for outputs to settle
            #10;

            // Verify all three outputs
            if ((A_gt_B !== (test_A > test_B)) ||
                (A_eq_B !== (test_A == test_B)) ||
                (A_lt_B !== (test_A < test_B))) begin

                $display("FAIL: A=%b B=%b GT=%b EQ=%b LT=%b",
                         A, B, A_gt_B, A_eq_B, A_lt_B);
            end
            else begin
                $display("PASS: A=%b B=%b GT=%b EQ=%b LT=%b",
                         A, B, A_gt_B, A_eq_B, A_lt_B);
            end
        end
    endtask

    // Step 5: Apply test cases explicitly
    initial begin

        $display("===== 3-BIT COMPARATOR TEST =====");

        // A = 000
        check_result(3'b000, 3'b000);
        check_result(3'b000, 3'b001);
        check_result(3'b000, 3'b010);
        check_result(3'b000, 3'b011);
        check_result(3'b000, 3'b100);
        check_result(3'b000, 3'b101);
        check_result(3'b000, 3'b110);
        check_result(3'b000, 3'b111);

        // A = 001
        check_result(3'b001, 3'b000);
        check_result(3'b001, 3'b001);
        check_result(3'b001, 3'b010);
        check_result(3'b001, 3'b011);
        check_result(3'b001, 3'b100);
        check_result(3'b001, 3'b101);
        check_result(3'b001, 3'b110);
        check_result(3'b001, 3'b111);

        // A = 010
        check_result(3'b010, 3'b000);
        check_result(3'b010, 3'b001);
        check_result(3'b010, 3'b010);
        check_result(3'b010, 3'b011);
        check_result(3'b010, 3'b100);
        check_result(3'b010, 3'b101);
        check_result(3'b010, 3'b110);
        check_result(3'b010, 3'b111);

        // A = 011
        check_result(3'b011, 3'b000);
        check_result(3'b011, 3'b001);
        check_result(3'b011, 3'b010);
        check_result(3'b011, 3'b011);
        check_result(3'b011, 3'b100);
        check_result(3'b011, 3'b101);
        check_result(3'b011, 3'b110);
        check_result(3'b011, 3'b111);

        // A = 100
        check_result(3'b100, 3'b000);
        check_result(3'b100, 3'b001);
        check_result(3'b100, 3'b010);
        check_result(3'b100, 3'b011);
        check_result(3'b100, 3'b100);
        check_result(3'b100, 3'b101);
        check_result(3'b100, 3'b110);
        check_result(3'b100, 3'b111);

        // A = 101
        check_result(3'b101, 3'b000);
        check_result(3'b101, 3'b001);
        check_result(3'b101, 3'b010);
        check_result(3'b101, 3'b011);
        check_result(3'b101, 3'b100);
        check_result(3'b101, 3'b101);
        check_result(3'b101, 3'b110);
        check_result(3'b101, 3'b111);

        // A = 110
        check_result(3'b110, 3'b000);
        check_result(3'b110, 3'b001);
        check_result(3'b110, 3'b010);
        check_result(3'b110, 3'b011);
        check_result(3'b110, 3'b100);
        check_result(3'b110, 3'b101);
        check_result(3'b110, 3'b110);
        check_result(3'b110, 3'b111);

        // A = 111
        check_result(3'b111, 3'b000);
        check_result(3'b111, 3'b001);
        check_result(3'b111, 3'b010);
        check_result(3'b111, 3'b011);
        check_result(3'b111, 3'b100);
        check_result(3'b111, 3'b101);
        check_result(3'b111, 3'b110);
        check_result(3'b111, 3'b111);

        // Step 6: End simulation
        $display("===== ALL 64 TEST CASES COMPLETED =====");
        $finish;

    end

endmodule
