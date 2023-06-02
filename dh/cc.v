module cc
#(parameter N = 8,
parameter drone1_prime = 137,
parameter drone1_generator = 5,
parameter drone2_prime = 229,
parameter drone2_generator = 2)
(
input drone_rdy, // wiadomość od drona, że pora odebrać 1. część klucza
input [2*N-1:0] mess_input, // wiadomość wysyłana od drona
input  	   	  	 rst, 
input  			  	 clk,
input  			  	 ena,
output [N-1:0] mess_out, // wysyłane do drona - obliczona część klucza
output mess_rdy, // info, że wiadmość obliczona --- dopiero wtedy cc nasłuchuje
output [N-1:0] key, // klucz końcowy
output key_rdy // klucz obliczony 

);
reg [N-1:0] G;

wire[N-1:0] privateKey_stream; // lfsr

reg[N-1:0] privateKey_reg; 

//
reg[2*N-1:0] received_first_stage;// = mess_input;
//

reg [N-1:0] id;
wire rdy_modPower; // moduł pot. skończył
wire rdy_modPower1,rdy_modPower2;
wire [N-1:0] res_modPower; // rezultat obliczeń
wire [N-1:0] res_modPower1, res_modPower2;
reg [N-1:0] modPower_base; // podstawa potęgowania
reg [N-1:0] modPower_base1,modPower_base2;
reg start;
reg start1,start2; // uruchomienie pot. modularnego
localparam size = 2;
localparam [size-1:0] listening = 2'h0,
							compute_second_stage = 2'h1,
							compute_key = 2'h2;
localparam drones_quantity = 2;
localparam [size-1:0] drone1 = 1,
							drone2 = 2;
reg [size-1:0] state_reg,state_next;

// State register
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			state_reg <= listening;
			
		end
		else if (ena) begin
			state_reg <= state_next;
		end
	end
	

	
// Next state logic
	always@(*) begin
		case(state_reg)
			listening	:
			if(drone_rdy) begin 				
				privateKey_reg = privateKey_stream; // losowanie klucza
				received_first_stage = mess_input; // 1. część od drona
				id = received_first_stage[15:8];				
				state_next = compute_second_stage; // 1. część nasza
			end
			else state_next = listening;
			
			compute_second_stage	:
				begin
					modPower_base = G;
					if(mess_rdy)state_next = compute_key; // obliczanie klucza	
					else state_next = compute_second_stage;
					
				end
			compute_key:
				begin
					modPower_base = received_first_stage[7:0];// najstarsze bity inputu stają się bazą potęgi,	tworzymy ostateczny, tajny klucz
					if(key_rdy) state_next = listening; // jeśli gotowy, przejdź do idle 
					else state_next = compute_key;
				end
			default: state_next = listening;
		endcase
		
		if(state_reg!=state_next) start=1'b1;
		else start=1'b0;
		
		end
	
	always@(*) begin
	case(id)
	drone1: begin
	G = drone1_generator;
	modPower_base1 = modPower_base;
	start1 = start;
	end
	drone2: begin
	G = drone2_generator;
	modPower_base2 = modPower_base;
	start2 = start;
	end
	endcase
	end
	
	assign res_modPower =  (id==drone1) ? res_modPower1:res_modPower2;
	assign rdy_modPower =  (id==drone1) ? rdy_modPower1:rdy_modPower2;
	
	assign mess_out = (rdy_modPower & state_reg == compute_second_stage) ? res_modPower:8'b0; // cały czas działa
	assign mess_rdy = (rdy_modPower & state_reg == compute_second_stage) ? 1'b1:1'b0;
	
	assign key = (rdy_modPower & state_reg == compute_key) ? res_modPower:8'b0; // przypisuje do klucza obliczoną już wartość
	assign key_rdy = (rdy_modPower & state_reg == compute_key) ? 1'b1:1'b0; // czy klucz jest gotowy 
	

modularPowering #(N,drone1_prime) modularPowering_inst_drone1(
.rst(rst),
.clk(clk),
.ena(ena),
.start(start1),
.base(modPower_base1),
.exp(privateKey_reg),
.res(res_modPower1),
.rdy(rdy_modPower1)
);

modularPowering #(N,drone2_prime) modularPowering_inst_drone2(
.rst(rst),
.clk(clk),
.ena(ena),
.start(start2),
.base(modPower_base2),
.exp(privateKey_reg),
.res(res_modPower2),
.rdy(rdy_modPower2)
);



random_generator randomGenerator_inst(
.rst(rst),
.clk(clk),
.ena(ena),
.stream(privateKey_stream)
);

endmodule
