library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;
use ieee.std_logic_1164.all;

use work.utils.all;

entity regfile_tb is
end entity;

architecture arch of regfile_tb is

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

    constant NUMBER_OF_REGISTERS: natural := 4;
    constant WORD_SIZE_IN_BITS: natural := 4;
    constant BANK_SIZE_IN_BITS: natural := natural(ceil(log2(real(NUMBER_OF_REGISTERS)))); signal clock, reset, regWrite: bit;

    signal rr1, rr2, wr: bit_vector(BANK_SIZE_IN_BITS-1 downto 0);
    signal d, q1, q2: bit_vector(WORD_SIZE_IN_BITS-1 downto 0);

    constant CLOCK_PERIOD: time := 1 ns;
    signal simulate: bit := '0';

    type test_case_type is record
        regWrite: std_logic;
        rAddr1, rAddr2, wAddr: std_logic_vector(BANK_SIZE_IN_BITS-1 downto 0);
        wData, rData1, rData2: std_logic_vector(WORD_SIZE_IN_BITS-1 downto 0);
    end record;
    type test_case_array is array(1 to 14) of test_case_type;
    constant TEST_CASES: test_case_array := (
        -- Writing and reading on a single response
        ('1', "--", "--", "00", "0001", "----", "----"),
        ('0', "00", "--", "--", "----", "0001", "----"),
        ('0', "--", "00", "--", "----", "----", "0001"),
        ('1', "--", "--", "01", "0010", "----", "----"),
        ('0', "01", "--", "--", "----", "0010", "----"),
        ('0', "--", "01", "--", "----", "----", "0010"),
        ('1', "--", "--", "10", "0011", "----", "----"),
        ('0', "10", "--", "--", "----", "0011", "----"),
        ('0', "--", "10", "--", "----", "----", "0011"),
        -- The final register is XZR, which must always
        -- return 0 no matter what
        ('1', "--", "--", "11", "1010", "----", "----"),
        ('0', "11", "--", "--", "----", "0000", "----"),
        ('0', "--", "11", "--", "----", "----", "0000"),
        -- Reading multiple responses
        ('0', "00", "01", "--", "----", "0001", "0010"),
        ('0', "10", "11", "--", "----", "0011", "0000")
    );

begin

    dut: regfile
        generic map(
            NUMBER_OF_REGISTERS,
            WORD_SIZE_IN_BITS
        )
        port map(
            clock, reset, regWrite,
            rr1, rr2, wr,
            d,
            q1, q2
        );

    clock <= (not clock and simulate) after CLOCK_PERIOD/2;

    tb: process
    begin
        report "BOT";
        simulate <= '1';

        reset <= '1';
        wait for CLOCK_PERIOD/10;
        reset <= '0';
        wait until rising_edge(clock);

        for index in TEST_CASES'range loop
            regWrite <=     to_bit(TEST_CASES(index).regWrite);
            rr1 <=          to_bitvector(TEST_CASES(index).rAddr1);
            rr2 <=          to_bitvector(TEST_CASES(index).rAddr2);
            wr <=           to_bitvector(TEST_CASES(index).wAddr);
            d <=            to_bitvector(TEST_CASES(index).wData);
            wait for 1 ps;
            assert_equals(TEST_CASES(index).rData1, q1, index);
            assert_equals(TEST_CASES(index).rData2, q2, index);
            wait for CLOCK_PERIOD;
        end loop;

        reset <= '1';
        wait for CLOCK_PERIOD/10;
        reset <= '0';

        report "Reset test";
        for i in 3 downto 1 loop
            rr1 <= bit_vector(to_unsigned(i-1, 2));
            rr2 <= bit_vector(to_unsigned(i, 2));
            wait for 1 ps;
            assert_equals(bit_vector'("0000"), q1);
            assert_equals(bit_vector'("0000"), q2);
            wait for CLOCK_PERIOD;
        end loop;

        report "EOT";
        simulate <= '0';
        wait;
    end process;

end architecture arch;
