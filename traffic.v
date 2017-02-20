module traffic_control (CLK, reset, ERR, PA, PB, L_A, L_B, RA, RB);
  input CLK, reset, PA, PB, ERR;
  output RA, RB;
  output [2:0] L_A, L_B;
  reg RA, RB;
  reg [2:0] L_A, L_B, cst, nst, pst;
  reg A, B;
  
  parameter Green            = 3'b110,
            GreenLeftArrow   = 3'b101,
            Yellow           = 3'b100,
            Red              = 3'b011,
            GreenRightArrow  = 3'b010,
            FlashingRed      = 3'b111,
            FlashingYellow   = 3'b000,
            
            state0           = 3'b000,
            state1           = 3'b001,
            state2           = 3'b010,
            state3           = 3'b011,
            state4           = 3'b100,
            state5           = 3'b101,
            state6           = 3'b110,
            state7           = 3'b111;          
            
  always @(posedge CLK)
  if (reset | ERR) begin 
    cst <= state7;
    nst = state0;
  end
  else
    cst <= nst;
    
  always @(cst)
  begin
    case (cst)
      3'b000: begin
          if (A) RA = 1;
            if (B) RB = 1;
          //repeat (5) @(posedge CLK)
          //nst = state0;
          begin
            
            if (pst == state3) begin
              RA = 0;
              RB = 0;
              A = 0;
              B = 0;
              nst = state4;
              pst = state0;
            end
           
            else if (pst == state6) begin
              RA = 0;
              RB = 0;
              A = 0;
              B = 0;
              nst = state1;
              pst = state0;
            end
          else
              nst = state1;
              pst = state0;
          end
         
        end
        
      3'b001: begin
        //repeat (7) begin
        //@(posedge CLK)
          nst = state1;
        //end
          begin
             pst = state1;
             nst = state2;
          end
      end
      
      3'b010: begin
        //repeat (2) @(posedge CLK)
          //nst = state2;
          begin 
            pst = state2;
            nst = state3;
          end
      end
      
      3'b011: begin
        //repeat (2) @(posedge CLK)
          //nst = state3;
          begin
            pst = state3;
            nst = state4;
            if ((A == 1) || (B == 1)) begin
              nst = state0;
              pst = state3;
            end       
          end
      end
      
      3'b100: begin
        //repeat (7) @(posedge CLK)
          //nst = state4;
          begin
            pst = state4;
            nst = state5;
          end
      end
      
      3'b101: begin
       // repeat (2) @(posedge CLK)
         // nst = state5;
          begin
            pst = state5;
            nst = state6;
          end
      end
      
      3'b110: begin
        //repeat (2) @(posedge CLK)
          //nst = state6;
          begin
            if (A | B) begin
              nst = state0;
              pst = state6;
            end
          else begin
          pst = state6;
          nst = state1;
          end
          end
      end
      
      3'b111: begin
        if (ERR != 1)
        pst = state7; 
        nst = state0;
      end
      default: nst = state7;
      
    endcase
   end
   
   always @(posedge CLK)
   begin
     case (cst)
      3'b000: begin
       L_A <= 3'b111;
       L_B <= 3'b111;  
        end
        
      3'b001: begin
        if(PA) 
          A <= 1;
        if (PB) 
          B <= 1;
        /*if (pst == state0) 
          begin
            RA <= 0;
            RB <= 0;
          end*/
        L_A <= 3'b110;
        L_B <= 3'b011;
      end
      
      3'b010: begin
        if(PA) 
          A <= 1;
        if (PB) 
          B <= 1;
        L_A <= 3'b101;
        L_B <= 3'b010;
      end
      
      3'b011: begin
        if(PA) 
          A <= 1;
        if (PB) 
         B <= 1;
        L_A <= 3'b100;
        L_B <= 3'b010;
      end
      
      3'b100: begin
        if(PA) 
          A <= 1;
        if (PB) 
          B <= 1;
          /*if (pst == state0) 
          begin
            RA <= 0;
            RB <= 0;
          end*/
        L_A <= 3'b011;
        L_B <= 3'b010;
      end
      
      3'b101: begin
        if(PA) 
          A <= 1;
        if (PB) 
          B <= 1;
        L_A <= 3'b010;
        L_B <= 3'b101;
      end
      
      3'b110: begin
        if(PA) 
          A <= 1;
        if (PB) 
          B <= 1;
        L_A <= 3'b010;
        L_B <= 3'b100;
      end
      
      3'b111: begin
        L_A <= 3'b000;
        L_B <= 3'b000;
      end
      
      default: begin
        L_A <= 3'b000;
        L_B <= 3'b000;
      end
      
    endcase
    end
       
endmodule
   
    
