module cc
#(parameter N = 8,
parameter P = 137)
(
input drone_rdy, // wiadomość od drona, że pora odebrać 1. część klucza / pomarańczowy 
input [2*N-1:0] mess_input_cc, // wiadomość wysyłana od drona - pomarańczowy
input  	   	  	 rst, 
input  			  	 clk,
input  			  	 ena,

output cc_rdy, // potwierdzenie, że jest gotów na komunikację

output [N-1:0] mess_out_cc, // wysyłane do drona - obliczona część klucza

output mess_rdy_cc, // info, że wiadmość obliczona --- dopiero wtedy cc nasłuchuje
output [N-1:0] key, // klucz końcowy
output key_rdy // klucz obliczony 

);
reg [N-1:0] G = 8'b0000101; // generator 

wire[N-1:0] privateKey_stream; // lfsr

reg[N-1:0] privateKey_reg; 

//
reg[2*N-1:0] received_first_stage;// = mess_input;
//

reg [N-1:0] id= 8'b00000001; // identyfikator
wire rdy_modPower; // moduł pot. skończył
wire [N-1:0] res_modPower; // rezultat obliczeń
reg [N-1:0] modPower_base; // podstawa potęgowania
reg start; // uruchomienie pot. modularnego
localparam size = 2;
localparam [size-1:0] listening = 2'h0,
							compute_second_stage = 2'h1,
							compute_key = 2'h2;
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
				state_next = compute_second_stage; // niebieski / 1. część nasza 
				
				received_first_stage = mess_input_cc; // pomarańczowy / 1. część od drona
				
				privateKey_reg = privateKey_stream; // losowanie klucza 
				modPower_base = G; // wiadomo
			end
			
			compute_second_stage	:
				begin
					state_next = compute_key; // obliczanie klucza				
					modPower_base = received_first_stage[7:0]; // najstarsze bity inputu stają się bazą potęgi, tworzymy ostateczny, tajny klucz
				end
			compute_key:
				begin
					if(!key_rdy) state_next = compute_key; // jeśli gotowy, przejdź do idle 
					else state_next = listening;			
				end
			default: state_next = listening;
		endcase
		
		if(state_reg!=state_next) start<=1'b1;
		else start<=1'b0;
		
	end
	
	assign mess_out = res_modPower; // cały czas działa // bez id bo to nie dron XD
	
	assign cc_rdy = (rdy_modPower & state_reg == compute_second_stage) ? 1'b1:1'b0; // określa czy dron ma zczytać
	
	assign key = (rdy_modPower & state_reg == compute_key) ? res_modPower:8'b0; // przypisuje do klucza obliczoną już wartość
	assign key_rdy = (rdy_modPower & state_reg == compute_key) ? 1'b1:1'b0; // czy klucz jest gotowy 

modularPowering #(N,P) modularPowering_inst( //nadpisywanie parametrów
// podpinanie zmiennych
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
/*
drone drone_inst(
.rst(rst),
.clk(clk),
.ena(ena),

.mess_input_drone(mess_out_cc),
.cc_ready(mess_rdy_cc),
.mess_out(mess_input_cc),
.mess_rdy_drone(drone_rdy)
);
*/

endmodule