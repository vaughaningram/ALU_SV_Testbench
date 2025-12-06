`timescale 1ns/1ps

module tb_alu;

    localparam WIDTH = 8;

    logic [WIDTH-1:0] a, b;
    logic [2:0]       op;
    logic [WIDTH-1:0] y;
    logic             zero, carry, overflow;

    alu #(WIDTH) dut (
        .a(a), .b(b), .op(op),
        .y(y), .zero(zero), .carry(carry), .overflow(overflow)
    );

    // Expected values for scoreboard
    logic [WIDTH-1:0] exp_y;
    logic             exp_zero, exp_carry, exp_overflow;

    task automatic compute_expected;
        logic signed [WIDTH-1:0] sa, sb, sy;
        sa = a; sb = b;

        case (op)
            3'b000: {exp_carry, exp_y} = a + b;   // ADD
            3'b001: {exp_carry, exp_y} = a - b;   // SUB (exp_carry = ~borrow)
            3'b010: begin exp_y = a & b; exp_carry = 0; end
            3'b011: begin exp_y = a | b; exp_carry = 0; end
            3'b100: begin exp_y = a ^ b; exp_carry = 0; end
            default: exp_y = 0;
        endcase

        sy = exp_y;
        exp_zero = (exp_y == 0);

        // Signed overflow detection
        exp_overflow =
            (op == 3'b000) ?
                ((sa > 0 && sb > 0 && sy < 0) ||
                 (sa < 0 && sb < 0 && sy > 0)) :
            (op == 3'b001) ?
                ((sa > 0 && sb < 0 && sy < 0) ||
                 (sa < 0 && sb > 0 && sy > 0)) :
            0;
    endtask

    integer mismatches = 0;
    integer cov_add, cov_sub, cov_and, cov_or, cov_xor;

    task run_vector(input logic[WIDTH-1:0] ta, tb, input [2:0] top);
        a = ta; b = tb; op = top;
        #1 compute_expected;

        case (op)
            3'b000: cov_add++;
            3'b001: cov_sub++;
            3'b010: cov_and++;
            3'b011: cov_or++;
            3'b100: cov_xor++;
        endcase

        if (y !== exp_y) begin
            mismatches++;
            $display("[FAIL] op=%0d a=%0d b=%0d y=%0d exp=%0d",
                     op, a, b, y, exp_y);
        end
    endtask

    // Assertions (flag correctness)
    always @(*) begin
        if (y !== 'x) begin
            assert (zero == exp_zero)
                else $error("[ASSERT] Zero flag mismatch.");

            assert (overflow == exp_overflow)
                else $error("[ASSERT] Overflow mismatch.");
        end
    end

    initial begin
        $display("\n--- DIRECTED CORNER CASE TESTS ---\n");
        run_vector(8'h00, 8'h00, 3'b000); // 0 + 0
        run_vector(8'hFF, 8'h01, 3'b000); // carry test
        run_vector(8'h80, 8'h80, 3'b000); // add overflow
        run_vector(8'h80, 8'h7F, 3'b001); // sub overflow
        run_vector(8'h00, 8'h01, 3'b001); // borrow
        run_vector(8'hFF, 8'hFF, 3'b100); // xor → zero

        $display("\n--- RANDOM TESTS (100 vectors) ---\n");
        for (int i = 0; i < 100; i++) begin
            run_vector($urandom, $urandom, $urandom_range(0, 4));
        end

        $display("\n--- COVERAGE SUMMARY ---");
        $display("ADD ops: %0d", cov_add);
        $display("SUB ops: %0d", cov_sub);
        $display("AND ops: %0d", cov_and);
        $display("OR  ops: %0d", cov_or);
        $display("XOR ops: %0d", cov_xor);
        $display("Mismatches: %0d", mismatches);

        if (mismatches == 0)
            $display("\nALL TESTS PASSED ✅\n");
        else
            $display("\nTEST FAILURES DETECTED ❌\n");

        $finish;
    end

endmodule
