module cc
#(parameter N = 8,
parameter P = 137)
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
				privateKey_reg = privateKey_stream; // losowanie klucza
				received_first_stage = mess_input; // 1. część od drona				 
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
					modPower_base = received_first_stage[7:0]; // najstarsze bity inputu stają się bazą potęgi, tworzymy ostateczny, tajny klucz
					if(key_rdy) state_next = listening; // jeśli gotowy, przejdź do idle 
					else state_next = compute_key;
				end
			default: state_next = listening;
		endcase
		
		if(state_reg!=state_next) start<=1'b1;
		else start<=1'b0;
		
	end
	assign mess_out = (rdy_modPower & state_reg == compute_second_stage) ? res_modPower:8'b0; // cały czas działa
	assign mess_rdy = (rdy_modPower & state_reg == compute_second_stage) ? 1'b1:1'b0;
	
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

endmodule