entity signExtend is
    port(
        i: in  bit_vector(31 downto 0);
        o: out bit_vector(63 downto 0)
    );
end signExtend;

architecture combinational of signExtend is
    signal dFormatToExtend: bit_vector(8 downto 0);
    signal cbzToExtend:     bit_vector(18 downto 0);
    signal bToExtend:       bit_vector(25 downto 0);
begin
    dFormatToExtend <= i(20 downto 12);
    cbzToExtend <= i(23 downto 5);
    bToExtend <= i(25 downto 0);

    o <=
        (37 downto 0 => bToExtend(25)) & bToExtend
            when i(31) = '0' else
        (44 downto 0 => cbzToExtend(18)) & cbzToExtend
            when i(30) = '0' else
        (54 downto 0 => dFormatToExtend(8)) & dFormatToExtend;

end architecture combinational;
