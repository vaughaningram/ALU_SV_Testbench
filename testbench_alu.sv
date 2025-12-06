`timescale 1ns/1ps

// Constrained-random self-checking testbench for ALU

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

    logic [WIDTH-1:0] exp_y;
    logic             exp_zero;

    // Simple expected model
    task automatic compute_expected;
        begin
            case (op)
                3'b000: exp_y = a + b;
                3'b001: exp_y = a - b;
                3'b010: exp_y = a & b;
                3'b011: exp_y = a | b;
                3'b100: exp_y = a ^ b;
                default: exp_y = '0;
            endcase

            exp_zero = (exp_y == '0);
        end
    endtask

    // Assertion: zero flag must match model
    always @(*) begin
        if (y !== 'x) begin
            assert (zero == exp_zero)
                else $error("ASSERT FAIL: zero=%0b exp=%0b y=%0d", zero, exp_zero, y);
        end
    end

    integer i;
    initial begin
        int seed = 32'hCAFEBABE;

        for (i = 0; i < 50; i++) begin
            a  = $urandom(seed);
            b  = $urandom(seed);
            op = $urandom_range(0, 4);

            #1 compute_expected;

            if (y !== exp_y)
                $error("FAIL: op=%0d a=%0d b=%0d y=%0d exp=%0d",
                       op, a, b, y, exp_y);
            else
                $display("PASS: op=%0d a=%0d b=%0d y=%0d",
                         op, a, b, y);
        end

        $display("Testbench complete");
        $finish;
    end

endmodule
