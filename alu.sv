// Parameterized SystemVerilog ALU
// Supports add, subtract, bitwise logic, and basic flags.

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
            3'b000: y = add_res[WIDTH-1:0];     // add
            3'b001: y = sub_res[WIDTH-1:0];     // sub
            3'b010: y = a & b;                  // and
            3'b011: y = a | b;                  // or
            3'b100: y = a ^ b;                  // xor
            default: y = '0;
        endcase
    end

    // Carry flag for addition only
    assign carry = (op == 3'b000) ? add_res[WIDTH] : 1'b0;

    // Signed overflow detection (addition only)
    assign overflow = (op == 3'b000) ?
                      (( a[WIDTH-1]  &  b[WIDTH-1] & ~y[WIDTH-1]) |
                       (~a[WIDTH-1] & ~b[WIDTH-1] &  y[WIDTH-1])) :
                      1'b0;

    assign zero = (y == '0);

endmodule
