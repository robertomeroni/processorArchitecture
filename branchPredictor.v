`include "constants.v"

module branchPredictor (
    input clk,
    input rst,
    input [`WORD_SIZE-1:0] PC,
    input [`WORD_SIZE-1:0] CurrentPC,
    input BranchE, 
    input ZeroE,
    input [`WORD_SIZE-1:0] PCTargetE,
    input wire [`WORD_SIZE-1:0] PCPlus4F,
    input wire [`WORD_SIZE-1:0] SavedPC,
    input resetBranch,
    output wire [`WORD_SIZE-1:0] NextInstruction,
    output wire TakingBranch
    );

    reg [`WORD_SIZE-1:0] BranchPC [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    reg [`WORD_SIZE-1:0] TargetPC [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    reg [1:0] Prediction [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    reg Valid_reg [0:`BRANCH_PREDICTOR_NUM_LINES-1];
    wire [`WORD_SIZE-1:0] NextPC;
    wire taken;

    initial begin

        Valid_reg[0] = 0;
        Valid_reg[1] = 0;
        Valid_reg[2] = 0;
        Valid_reg[3] = 0;

        Prediction[0] = 2'b01;
        Prediction[1] = 2'b01;
        Prediction[2] = 2'b01;
        Prediction[3] = 2'b01;

        TargetPC[0] = 0;
        TargetPC[1] = 0;
        TargetPC[2] = 0;
        TargetPC[3] = 0;

        BranchPC[0] = 0;
        BranchPC[1] = 0;
        BranchPC[2] = 0;
        BranchPC[3] = 0;
    end

    always @(posedge clk) begin
        if (BranchE & Valid_reg[PC[`BINDEX]] & BranchPC[PC[`BINDEX]] == PC) begin
            $display("BranchPredictor: current Prediction = %b", Prediction[PC[`BINDEX]]);
            case (Prediction[PC[`BINDEX]])
                2'b00: begin
                    Prediction[PC[`BINDEX]] <= (taken) ? 2'b01 : 2'b00;
                end
                2'b01: begin
                    Prediction[PC[`BINDEX]] <= (taken) ? 2'b10 : 2'b00;
                end
                2'b10: begin
                    Prediction[PC[`BINDEX]] <= (taken) ? 2'b11 : 2'b01;
                end
                2'b11: begin
                    Prediction[PC[`BINDEX]] <= (taken) ? 2'b11 : 2'b10;
                end
            endcase
            $display("BranchPredictor: after Prediction = %b", Prediction[PC[`BINDEX]]);

        end else if (BranchE & ZeroE) begin
            $display("BranchPredictor: adding new PC = %h to predictor", PC);
            BranchPC[PC[`BINDEX]] <= PC;
            TargetPC[PC[`BINDEX]] <= PCTargetE;
            Valid_reg[PC[`BINDEX]] <= 1'b1;
            Prediction[PC[`BINDEX]] <= 2'b10;
        end
    end



    assign TakingBranch = ((Prediction[CurrentPC[`BINDEX]] == 2'b10 | Prediction[CurrentPC[`BINDEX]] == 2'b11) & Valid_reg[CurrentPC[`BINDEX]] & BranchPC[CurrentPC[`BINDEX]] == CurrentPC) ? 1 : 0;
    assign NextPC = TakingBranch ? TargetPC[CurrentPC[`BINDEX]] : PCPlus4F;
    assign NextInstruction = resetBranch ? SavedPC : NextPC;
    assign taken = BranchE & ZeroE;
endmodule