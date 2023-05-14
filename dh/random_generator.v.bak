module random_generator(
	input  rst,
	input  clk,
	input  ena,
	output stream	
);
	
	reg  [12:0] lfsr_reg;
	wire [12:0] lfsr_next; 
	wire 		  feedback;

	// State register
	always@(posedge clk or posedge rst) begin
		if (rst) 
			lfsr_reg <= 13'b1000000000000;
		else if (ena)
			lfsr_reg <= lfsr_next;
	end
	// Maximum length feedback polynomial X8+X6+X5+X4+1, 
	assign feedback = lfsr_reg[12] ^ lfsr_reg[4] ^ lfsr_reg[3] ^ lfsr_reg[1];
	assign lfsr_next = {lfsr_reg[11:0], feedback};
						  
	assign stream = lfsr_reg[12];

endmodule

