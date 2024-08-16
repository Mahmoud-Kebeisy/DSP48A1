module tb_DSP ();
parameter W48=48;
parameter W36=36;
parameter W18=18;
parameter W8=8;
parameter W1=1;

    reg [W18-1:0]A,B,D,BCIN;
    reg [W48-1:0] C,PCIN;
    reg [W8-1:0] opmode;
    reg [W1-1:0]clk,rsta,CARRYIN,rstb,rstc,rstd,rstm,rstp,rstopmode,rstcarrin,cea,ceb,cem,cep,cec,ced,ceopmode,cecarryin;

    wire  [W18-1:0]Bcout;
    wire  [W48-1:0]P,Pcout;
    wire  [W36-1:0]M;
    wire  [W1-1:0]carryout,carryoutf;
    
   rtl_DSP m1(A,B,C,D,BCIN,PCIN,CARRYIN,clk,opmode,rsta,rstb,rstc,rstd,rstm,rstp,rstopmode,rstcarrin,
              cea,ceb,cem,cep,cec,ced,ceopmode,cecarryin,Bcout,Pcout,P,M,carryout,carryoutf);
    initial begin
        clk=0;
        forever begin
            #1 clk=~clk;
        end
    end
    integer i=0;
    initial begin
        A=0; B=0; C=0; D=0; CARRYIN=0; BCIN=0; PCIN=0; opmode=0;
        rsta=1; rstb=1; rstc=1; rstd=1; rstm=1; rstp=1; rstcarrin=1; rstopmode=1;
        cea=0; ceb=0; cec=0; ced=0; cep=0; cem=0; cecarryin=0; ceopmode=0;
        @(negedge clk);
        rsta=0; rstb=0; rstc=0; rstd=0; rstm=0; rstp=0; rstcarrin=0; rstopmode=0;
        cea=1; ceb=1; cec=1; ced=1; cep=1; cem=1; cecarryin=1; ceopmode=1;
         opmode=8'b1111_0000;
        for (i =0 ;i<5 ;i=i+1 ) begin
            A=$random;
            B=$random;
            C=$random;
            D=$random;
            PCIN=$random;
            BCIN=$random;
            CARRYIN=$random;
            @(negedge clk);
        end
         opmode=8'b0101_0101;
        for (i =0 ;i<5 ;i=i+1 ) begin
            A=$random;
            B=$random;
            C=$random;
            D=$random;
            PCIN=$random;
            BCIN=$random;
            CARRYIN=$random;
            @(negedge clk);
        end
         opmode=8'b1010_1010;
        for (i =0 ;i<5 ;i=i+1 ) begin
            A=$random;
            B=$random;
            C=$random;
            D=$random;
            PCIN=$random;
            BCIN=$random;
            CARRYIN=$random;
            @(negedge clk);
        end
         opmode=8'b1111_1111;
        for (i =0 ;i<5 ;i=i+1 ) begin
            A=$random;
            B=$random;
            C=$random;
            D=$random;   
            PCIN=$random;
            BCIN=$random;
            CARRYIN=$random;
            @(negedge clk);
        end
        $stop;
    end
endmodule
