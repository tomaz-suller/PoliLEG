entity Shiftleft2 is
    port(
        i: in bit_vector(63 downto 0);
        o: out bit_vector(63 downto 0)
    );
end entity Shiftleft2;
architecture arch of Shiftleft2 is
begin
    o <= i(61 downto 0) & "00";
end architecture arch;
