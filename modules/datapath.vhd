entity datapath is
    port(
        -- Common
        clock,
        reset,
        -- From Control Unit
        reg2log,
        pcsrc,
        memToReg: in bit;
        aluCtrl: in bit_vector(1 downto 0);
        aluSrc,
        regWrite: in bit;
        -- To Control Unit
        opcode: out bit_vector(10 downto 0);
        zero: out bit;
        -- IM interface
        imAddr: out bit_vector(63 downto 0);
        imOut: in bit_vector(31 downto 0);
        -- DM interface
        dmAddr: out bit_vector(63 downto 0);
        dmIn: out bit_vector(63 downto 0);
        dmOut: out bit_vector(63 downto 0)
    );
end entity datapath
