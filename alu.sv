// Parameterized SystemVerilog ALU
// Supports add, subtract, bitwise logic, carry/borrow, and overflow.

module alu #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]        op,
    output logic [WIDTH-1:0]  y,
    output logic              zero,
    output logic              carry,
    output logic              overflow
);

    logic [WIDTH:0] add_res, sub_res;

    always_comb begin
        add_res = a + b;
        sub_res = a - b;

        unique case (op)
            3'b000: y = add_res[WIDTH-1:0];     // ADD
            3'b001: y = sub_res[WIDTH-1:0];     // SUB
            3'b010: y = a & b;                  // AND
            3'b011: y = a | b;                  // OR
            3'b100: y = a ^ b;                  // XOR
            default: y = '0;
        endcase
    end

    // Carry and borrow behavior
    assign carry =
        (op == 3'b000) ? add_res[WIDTH] :      // carry out
        (op == 3'b001) ? ~sub_res[WIDTH] :     // ~borrow out
        1'b0;

    // Signed overflow detection
    assign overflow =
        (op == 3'b000) ?                  // ADD overflow
            (( a[WIDTH-1] &  b[WIDTH-1] & ~y[WIDTH-1]) |
             (~a[WIDTH-1] & ~b[WIDTH-1] &  y[WIDTH-1])) :
        (op == 3'b001) ?                  // SUB overflow
            (( a[WIDTH-1] & ~b[WIDTH-1] & ~y[WIDTH-1]) |
             (~a[WIDTH-1] &  b[WIDTH-1] &  y[WIDTH-1])) :
        1'b0;

    assign zero = (y == '0);

endmodule
