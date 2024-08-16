//============================================================================================
// Project : DSP 48A1
// Author  : Mahmoud Alsayed Kebeisy
// Date    : 2024-08-10
//============================================================================================

module rtl_DSP (A,B,C,D,BCIN,PCIN,CARRYIN,clk,opmode,rsta,rstb,rstc,rstd,rstm,rstp,rstopmode,rstcarrin,
                   cea,ceb,cem,cep,cec,ced,ceopmode,cecarryin,Bcout,Pcout,P,M,carryout,carryoutf);

//============================================================================================
// PARAMETERS
//============================================================================================

parameter A0REG = 0 ; // NO REGISTERED
parameter A1REG = 1 ; // REGISTERED
parameter B0REG = 0 ; // NO REGISTERED
parameter B1REG = 1 ; // REGISTERED
parameter CREG  = 1 ; // REGISTERED
parameter DREG  = 1 ; // REGISTERED
parameter MREG  = 1 ; // REGISTERED
parameter PREG  = 1 ; // REGISTERED
parameter CARRYINREG  = 1 ; // REGISTERED
parameter CARRYOUTREG = 1 ; // REGISTERED
parameter OPMODEREG   = 1 ; // REGISTERED
parameter CARRYINSEL  = "OPMODE5" ;
parameter B_INPUT     = "DIRECT"  ;
parameter RSTTYPE     = " SYNC"   ;
parameter W48 = 48 ;
parameter W36 = 36 ;
parameter W18 = 18 ;
parameter W8  = 8 ;
parameter W1  = 1 ;

//============================================================================================
// INPUTS
//============================================================================================

    input [W18-1:0] A, B, D, BCIN;
    input [W48-1:0] C, PCIN;
    input [W8-1:0] opmode;
    input [W1-1:0] clk, rsta, CARRYIN, rstb, rstc, rstd, rstm, rstp, rstopmode, rstcarrin;
    input [W1-1:0] cea, ceb, cem, cep, cec, ced, ceopmode, cecarryin;

//============================================================================================
// OUTPUTS
//============================================================================================

    output  [W18-1:0] Bcout;
    output  [W48-1:0] P, Pcout;
    output  [W36-1:0] M;
    output  [W1-1:0]  carryout, carryoutf;

//============================================================================================
// WIRES
//============================================================================================

   wire [W18-1:0] A0FIN, B0FIN, A1FIN, B1FIN, DFIN;
   wire [W48-1:0] CFIN, D_A_B_CON;
   wire [W36-1:0] MIN, MFIN ;
   wire [W8-1:0] OPMODEFIN;
   wire [W18-1:0] PRE_OUT;
   wire CYIFIN;
   wire [W18-1:0] B1IN;
   wire [W18-1:0] B0;
   wire  CYIIN ;
   reg [W48-1:0] OUTX, OUTZ, P_OUT;
   reg CYOIN ;

//============================================================================================
// INSTANTIATIONS
//============================================================================================

dff_mux #(.WIDTH(W8),.RSTTYPE("SYNC"))  U_OPMODE (clk, rstopmode, OPMODEREG, ceopmode, opmode, OPMODEFIN);
dff_mux #(.WIDTH(W18),.RSTTYPE("SYNC")) U_A0     (clk, rsta, A0REG, cea, A, A0FIN);
dff_mux #(.WIDTH(W18),.RSTTYPE("SYNC")) U_B0     (clk, rstb, B0REG, ceb, B0, B0FIN);
dff_mux #(.WIDTH(W48),.RSTTYPE("SYNC")) U_C      (clk, rstc, CREG, cec, C, CFIN);
dff_mux #(.WIDTH(W18),.RSTTYPE("SYNC")) U_D      (clk, rstd, DREG, ced, D, DFIN);
dff_mux #(.WIDTH(W18),.RSTTYPE("SYNC")) U_A1     (clk, rsta, A1REG, cea, A0FIN, A1FIN);
dff_mux #(.WIDTH(W18),.RSTTYPE("SYNC")) U_B1     (clk, rstb, B1REG, ceb, B1IN, B1FIN);
dff_mux #(.WIDTH(W48),.RSTTYPE("SYNC")) U_M      (clk, rstm, MREG, cem, MIN, MFIN);
dff_mux #(.WIDTH(W1),.RSTTYPE("SYNC"))  U_CYI    (clk, rstcarrin, CARRYINREG, cecarryin, CYIIN, CYIFIN);
dff_mux #(.WIDTH(W48),.RSTTYPE("SYNC")) U_P      (clk, rstp, PREG, cep, P_OUT, P);
dff_mux #(.WIDTH(W1),.RSTTYPE("SYNC"))  U_CYO    (clk, rstcarrin, CARRYOUTREG, cecarryin, CYOIN, carryout);

//============================================================================================
// OPERATIONS
//============================================================================================

assign B0=(B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCIN:18'b0;
assign PRE_OUT=(!OPMODEFIN[6])?DFIN+B0FIN:DFIN-B0FIN;
assign B1IN=(OPMODEFIN[4])?PRE_OUT:B0FIN;
assign Bcout=B1FIN;
assign MIN=B1FIN*A1FIN;
assign D_A_B_CON={DFIN[11:0],A1FIN,B1FIN};
assign M=~(~MFIN);
assign CYIIN=(CARRYINSEL=="OPMODE5")?OPMODEFIN[5]:(CARRYINSEL=="CASCADE")?CARRYIN:1'b0;
assign Pcout=P;
assign carryoutf=carryout;

always @(*) begin
    case (OPMODEFIN[1:0])
        0:OUTX=48'b0;
        1:OUTX={{12{MFIN[35]}},MFIN};
        2:OUTX=P; 
        3:OUTX=D_A_B_CON;
        default: OUTX=48'b0;
    endcase
end

always @(*) begin
    case (OPMODEFIN[3:2])
       0 :OUTZ=48'b0;
       1 :OUTZ=PCIN;
       2 :OUTZ=P;
       3 :OUTZ=CFIN;
        default: OUTZ=48'b0;
    endcase
end

always @(*) begin
    if (OPMODEFIN[7]) begin
        {CYOIN,P_OUT}=OUTX+OUTZ;
    end
    else {CYOIN,P_OUT}=OUTZ-(OUTX+CYIFIN);
end

endmodule