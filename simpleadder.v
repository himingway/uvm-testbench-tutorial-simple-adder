module simpleadder (
	input  wire clk ,
	input  wire en_i,
	input  wire ina ,
	input  wire inb ,
	output reg en_o,
	output wire out
	// output reg [1:0] temp_a,
	// output reg [1:0] temp_a_n,
	// output reg [1:0] temp_b,
	// output reg [1:0] temp_b_n
);
	reg [1:0] state     ;
	reg [1:0] state_n   ;
	reg [1:0] temp_a    ;
	reg [1:0] temp_a_n  ;
	reg [1:0] temp_b    ;
	reg [1:0] temp_b_n  ;
	reg [2:0] temp_out  ;
	reg [2:0] temp_out_n;

	initial begin
		state = 2'd0;
	end

	always @(posedge clk) begin
		state <= state_n;
	end

	always @(*) begin
		case (state)
			0 : begin
				if (en_i == 1'b1) begin
					state_n = 3'd1;
				end
				else begin
					state_n = 3'd0;
				end
			end
			1,2: begin
				state_n = state + 1'd1;
			end
			3 : begin
				state_n = 3'd0;
			end
			default : begin
				state_n = 3'd0;
			end
		endcase
	end

	always @(posedge clk) begin
		temp_a   <= temp_a_n;
		temp_b   <= temp_b_n;
		temp_out <= temp_out_n;
	end

	always @(*) begin
		case (state)
			0 : begin
				en_o = 1'b0;
				temp_a_n   = {1'b0,ina};
				temp_b_n   = {1'b0,inb};
				temp_out_n = 3'b0;
			end
			1 : begin
				en_o = 1'b0;
				temp_a_n   = {temp_a[0],ina};
				temp_b_n   = {temp_b[0],inb};
				temp_out_n = temp_a_n + temp_b_n;
			end
			2 : begin
				en_o = 1'b1;
				temp_a_n   = 2'b0;
				temp_b_n   = 2'b0;
				temp_out_n = (temp_out << 1'b1);
			end
			3 : begin
				en_o = 1'b0;
				temp_a_n   = 2'b0;
				temp_b_n   = 2'b0;
				temp_out_n = (temp_out << 1'b1);
			end
			default : begin
				en_o = 1'b0;
				temp_a_n   = 2'b0;
				temp_b_n   = 2'b0;
				temp_out_n = 3'b0;
			end
		endcase
	end

	assign out  = temp_out[2];
endmodule