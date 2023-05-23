module modularPowering
#(parameter N=8,
parameter P=89
)
(
input  	   	  	 rst,
input  			  	 clk,
input  			  	 ena,
input  			  	 start,
input [N-1:0] base,
input [N-1:0] exp,
output reg [N-1:0] res,
output reg rdy
);
localparam size = 2;
localparam [size-1:0] idle = 3'h0,
							 init = 3'h1,
							 check = 3'h2,
							 operations = 3'h3;
reg [size-1:0] state_reg, state_next;
reg [N-1:0] base_reg,base_next;
reg [N:0] exp_reg, exp_next;
reg [N-1:0] res_next;
reg rdy_next;

	// State register
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			state_reg <= idle;
			rdy		 <= 1'b0;
			base_reg <= {(N){1'b0}};
			exp_reg <= {(N+1){1'b0}};
			res	<= {(N){1'b0}};
		end
		else if (ena) begin
			state_reg <= state_next;
			rdy		 <= rdy_next;
			base_reg	<= base_next;
			exp_reg <= exp_next;
			res 	<= res_next;
		end
	end
	
		// Next state logic
	always@(*) begin
	rdy_next	= 1'b0;
		case(state_reg)
			idle 	 :	if (start) state_next = init;
					   else		  state_next = idle;
			init 	 : state_next = check;
			check  :
			if (base_reg == 0|| $signed(exp_reg)<=0)
			begin			
							rdy_next=1;
							state_next = idle;
			end
						else state_next = operations;

			operations: state_next = check;
						
			default: state_next = idle;
		endcase
	end
	
// Microoperation logic
	always@(*) begin
		exp_next   = exp_reg;
		base_next   = base_reg;
		res_next = res;
		
		case(state_reg)
			init		:	begin
								base_next = base%P;
								res_next=1;
								exp_next = {1'b0,exp};
							end
			operations: begin
							if (exp_reg[0]!=0)
								res_next=(res*base_reg)%P;
							exp_next=exp_reg>>1;
							base_next = (base_reg*base_reg)%P;
							end				
		endcase
		end
endmodule