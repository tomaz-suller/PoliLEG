library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity datapath is
    port(
        -- Common
        clock,
        reset,
        -- From Control Unit
        reg2loc,
        pcSrc,
        memToReg: in bit;
        aluCtrl: in bit_vector(3 downto 0);
        aluSrc,
        regWrite: in bit;
        -- To Control Unit
        opcode: out bit_vector(10 downto 0);
        zero: out bit;
        -- IM interface
        imAddr: out bit_vector(63 downto 0);
        imOut: in bit_vector(31 downto 0);
        -- DM interface
        dmAddr,
        dmIn: out bit_vector(63 downto 0);
        dmOut: in bit_vector(63 downto 0)
    );
end entity datapath;

architecture arch of datapath is

    component regfile is
        generic(
            regn: natural := 32;
            wordSize: natural := 64
        );
        port(
            clock, reset, regWrite: in bit;
            rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
            d: in bit_vector(wordSize-1 downto 0);
            q1, q2: out bit_vector(wordSize-1 downto 0)
        );
    end component;

    component alu is
        generic(
            size: natural := 10
        );
        port(
            A, B: in bit_vector(size-1 downto 0);
            F: out bit_vector(size-1 downto 0);
            S: in bit_vector(3 downto 0);
            Z, Ov, Co: out bit
        );
    end component;

    component signExtend is
        port(
            i: in  bit_vector(31 downto 0); 
            o: out bit_vector(63 downto 0)
        );
    end component;

    component Shiftleft2 is
        port(
            i: in bit_vector(63 downto 0);
            o: out bit_vector(63 downto 0)
        );
    end component Shiftleft2;

    component reg is
        generic(
            wordSize: natural := 64
        );
        port(
            clock, reset, enable, wr: in bit;
            dataIn: in bit_vector(wordSize-1 downto 0);
            dataOut: out bit_vector(wordSize-1 downto 0)
        );
    end component;

    constant NUMBER_OF_REGISTERS: natural := 32;
    constant REGISTER_ADDR_SIZE: natural := 5;
    constant WORD_SIZE: natural := 64;
    constant INSTRUCTION_SIZE: natural := 32;

    signal rr1, rr2, wr: bit_vector(REGISTER_ADDR_SIZE-1 downto 0);
    signal q1, q2, d: bit_vector(WORD_SIZE-1 downto 0);

    signal dataAluA, dataAluB, dataAluResult: bit_vector(WORD_SIZE-1 downto 0);
    signal dataOverflow, dataCarryOut: bit;

    signal signExtendOut: bit_vector(WORD_SIZE-1 downto 0);

    signal pcPlusFour: bit_vector(WORD_SIZE-1 downto 0);
    signal pfZero, pfOverflow, pfCarryOut: bit;

    signal shiftOut: bit_vector(WORD_SIZE-1 downto 0);

    signal pcPlusShift: bit_vector(WORD_SIZE-1 downto 0);
    signal psZero, psOverflow, psCarryOut: bit;

    signal pcIn, pcOut: bit_vector(WORD_SIZE-1 downto 0);

begin

    opcode <= imOut(INSTRUCTION_SIZE-1 downto INSTRUCTION_SIZE-11);


    rr1 <= imOut(9 downto 5);
    rr2 <= 
        imOut(4 downto 0) when reg2loc = '1' else
        imOut(20 downto 16);
    wr <= imOut(4 downto 0);
    d <= 
        dmOut when memToReg = '1' else
        dataAluResult;

    registers: regfile
        generic map(NUMBER_OF_REGISTERS, WORD_SIZE)
        port map(
            clock, reset, regWrite,
            rr1, rr2, wr,
            d,
            q1, q2
        );


    extend: signExtend
        port map(
            imOut(31 downto 0),
            signExtendOut
        );


    dataAluA <= q1;
    dataAluB <=
        signExtendOut when aluSrc = '1' else
        q2; 

    dataAlu: alu
        generic map(WORD_SIZE)
        port map(
            dataAluA, dataAluB,
            dataAluResult,
            aluCtrl,
            zero, dataOverflow, dataCarryOut
        );

 
    dmAddr <= dataAluResult;
    dmIn <= q2;

    fourAdder: alu
        generic map(WORD_SIZE)
        port map(
            pcOut, (2 => '1', others => '0'),
            pcPlusFour,
            "0010",
            pfZero, pfOverflow, pfCarryOut
        );    


    shift2: Shiftleft2
        port map(signExtendOut, shiftOut);

    shiftAdder: alu
        generic map(WORD_SIZE)
        port map(
            pcOut, shiftOut,
            pcPlusShift,
            "0010",
            psZero, psOverflow, psCarryOut
        );
        

    pcIn <=
        pcPlusShift when pcSrc = '1' else
        pcPlusFour;

    pc: reg
        generic map(WORD_SIZE)
        port map(
            clock, reset, '1', '1',
            pcIn, pcOut
        );

    imAddr <= pcOut;

end architecture arch;
