entity alucontrol is
    port(
        aluop: in bit_vector(1 downto 0);
        opcode: in bit_vector(10 downto 0);
        aluCtrl: out bit_vector(3 downto 0)
    );
end entity;
architecture arch of alucontrol is
    signal aluCtrlR: bit_vector(3 downto 0);
begin

    aluCtrlR <= (
        3 => '0',
        2 => opcode(9),
        1 => opcode(3),
        0 => opcode(8)
    );

    with aluop select aluCtrl <=
        "0010"      when "00",
        "0111"      when "01",
        aluCtrlR    when others;

end architecture arch;
