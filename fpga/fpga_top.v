`default_nettype none

module fpga_top(
    input wire clk,
    input wire btnC,
    input wire btnU,
    input wire btnL,
    input wire btnR,
    input wire btnD,
    input wire [15:0] sw,
    output wire [15:0] led,
    output wire [7:0] JB,
    output wire [7:0] JC
);

reg rst_n;

initial begin
    rst_n <= 0;
end

always @(posedge clk) begin
    rst_n <= ~btnC;
end

wire [7:0] ui_in = {4'b0, btnU, btnD, btnR, btnL};
wire [7:0] uo_out;

tt_um_htfab_micro_maze i_project(
    //.debug(led),
    .ui_in(ui_in),
    .uo_out(uo_out),
    .clk(clk),
    .rst_n(rst_n)
);

assign JB = 8'b00100001;
assign JC = uo_out;
assign led = 16'b0;

endmodule
