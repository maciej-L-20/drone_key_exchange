module drone
#(parameter N = 8,
parameter P = 137)
(
input [N-1:0] mess_input,
input received,
input init,
input  	   	  	 rst,
input  			  	 clk,
input  			  	 ena,
output [2*N-1:0] mess_out,
output mess_rdy,
output [N-1:0] key,
output key_rdy
);
reg [N-1:0] G = 8'b0000101;
wire[N-1:0] privateKey_stream;
reg[N-1:0] privateKey_reg;
reg [N-1:0] id= 8'b00000001;
wire rdy_modPower;
wire [N-1:0] res_modPower;
reg [N-1:0] modPower_base;
reg start;

localparam size = 2;
localparam [size-1:0] idle = 2'h0,
							send_mess = 2'h1,
							compute_key = 2'h2;
reg [size-1:0] state_reg,state_next;

// State register
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			state_reg <= idle;
		end
		else if (ena) begin
			state_reg <= state_next;
		end
	end
	

	
// Next state logic
	always@(*) begin
	
		case(state_reg)
			idle 	 :	
			if (init) 
			begin
				state_next = send_mess;
				privateKey_reg = privateKey_stream;
				modPower_base = G;
			end
			else		  state_next = idle;
			
			send_mess: 
			if(received)
				begin
					modPower_base = mess_input;
					state_next = compute_key;
				end
			else state_next = send_mess;
			
			compute_key:	if(!key_rdy) state_next = compute_key;
								else state_next = idle;
								
			default: state_next = idle;
		endcase
		
		if(state_reg!=state_next) start<=1'b1;
		else start<=1'b0;
		
	end
	
	assign mess_out = {id, res_modPower};
	assign mess_rdy = (rdy_modPower & state_reg == send_mess) ? 1'b1:1'b0;
	assign key = (rdy_modPower & state_reg == compute_key) ? res_modPower:8'b0;
	assign key_rdy = (rdy_modPower & state_reg == compute_key) ? 1'b1:1'b0;

modularPowering #(N,P) modularPowering_inst(
.rst(rst),
.clk(clk),
.ena(ena),
.start(start),
.base(modPower_base),
.exp(privateKey_reg),
.res(res_modPower),
.rdy(rdy_modPower)
);

random_generator randomGenerator_inst(
.rst(rst),
.clk(clk),
.ena(ena),
.stream(privateKey_stream)
);


endmodule