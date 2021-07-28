entity controlunit is
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
end entity;

architecture arch of controlunit is

begin

    reg2loc <= opcode(7);
    memToReg <= opcode(1);
    branch <= opcode(5);
    aluOp <= opcode(4) & opcode(5);
    uncondBranch <= not opcode(10);

    with opcode(7) select aluSrc <=
        opcode(9)   when '1',
        '0'         when others;

    with opcode(5) select memRead <=
        opcode(1)   when '0',
        '0'         when others;

    regWrite <= (opcode(10) and opcode(9) and opcode(1))
        or (not opcode(7));
    memWrite <= opcode(10) and opcode(9) and (not opcode(1))
        and opcode(7);

end architecture arch;
