module random_generator(
	input  rst,
	input  clk,
	input  ena,
	output [7:0] stream	
);
	
	reg  [12:0] lfsr_reg;
	wire [12:0] lfsr_next; 
	wire 		  feedback;

	always@(posedge clk or posedge rst) begin
		if (rst) 
			lfsr_reg <= 13'b1001001000101;
		else if (ena)
			lfsr_reg <= lfsr_next;
	end 
	
	assign feedback = lfsr_reg[12] ^ lfsr_reg[4] ^ lfsr_reg[3] ^ lfsr_reg[1];
	assign lfsr_next = {lfsr_reg[11:0], feedback};
	assign stream = lfsr_reg[9:2];					  

endmodule

