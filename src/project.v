`default_nettype none

module tt_um_htfab_micro_maze (
    //output wire [15:0] debug,
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

reg [3:0] x;
reg [3:0] y;
reg parity;
reg horizontal;
reg vertical;
reg held;
reg top;
reg bottom;
reg left;
reg right;

wire win = (x == 9) && (y == 9);
assign uo_out = {win, win, left, left, bottom, right, right, top};
//assign debug = {x, y, parity, horizontal, vertical, held, top, bottom, left, right};

always @(posedge clk) begin
    if(!rst_n) begin
        x <= 0;
        y <= 0;
        parity <= 0;
        top <= 1;
        bottom <= 1;
        left <= 1;
        right <= 1;
        held <= 0;
    end else begin
        if(ui_in[0] && !top && !held) begin
            x <= x;
            y <= y - 1;
        end else if(ui_in[1] && !bottom && !held) begin
            x <= x;
            y <= y + 1;
        end else if(ui_in[2] && !left && !held) begin
            x <= x - 1;
            y <= y;
        end else if(ui_in[3] && !right && !held) begin
            x <= x + 1;
            y <= y;
        end
        held <= |ui_in[3:0];
        if(parity) begin
            bottom <= horizontal;
            right <= vertical;
        end else begin
            top <= horizontal;
            left <= vertical;
        end
        parity <= ~parity;
    end
end

wire [3:0] x_alt = parity ? (x + 1) : x;
wire [3:0] y_alt = parity ? (y + 1) : y;

maze_data i_maze_data(
    .x,
    .x_alt,
    .y,
    .y_alt,
    .horizontal,
    .vertical
);

wire _unused = &{ui_in[7:4], 1'b0};

endmodule  // tt_um_factory_test
