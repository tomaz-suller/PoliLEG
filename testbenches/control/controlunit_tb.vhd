library ieee;
use ieee.numeric_std.std_match;
use ieee.std_logic_1164.all;

use work.utils.all;

entity controlunit_tb is
end entity;

architecture arch of controlunit_tb is

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

    type test_case_type is record
        stimulus: std_logic_vector(10 downto 0);
        response: std_logic_vector(9 downto 0);
    end record;
    type test_case_array is array(1 to 5) of test_case_type;
    constant TEST_CASES: test_case_array := (
        ( -- LDUR
            "11111000010",
            "-001100011"),
        ( -- STUR
            "11111000000",
            "1000-00110"),
        ( -- CBZ
            "10110100---",
            "1010-01000"),
        ( -- B
            "000101-----",
            "-1-----0-0"),
        ( -- R type
            "1--0101-000",
            "0000010001")
    );

    signal opcode: bit_vector(10 downto 0);
    signal controlSignals: bit_vector(9 downto 0);

begin

	dut: controlunit port map(
        controlSignals(9),
        controlSignals(8),
        controlSignals(7),
        controlSignals(6),
        controlSignals(5),
        controlSignals(4 downto 3),
        controlSignals(2),
        controlSignals(1),
        controlSignals(0),
        opcode
    );

	tb: process
	begin
		report "BOT";

        for index in TEST_CASES'range loop
            opcode <= to_bitvector(TEST_CASES(index).stimulus);
            wait for 1 ps;
            assert_equals(TEST_CASES(index).response, controlSignals, index);
        end loop;

		report "EOT";
		wait;
	end process;

end architecture arch;
