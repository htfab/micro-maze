#!/usr/bin/env python3

# from https://keesiemeijer.github.io/maze-generator/
maze_data = [
  "111111111111111111111",
  "100000001000000000101",
  "101111101010111110101",
  "100000101010100010001",
  "101110111010101111101",
  "101010000010101000101",
  "101011111110101010101",
  "101000000010100010001",
  "101011111010111111111",
  "100010000010000000001",
  "111110111111111111111",
  "100010001000100000001",
  "101011101010101111101",
  "101000101010100000101",
  "101111101010101111101",
  "101000001010000000101",
  "101011111111111010101",
  "101010000000000010101",
  "101011111011111110101",
  "100000000010000000101",
  "111111111111111111111"
]

H = len(maze_data)
W = len(maze_data[0])
assert H % 2 == 1
assert W % 2 == 1
assert all(len(line) == W for line in maze_data)

f = open("maze_data.v", "w")

f.write("""`default_nettype none

module maze_data (
    input wire [3:0] x,
    input wire [3:0] x_alt,
    input wire [3:0] y,
    input wire [3:0] y_alt,
    output reg horizontal,
    output reg vertical
);

always @(*) begin
    case({y_alt, x})
""")

for j in range(16):
    J = 2*j
    for i in range(16):
        I = 2*i+1
        if J < H and I < W:
            wall = maze_data[J][I]
        else:
            wall = 'x'
        f.write(f"        8'b{j:04b}_{i:04b}: horizontal = 1'b{wall};\n")
    f.write("\n")

f.write("""    endcase
    case({y, x_alt})
""")

for j in range(16):
    J = 2*j+1
    for i in range(16):
        I = 2*i
        if J < H and I < W:
            wall = maze_data[J][I]
        else:
            wall = 'x'
        f.write(f"        8'b{j:04b}_{i:04b}: vertical = 1'b{wall};\n")
    f.write("\n")

f.write("""    endcase
end

endmodule
""")

