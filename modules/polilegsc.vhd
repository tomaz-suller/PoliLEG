entity polilegsc is
    port(
        clock, reset: in bit;
        -- Data Memory
        dmem_addr,
        dmem_dati: out bit_vector(63 downto 0);
        dmem_dato: in bit_vector(63 downto 0);
        dmem_we: out bit;
        -- Instruction memory
        imem_addr: out bit_vector(63 downto 0);
        imem_data: in bit_vector(31 downto 0)
    );
end entity;

architecture arch of polilegsc is

    component controlunit is
        port(
            -- To Datapath
            reg2loc,
            uncondBranch,
            branch,
            memRead,
            memToReg: out bit;
            aluOp: out bit_vector(1 downto 0);
            memWrite,
            aluSrc,
            regWrite: out bit;
            -- From Datapath
            opcode: in bit_vector(10 downto 0)
        );
    end component;

    component alucontrol is
        port(
            aluop: in bit_vector(1 downto 0);
            opcode: in bit_vector(10 downto 0);
            aluCtrl: out bit_vector(3 downto 0)
        );
    end component;

    component datapath is
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
    end component datapath;
    
    signal uncondBranch, branch: bit;
    signal memRead, memWrite: bit;
    signal aluOp: bit_vector(1 downto 0);

    signal reg2loc, pcSrc, memToReg: bit;
    signal aluCtrl: bit_vector(3 downto 0);
    signal aluSrc, regWrite: bit;
    -- To Control Unit
    signal opcode: bit_vector(10 downto 0);
    signal zero: bit;
    -- IM terface
    signal imAddr: bit_vector(63 downto 0);
    signal imOut: bit_vector(31 downto 0);
    -- DM terface
    signal dmAddr, dmIn: bit_vector(63 downto 0);
    signal dmOut: bit_vector(63 downto 0);

begin

    dmem_we <= memWrite and (not memRead);

    pcSrc <= uncondBranch or (branch and zero);

    cu: controlunit port map(
        reg2loc,
        uncondBranch,
        branch,
        memRead,
        memToReg,
        aluOp,
        memWrite,
        aluSrc,
        regWrite,
        opcode
    );

    aluCu: alucontrol port map(
        aluOp,
        opcode,
        aluCtrl
    );

    dp: datapath port map(
        clock, reset,
        reg2loc,
        pcSrc,
        memToReg,
        aluCtrl,
        aluSrc,
        regWrite,
        opcode,
        zero,
        imem_addr,
        imem_data,
        dmem_addr,
        dmem_dati,
        dmem_dato
    );

end architecture arch;
