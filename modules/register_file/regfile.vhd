library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity regfile is
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
end entity;
architecture toplevel of regfile is

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

    component decoder is
        generic(
            inputSizeInBits: natural := 5
        );
        port(
            in_bv: in bit_vector(inputSizeInBits-1 downto 0);
            out_bv: out bit_vector((2**inputSizeInBits)-1 downto 0)
        );
    end component;

    constant BANK_SIZE_IN_BITS: natural := natural(ceil(log2(real(regn))));
    signal registerWriteSelect: bit_vector(regn-1 downto 0);
    type bankOutType is array(regn-2 downto 0)
        of bit_vector(wordSize-1 downto 0);
    signal registerBankOut: bankOutType;
    signal integerR1, integerR2: natural;

begin
    dec: decoder
        generic map(BANK_SIZE_IN_BITS)
        port map(wr, registerWriteSelect);

    regBank: for i in regn-2 downto 0 generate
        Xi: reg
            generic map(
                wordSize
            )
            port map(
                clock, reset, regWrite, registerWriteSelect(i),
                d,
                registerBankOut(i)
            );
    end generate;

    integerR1 <= to_integer(unsigned(rr1));
    integerR2 <= to_integer(unsigned(rr2));

    q1 <= (others => '0') when integerR1 = regn-1 else
        registerBankOut(integerR1);
    q2 <= (others => '0') when integerR2 = regn-1 else
        registerBankOut(integerR2);

end architecture;
